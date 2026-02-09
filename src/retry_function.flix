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

def runWithRetry(): Unit \ IO = {
    let res = run {
        retryOnFail(2, DnsWithResult.lookup)("wikipedia.org")
    } with DnsWithResult.runWithIO;
    println(res)
}

def runWithRetry_HandlerVersion(): Unit \ IO = {
    let res = run {
        retryOnFail(2, DnsWithResult.lookup)("wikipedia.org")
    } with DnsWithResult.runWithIO;
    println(res)
}


