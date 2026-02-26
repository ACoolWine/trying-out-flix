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

def runWithClock5(): Unit \ IO = 
    run {
        let ts = Clock5.getTimeObj();
        let tsString = Time.makeTimeString(ts);
        println("Non-object clock first time: ${Clock3.getTimeStamp()}");
        println("Object clock first time: ${tsString}");
        mywait(3);
        println("Non-object clock second time: ${Clock3.getTimeStamp()}");
        println("Object clock second time: ${tsString}")
    } with Clock5.runWithIO 
    with Clock3.runWithIO


def myrecDelay(f: Unit -> b \ ef, delay_t: Int64, now: Int64): b \ {Clock5} + ef = 
    let newTime = Clock5.currentTime(TimeUnit.Seconds);
    if (newTime > now + delay_t) {
        f()
    } else {
        myrecDelay(f, delay_t, now)
    }

def mywait(t: Int32): Unit \ Clock5 = 
    let now = Clock5.currentTime(TimeUnit.Seconds);
    let t_64 = Int32.toInt64(t);
    myrecDelay(() -> (), t_64, now)