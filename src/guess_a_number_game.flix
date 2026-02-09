use Assert.{assertEq, assertTrue, assertFalse, assertOk, assertErr}

eff RandNumber {
    def generateRandomNumber(): Int32
}

eff Guess {
    def makeGuess(): String
}

eff Terminal {
    def print(str: String): Unit 
}

def readAndParseGuess(): Result[String, Int32] \ Guess = {
    let guess = Guess.makeGuess();
    let guessParsed = Int32.parse(10, guess);
    guessParsed
}

def gameLoop2(secret: Int32): Int32 \ {Terminal, Guess} = {
    let parsedGuess = match readAndParseGuess() {
        case Result.Ok(g) => {
            if (secret == g) 
                { Terminal.print("Hooray, you got it! The number was ${secret}"); g }
            else {
                Terminal.print("No, that's not it. Try another guess:");
                let correct = gameLoop2(secret);
                correct
            }}
        case Result.Err(_) => {Terminal.print("Not a number, buhbye!"); -1}
    };
    parsedGuess
} 

def gameLoop1(): Int32 \ {RandNumber, Terminal, Guess} = {
    let secret = RandNumber.generateRandomNumber();

    Terminal.print("Guess a number between 0 and 9: "); 
    let answer = gameLoop2(secret);
    answer
}

def playGame(): Unit \ {IO, NonDet, Console} = {
    let numberBound = 10;
    let _ = run { gameLoop1() } with handler RandNumber {
        def generateRandomNumber(resume) = {
            let rnd = Random.randomInt32(); 
            let rndBounded = Int32.modulo(rnd, numberBound); 
            resume(rndBounded)
        }
    } with Random.runWithIO with handler Guess {
        def makeGuess(resume) = { let input = Console.readln(); resume(input) }
    } with handler Terminal {
        def print(str, resume) = { println(str); resume() }
    };
    ()
}

// ------------------------------------------ TESTS ------------------------------------------

@Test
def testCorrectGuess(): Unit \ Assert + {IO, NonDet, Console} = {
    let actual = run { 
        gameLoop1() 
    } with handler RandNumber {
        def generateRandomNumber(resume) = resume(5)
    } with handler Guess {
        def makeGuess(resume) = { 
            println("Guessing 5"); 
            resume("5") 
        }
    } with handler Terminal {
        def print(str, resume) = {println(str); resume()}
    };
    assertEq(expected=5, actual);
    ()
}


// -------------------------------------- Backtracking ---------------------------------------
// Very much unfinished, does not work
def playWithBacktrack(): Unit \ {IO, NonDet, Console} = {
    run playGame() 
    with handler Guess {
        def makeGuess(resume) = {
            resume("")
        }
    }
}