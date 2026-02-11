def retryOnFail(x: Int32, f: a -> Result[b, c] \ ef): (a -> Result[b, c] \ ef + IO) = {
    y -> {
        let res = f(y);
        match res {
            case Ok(gucchi) => Ok(gucchi)
            case Err(er)     => {
                if (x > 0) {
                    println("stinky attempt >:|"); retryOnFail(x-1, f)(y)
                } else {
                    Err(er)
                }
            }
        }
    }
}

def runDnsWithRetry(): Unit \ IO = {
    let res = run {
        retryOnFail(2, DnsWithResult.lookup)("wikipedia.org")
    } with DnsWithResult.runWithIO;
    println(res)
}

def runDnsWithRetry_HandlerVersion(): Unit \ IO = {
    let res = run {
        DnsWithResult.lookup("wikipedia.org")
    } with retryOnFail(2, DnsWithResult.runWithIO);
    println(res)
}

def runDnsWithRetry_WithoutResult(): Unit \ IO = {
    let res = run {
        Dns.lookup("wikipedia.org")
    } with retryOnFail(2, Dns.runWithIO);
    println(res)
}

def runFileReadWithRetry(): Unit \ IO = {
    let res = run {
        retryOnFail(5, FileReadWithResult.exists)(".\\src\\print_trials.flix")
    } with FileReadWithResult.runWithIO;
    println(res)
}


// --------------------- Functions implementing sleep ---------------------
def recDelay(f: Unit -> b \ ef, delay_t: Int64, now: Int64): b \ {Clock} + ef = 
    let newTime = Clock.currentTime(TimeUnit.Seconds);
    if (newTime > now + delay_t) {
        f()
    } else {
        recDelay(f, delay_t, now)
    }
    
def wait(t: Int32): Unit \ Clock = 
    let now = Clock.currentTime(TimeUnit.Seconds);
    let t_64 = Int32.toInt64(t);
    recDelay(() -> (), t_64, now)