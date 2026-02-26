///
/// An effect used to access the current (real-world) time.
///
eff Clock6 {

    ///
    /// Returns a measure of time since the epoch in the given time unit `u`.
    ///
    def currentTime(u: TimeUnit): Int64

    /// 
    /// Returns a `Time` object. 
    ///
    /// Uses Javas LocalDateTime.
    /// 
    def getTimeObj(): Time

    /// 
    /// Returns a String of the date and time contained in `timeObj`. 
    ///
    /// Uses Javas DateTimeFormatter and a predefined format.
    /// 
    def getFormattedTimestamp(timeObj: Time): String

}

pub mod Clock6 {

    import java.lang.System
    import java.util.concurrent.{TimeUnit => JTimeUnit}
    import java.time.LocalDateTime
    import java.time.format.DateTimeFormatter


    ///
    /// Returns the number of milliseconds since the epoch.
    ///
    /// Equivalent to `currentTime(TimeUnit.Milliseconds)`.
    ///
    pub def now(): Int64 \ Clock6 = Clock6.currentTime(TimeUnit.Milliseconds)

    ///
    /// Handles the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    pub def handle(f: a -> b \ ef): a -> b \ (ef - Clock6) + IO = x ->
        run {
            f(x)
        } with handler Clock6 {
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
            def getTimeObj(k) = 
                let timestamp = LocalDateTime.now();
                k(Time.Time(timestamp))
            def getFormattedTimestamp(timeObj, k) = 
                let formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                let javaObj = match timeObj {
                    case Time.Time(javaObj) => javaObj
                };
                k(javaObj.format(formatter))
        }

    ///
    /// Runs the `Clock` effect of the given function `f`.
    ///
    /// In other words, re-interprets the `Clock` effect using the `IO` effect.
    ///
    @DefaultHandler
    pub def runWithIO(f: Unit -> a \ ef): a \ (ef - Clock6) + IO = handle(f)()

}