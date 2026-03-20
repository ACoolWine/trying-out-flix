/*
 *  Copyright 2025 Magnus Madsen
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

///
/// An effect used to log messages.
///
pub eff Logger2 {

    ///
    /// Logs the given message `m` at the given severity `s`.
    ///
    def log(s: Severity, m: RichString): Unit

}

pub mod Logger2 {

    use Sys.Console
    use RichString.{gray, cyan, green, yellow, red, bold, text};
    use Severity.{Warn, Fatal, Trace, Debug, Info}

    ///
    /// Logs the message `m` at the `Trace` level.
    ///
    pub def trace(m: a): Unit \ (Logger2 + Formattable.Aef[a]) with Formattable[a] = Logger2.log(Trace, Formattable.format(m))

    ///
    /// Logs the message `m` at the `Debug` level.
    ///
    pub def debug(m: a): Unit \ (Logger2 + Formattable.Aef[a]) with Formattable[a] = Logger2.log(Debug, Formattable.format(m))

    ///
    /// Logs the message `m` at the `Info` level.
    ///
    pub def info(m: a): Unit \ (Logger2 + Formattable.Aef[a]) with Formattable[a] = Logger2.log(Info, Formattable.format(m))

    ///
    /// Logs the message `m` at the `Warn` level.
    ///
    pub def warn(m: a): Unit \ (Logger2 + Formattable.Aef[a]) with Formattable[a] = Logger2.log(Warn, Formattable.format(m))

    ///
    /// Logs the message `m` at the `Fatal` level.
    ///
    pub def fatal(m: a): Unit \ (Logger2 + Formattable.Aef[a]) with Formattable[a] = Logger2.log(Fatal, Formattable.format(m))

    ///
    /// Handles the `Logger2` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Logger2` effect using the `IO` effect.
    ///
    pub def handle(f: a -> b \ ef): a -> b \ (ef - Logger2) + IO = x ->
        run {
            f(x)
        } with handler Logger2 {
            def log(s, m, k) = {
                let prefix = match s {
                    case Trace => gray("[Trace]")
                    case Debug => cyan("[Debug]")
                    case Info  => green("[Info]")
                    case Warn  => yellow("[Warn]")
                    case Fatal => bold(red("[Fatal]"))
                };
                let output = prefix + text(" ") + m;
                println(RichString.toString(output));
                k()
            }
        }

    ///
    /// Runs the `Logger2` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Logger2` effect using the `IO` effect.
    ///
    @DefaultHandler
    pub def runWithIO(f: Unit -> a \ ef): a \ (ef - Logger2) + IO = handle(f)()

    ///
    /// Handles the `Logger2` effect of the given function `f`.
    /// 
    /// In other words, re-interprets the `Logger2` effect using the `Console` effect.
    ///
    pub def handleWithConsole(f: a -> b \ ef): (a -> b \ ef - Logger2 + Console) = 
        x -> run {
            f(x)
        } with handler Logger2 {
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
    /// Runs the `Logger2` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Logger2` effect using the `Console` effect.
    ///
    pub def runWithConsole(f: Unit -> a \ ef): a \ ef - Logger2 + Console = handleWithConsole(f)()

    ///
    /// Aborts with the message `m` from `Logger2.log` if given function `g` returns true.
    /// Otherwise, lets `Logger2` effect propagate.
    ///
    pub def handleWithAbort(g: (Severity, RichString) -> Bool \ ef1, f: a -> b \ ef2): a -> b \ ef1 + ef2 + Abort + Logger2 = 
        x -> run {
            f(x)
        } with handler Logger2 {
            def log(s, m, k) =
                if (g(s, m)) {
                    Abort.abort(m)
                } else {
                    Logger2.log(s, m); k()
                }
            }

    ///
    /// Aborts with the message `m` from `Logger2.log` if given function `g` returns true.
    /// Otherwise, lets `Logger2` effect propagate.
    ///
    pub def runWithAbort(g: (Severity, RichString) -> Bool \ ef1, f: Unit -> a \ ef2): a \ ef1 + ef2 + Abort + Logger2 = 
        handleWithAbort(g, f)() 

    ///
    /// Handles the `Logger2` effect of the given function `f`.
    ///
    /// In other words, returns a list of `(Severity, RichString)` that represents and is ordered by the calls to log.
    ///
    pub def handleWithList(f: a -> b \ ef): a -> (b, List[(Severity, RichString)]) \ (ef - Logger2) =
        x -> run {
            (f(x), List.empty())
        } with handler Logger2 {
            def log(s, m, k) = {
                let (r, l) = k();
                (r, (s, m) :: l)
            }
        }

    ///
    /// Runs the `Logger2` effect of the given function `f`.
    ///
    /// In other words, returns a list of `(Severity, RichString)` that represents and is ordered by the calls to log.
    ///
    pub def runWithList(f: Unit -> b \ ef): (b, List[(Severity, RichString)]) \ (ef - Logger2) = handleWithList(f)()

    ///
    /// Handles the `Logger2` effect of the given function `f`.
    ///
    /// Filters the logging, by the `filter` function.
    ///
    pub def handleWithFilter(filter: (Severity, RichString) -> Bool \ ef1, f: a -> b \ ef2): a -> b \ (ef2 - Logger2) + Logger2 + ef1 = 
        x -> run {
            f(x)
        } with handler Logger2 {
            def log(s, m, k) = {
                if (filter(s, m)) {
                    Logger2.log(s, m);
                    k()
                } else {
                    k()
                }
            }
        }

    ///
    /// Runs the `Logger2` effect of the given function `f`.
    ///
    /// Filters the logging, by the `filter` function.
    ///
    pub def runWithFilter(filter: (Severity, RichString) -> Bool \ ef1, f: Unit -> b \ ef2): b \ (ef2 - Logger2) + Logger2 + ef1 = handleWithFilter(filter, f)()
    
    ///
    /// Filters logs with greater or equal severity level
    ///
    pub def runWithSeverityFilter(s: Severity, f: Unit -> b \ ef): b \ (ef - Logger2) + Logger2 =
        run {
            f()
        } with runWithFilter((sev, _) -> Order.greaterEqual(sev, s))

}
