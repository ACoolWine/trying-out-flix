def runWithClock2(): Unit \ IO = 
    run {
        println(Clock2.getTimeStamp(Some("MM-dd")));
        println(Clock2.getTimeStamp(None))
    } with Clock2.runWithIO

def runWithClock3(): Unit \ IO = 
    run {
        println(Clock3.getTimeStamp())
    } with Clock3.runWithIO

def runWithClock4(): Unit \ IO = 
    run {
        println(Clock4.getCustomTimeStamp("MM-dd"));
        println(Clock4.getTimeStamp())
    } with Clock4.runWithIO
