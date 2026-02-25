use RichString.{gray, cyan, green, yellow, red, bold, text};

def trying_logger(): Unit \ Console = {
    let _ = run {
        Logger.info(42);
        Console.println("Wassup bud?");
        Console.eprintln("I'm an err print, man")
    } with runWithConsole;
    ()
}

// Version 1
def handleWithConsole(f: a -> b \ ef): (a -> b \ ef - Logger + Console) = 
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            let prefix = match s {
                case Severity.Debug => cyan("[Debug]")
                case Severity.Fatal => bold(red("[Fatal]"))
                case Severity.Info  => green("[Info]")
                case Severity.Trace => gray("[Trace]")
                case Severity.Warn  => yellow("[Warn]")
            };
            let output = prefix + text(" ") + m;
            Console.println(RichString.toString(output));
            k()
        }
    }

def runWithConsole(f: Unit -> a \ ef): a \ ef - Logger + Console = handleWithConsole(f)()


// Version 2
def handleWithConsoleErrVersion(f: a -> b \ ef): (a -> b \ ef - Logger + Console) =
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            let prefix = match s {
                case Severity.Debug => cyan("[Debug]")
                case Severity.Fatal => bold(red("[Fatal]"))
                case Severity.Info  => green("[Info]")
                case Severity.Trace => gray("[Trace]")
                case Severity.Warn  => yellow("[Warn]")
            };
            let output = prefix + text(" ") + m;
            if (s==Severity.Warn or s==Severity.Fatal) 
                Console.eprintln(RichString.toString(output))
            else
                Console.println(RichString.toString(output));
            k()
        }
    }

def runWithConsoleErrVersion(f: Unit -> a \ ef): a \ ef - Logger + Console = handleWithConsoleErrVersion(f)()


//Version 3
pub def handleWithConsoleFun(consoleFun: String -> d \ ef1, f: a -> b \ ef2): (a -> b \ ef2 - Logger + ef1) = 
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            let prefix = match s {
                case Severity.Debug => cyan("[Debug]")
                case Severity.Fatal => bold(red("[Fatal]"))
                case Severity.Info  => green("[Info]")
                case Severity.Trace => gray("[Trace]")
                case Severity.Warn  => yellow("[Warn]")
            };
            let output = prefix + text(" ") + m;
            let _ = consoleFun(RichString.toString(output));
            k()
        }
    }

pub def runWithConsoleFun(consoleFun: String -> d \ ef1, f: Unit -> a \ ef2): a \ ef2 - Logger + ef1 = handleWithConsoleFun(consoleFun, f)()


//Version 4
///
/// Handles the `Logger` effect of the given function `f`.
/// 
/// In other words, re-interprets the `Logger` effect using the `Console` effect.
///
/// Prints to standard out.
///
pub def handleWithConsoleStdOut(f: a -> b \ ef): (a -> b \ ef - Logger + Console) = 
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            let prefix = match s {
                case Severity.Debug => cyan("[Debug]")
                case Severity.Fatal => bold(red("[Fatal]"))
                case Severity.Info  => green("[Info]")
                case Severity.Trace => gray("[Trace]")
                case Severity.Warn  => yellow("[Warn]")
            };
            let output = prefix + text(" ") + m;
            Console.println(RichString.toString(output));
            k()
        }
    }

///
/// Runs the `Logger` effect of the given function `f`.
///
/// In other words, re-interprets the `Logger` effect using the `Console` effect.
///
/// Prints to standard out.
///
pub def runWithConsoleStdOut(f: Unit -> a \ ef): a \ ef - Logger + Console = handleWithConsoleStdOut(f)()

///
/// Handles the `Logger` effect of the given function `f`.
/// 
/// In other words, re-interprets the `Logger` effect using the `Console` effect.
///
/// Prints to standard error.
///
pub def handleWithConsoleStdErr(f: a -> b \ ef): (a -> b \ ef - Logger + Console) = 
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            let prefix = match s {
                case Severity.Debug => cyan("[Debug]")
                case Severity.Fatal => bold(red("[Fatal]"))
                case Severity.Info  => green("[Info]")
                case Severity.Trace => gray("[Trace]")
                case Severity.Warn  => yellow("[Warn]")
            };
            let output = prefix + text(" ") + m;
            Console.eprintln(RichString.toString(output));
            k()
        }
    }

///
/// Runs the `Logger` effect of the given function `f`.
///
/// In other words, re-interprets the `Logger` effect using the `Console` effect.
///
/// Prints to standard error.
///
pub def runWithConsoleStdErr(f: Unit -> a \ ef): a \ ef - Logger + Console = handleWithConsoleStdErr(f)()