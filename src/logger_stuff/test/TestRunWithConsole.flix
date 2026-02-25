def testRunWithConsole01(): Unit \ IO = 
    let m = RichString.fromString("Some string");
    let s = Severity.Fatal;
    run {
        Logger.log(s, m)
    } with runWithConsole
    with Console.runWithIO;
    run {
        Logger.log(s, m)
    } with Logger.runWithIO


def consoleHandlerStub(g: Unit -> String \ ef): String \ (ef - Console) = 
    run {
        g()
    } with handler Console {
        def println(s, k) = {
            let res = "Logging to Console: " + s + k();
            res
        }
        def readln(k) = ???
        def print(s, k) = ???
        def eprint(s, k) = ???
        def eprintln(s, k) = ???
    }

def testConsoleHandler01(): Unit \ Assert + IO =  
    let m = RichString.fromString("Some string");
    let s = Severity.Fatal;
    let res = run {
        Logger.log(s, m);
        println("");
        println(ToString.toString(s));
        println("");
        ""
    } with runWithConsole
    with consoleHandlerStub;
    let expected = "${RichString.toString(RichString.bold(RichString.red("[Fatal]")))} Some string";
    Assert.assertEq(expected="Logging to Console: " + expected, res)

def testConsoleHandlerErrVersion01(): Unit \ Assert + IO = 
    let m = RichString.fromString("Some string");
    let s = Severity.Fatal;
    let res = run {
        Logger.log(s, m);
        println("");
        println(ToString.toString(s));
        println("");
        ""
    } with runWithConsoleErrVersion
    with consoleHandlerStubErrVersion;
    let expected = "${RichString.toString(RichString.bold(RichString.red("[Fatal]")))} Some string";
    Assert.assertEq(expected="Logging to Console stderr: " + expected, res)

def testConsoleHandlerErrVersion201(): Unit \ Assert + IO = 
    let m = RichString.fromString("Some string");
    let s = Severity.Fatal;
    let res = run {
        Logger.log(s, m);   
        println("");
        println(ToString.toString(s));
        println("");
        ""
    } with runWithConsoleErrVersion
    with consoleHandlerStubErrVersion;
    let expected = "${RichString.toString(RichString.bold(RichString.red("[Fatal]")))} Some string";
    Assert.assertEq(expected="Logging to Console stderr: " + expected, res)

def runWithConsole02(): Unit \ Assert = 
    let m = RichString.fromString("Testing a warning string");
    let s = Severity.Warn;
    let res = run {
        Logger.log(s, m);
        ""
    } with runWithConsoleErrVersion
    with consoleHandlerStubErrVersion;
    let expected = "${RichString.toString(RichString.yellow("[Warn]"))} Testing a warning string";
    Assert.assertEq(expected="Logging to Console stderr: " + expected, res)


def consoleHandlerStubErrVersion(g: Unit -> String \ ef): String \ (ef - Console) = 
    run {
        g()
    } with handler Console {
        def println(s, k) = {
            let res = "Logging to Console stdout: " + s + k();
            res
        }
        def readln(_) = unreachable!()
        def print(_, _) = unreachable!()
        def eprint(_, _) = unreachable!()
        def eprintln(s, k) = {
            let res = "Logging to Console stderr: " + s + k();
            res
        }
    }

def handleWithConsoleFun01(): Unit \ Assert = 
    let m = RichString.fromString("Testing a warning string with a stdout fun");
    let s = Severity.Warn;
    let res = run {
        Logger.log(s, m);
        ""
    } with runWithConsoleFun(Console.println)
    with consoleHandlerStubErrVersion;
    let expected = "${RichString.toString(RichString.yellow("[Warn]"))} Testing a warning string with a stdout fun";
    Assert.assertEq(expected="Logging to Console stdout: " + expected, res)

def handleWithConsoleFun02(): Unit \ Assert = 
    let m = RichString.fromString("Testing a debug string with a stderr fun");
    let s = Severity.Debug;
    let res = run {
        Logger.log(s, m);
        ""
    } with runWithConsoleFun(Console.eprintln)
    with consoleHandlerStubErrVersion;
    let expected = "${RichString.toString(RichString.cyan("[Debug]"))} Testing a debug string with a stderr fun";
    Assert.assertEq(expected="Logging to Console stderr: " + expected, res)
