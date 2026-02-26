def runIt(): Unit \ IO = 
    run {
        println(Clock2.getTimeStamp(Some("MM-dd")))
    } with Clock2.runWithIO