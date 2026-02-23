use RichString.{gray, cyan, green, yellow, red, bold, text};

def trying_logger(): Unit \ Console = {
    let _ = run {
        //Logger.info(42);
        Console.println("Wassup bud?");
        Console.eprintln("I'm an err print, man")
    } with runWithConsole;
    ()
}

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