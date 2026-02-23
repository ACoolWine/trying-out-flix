def handleWithTimestamps(f: a -> b \ ef): (a -> b \ ef + Clock) = 
    x -> run {
        f(x)
    } with handler Logger {
        def log(s, m, k) = {
            ???
        }
    }