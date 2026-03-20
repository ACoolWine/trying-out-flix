def handleWithTimestamps(f: a -> b \ ef): (a -> b \ ef + Time.Clock) = 
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            ???
        }
    }