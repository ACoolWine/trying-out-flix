///
/// An effect used to access the current (real-world) time.
///
eff Clock3 {

    ///
    /// Returns a measure of time since the epoch in the given time unit `u`.
    ///
    def currentTime(u: Time.TimeUnit): Int64

    /// 
    /// Returns a timestamp of format yyyy-MM-dd HH:mm:ss. 
    ///
    /// Uses Javas DateTimeFormatter class to format the timestamp.
    /// 
    def getTimeStamp(): String

}

pub mod Clock3 {

    import java.lang.System
    import java.util.concurrent.{TimeUnit => JTimeUnit}
    import java.time.LocalDateTime
    import java.time.format.DateTimeFormatter


    ///
    /// Returns the number of milliseconds since the epoch.
    ///
    /// Equivalent to `currentTime(TimeUnit.Milliseconds)`.
    ///
    pub def now(): Int64 \ Clock3 = Clock3.currentTime(Time.TimeUnit.Milliseconds)

    ///
    /// Handles the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    pub def handle(f: a -> b \ ef): a -> b \ (ef - Clock3) + IO = x ->
        run {
            f(x)
        } with handler Clock3 {
            def currentTime(u, k) = 
                let time = System.currentTimeMillis();
                let ms = JTimeUnit.MILLISECONDS;
                match u {
                    case Time.TimeUnit.Days          => k(ms.toDays(time))
                    case Time.TimeUnit.Hours         => k(ms.toHours(time))
                    case Time.TimeUnit.Microseconds  => k(ms.toMicros(time))
                    case Time.TimeUnit.Milliseconds  => k(ms.toMillis(time))
                    case Time.TimeUnit.Minutes       => k(ms.toMinutes(time))
                    case Time.TimeUnit.Nanoseconds   => k(ms.toNanos(time))
                    case Time.TimeUnit.Seconds       => k(ms.toSeconds(time))
                }
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
    pub def runWithIO(f: Unit -> a \ ef): a \ (ef - Clock3) + IO = handle(f)()

}