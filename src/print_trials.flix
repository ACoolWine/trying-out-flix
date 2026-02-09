// def main(): Unit \ IO = {
//     let collection = run {
//         print("A");
//         print("B");
//         print("C");
//         ""
//     } with handler Poopoo {
//         def println(str, resume) = {
//             let acc = resume();
//             let acc2 = str + ", " + acc;
//             acc2
//         }
//     };
//     println(collection);
//     ()
// }

def main(): Unit \ Poopoo = {
    Poopoo.stinkyprint("popopopop");
    Poopoo.stinkyprint("ksnjansa")

}

eff Poopoo {
    def stinkyprint(str: String): Unit
}

mod Poopoo {
    pub def printStupid(str: String): Unit \ Poopoo = {
        Poopoo.stinkyprint(str)
    }

    @DefaultHandler
    pub def runWithIO (f: Unit -> a \ ef): a \ (ef - Poopoo) + IO = {
        run {
            f()
        } with handler Poopoo {
            def stinkyprint(str, resume) = {
                let a = resume();
                println(str);
                a
            }
        }
    } 
}

// def print(str: String): Unit \ Poopoo = {
//     Poopoo.stinkyprint(str)
// }


