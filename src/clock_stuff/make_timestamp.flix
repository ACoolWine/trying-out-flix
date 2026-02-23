def makeTimestamp(): Unit \ IO = 
    let _ = run {
        let timestamp = Clock.currentTime(TimeUnit.Seconds);
        println(timestamp)
    } with Clock.runWithIO;
    ()