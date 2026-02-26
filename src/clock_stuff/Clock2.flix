///
/// An effect used to access the current (real-world) time.
///
eff Clock2 {

    ///
    /// Returns a measure of time since the epoch in the given time unit `u`.
    ///
    def currentTime(u: TimeUnit): Int64

    /// 
    /// Returns a timestamp of format yyyy-MM-dd HH:mm:ss. 
    ///
    /// Uses Javas DateTimeFormatter class to format the timestamp.
    /// 
    def getTimeStamp(customFormatter: Option[String]): String

}

pub mod Clock2 {

    import java.lang.System
    import java.util.concurrent.{TimeUnit => JTimeUnit}
    import java.time.LocalDateTime
    import java.time.format.DateTimeFormatter


    ///
    /// Returns the number of milliseconds since the epoch.
    ///
    /// Equivalent to `currentTime(TimeUnit.Milliseconds)`.
    ///
    pub def now(): Int64 \ Clock2 = Clock2.currentTime(TimeUnit.Milliseconds)

    ///
    /// Handles the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    pub def handle(f: a -> b \ ef): a -> b \ (ef - Clock2) + IO = x ->
        run {
            f(x)
        } with handler Clock2 {
            def currentTime(u, k) = 
                let time = System.currentTimeMillis();
                let ms = JTimeUnit.MILLISECONDS;
                match u {
                    case TimeUnit.Days          => k(ms.toDays(time))
                    case TimeUnit.Hours         => k(ms.toHours(time))
                    case TimeUnit.Microseconds  => k(ms.toMicros(time))
                    case TimeUnit.Milliseconds  => k(ms.toMillis(time))
                    case TimeUnit.Minutes       => k(ms.toMinutes(time))
                    case TimeUnit.Nanoseconds   => k(ms.toNanos(time))
                    case TimeUnit.Seconds       => k(ms.toSeconds(time))
                }
            def getTimeStamp(formatStr, k) = 
                let formatter = match formatStr {
                    case Some(s) => DateTimeFormatter.ofPattern(s)
                    case None => DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                };
                let timestamp = LocalDateTime.now().format(formatter);
                k(timestamp)
        }

    ///
    /// Runs the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    @DefaultHandler
    pub def runWithIO(f: Unit -> a \ ef): a \ (ef - Clock2) + IO = handle(f)()

}