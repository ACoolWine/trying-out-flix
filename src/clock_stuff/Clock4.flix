///
/// An effect used to access the current (real-world) time.
///
eff Clock4 {

    ///
    /// Returns a measure of time since the epoch in the given time unit `u`.
    ///
    def currentTime(u: TimeUnit): Int64

    /// 
    /// Returns a timestamp of format yyyy-MM-dd HH:mm:ss. 
    ///
    /// Uses Javas DateTimeFormatter class to format the timestamp.
    /// 
    def getTimeStamp(): String

    /// 
    /// Returns a timestamp of custom format. 
    ///
    /// Uses Javas DateTimeFormatter class to format the timestamp.
    /// 
    def getCustomTimeStamp(customFormatter: String): String

}

pub mod Clock4 {

    import java.lang.System
    import java.util.concurrent.{TimeUnit => JTimeUnit}
    import java.time.LocalDateTime
    import java.time.format.DateTimeFormatter


    ///
    /// Returns the number of milliseconds since the epoch.
    ///
    /// Equivalent to `currentTime(TimeUnit.Milliseconds)`.
    ///
    pub def now(): Int64 \ Clock4 = Clock4.currentTime(TimeUnit.Milliseconds)

    ///
    /// Handles the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    pub def handle(f: a -> b \ ef): a -> b \ (ef - Clock4) + IO = x ->
        run {
            f(x)
        } with handler Clock4 {
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
            def getCustomTimeStamp(formatStr, k) = 
                let formatter = DateTimeFormatter.ofPattern(formatStr);
                let timestamp = LocalDateTime.now().format(formatter);
                k(timestamp)
            def getTimeStamp(k) = 
                let formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                let timestamp = LocalDateTime.now().format(formatter);
                k(timestamp)
        }

    ///
    /// Runs the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    @DefaultHandler
    pub def runWithIO(f: Unit -> a \ ef): a \ (ef - Clock4) + IO = handle(f)()

}