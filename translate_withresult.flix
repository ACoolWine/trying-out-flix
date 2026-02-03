def runit(): Unit \ IO = {
    let first_res = run {
        usingBaseDNS();
        translateToBase(usingDNSWithResult /* why in the everloving fuck is this not a function type???????? */ )() 
    } with Dns.runWithIO with DnsWithResult.runWithIO;
    match first_res {
        case Ok(x) => x
        case Err(_) => println("Base DNS error (after running the DNS method)")
    };

    println(""); println(first_res); println("");
    
    let fala2 = run {
        let fala = translateToWithResult(usingBaseDNS)();
        usingDNSWithResult();
        fala
    } with DnsWithResult.runWithIO;
    match fala2 {
        case Ok(x) => x
        case Err(_) => println("oopsie nops")
    };
    ()
}

def translateToWithResult(f: a -> b \ ef): (a -> Result[IoError, b] \ ef - Dns + DnsWithResult) = {
    y -> run {
        Ok(f(y))
    } with handler Dns {
        def lookup(host, k) = {
            let ip_res = DnsWithResult.lookup(host);
            match ip_res {
                case Ok(x) => k(x)
                case Err(er) => Err(er)
            }
        }
        def lookupAll(host, k) = {
            let ip_res = DnsWithResult.lookupAll(host);
            match ip_res {
                case Ok(x) => k(x)
                case Err(er) => Err(er)
            }
        }
    }
}

def translateToBase(f: a -> b \ ef): (a -> b \ ef - DnsWithResult + Dns) = {
    y -> run {
        f(y) 
    } with handler DnsWithResult {
        def lookup(host, k) = {
            let ip = Dns.lookup(host);
            k(Ok(ip))
        }
        def lookupAll(host, k) = {
            let ip = Dns.lookupAll(host);
            k(Ok(ip))
        }
    }
}

def usingBaseDNS(): Unit \ {IO, Dns} = {
    let res = Dns.lookup("wikipedia.org");
    println(res)
}

def usingDNSWithResult(): Unit \ {IO, DnsWithResult} = {
    let res = DnsWithResult.lookup("wikipedia.org");
    match res {
        case Ok(x) => println(x)
        case Err(_) => println("WithResult DNS error (as part of running the DNS method)")
    }
}