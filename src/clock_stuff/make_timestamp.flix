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
        mywait_Clock5(3);
        let tsString2 = Time.makeTimeString(ts);
        println("Non-object clock second time: ${Clock3.getTimeStamp()}");
        println("Object clock second time: ${tsString2}")
    } with Clock5.runWithIO 
    with Clock3.runWithIO

def runWithClock6_main(): Unit \ IO = 
    run {
        let ts = Clock6.getTimeObj();
        let tsString = runWithClock6_helper(ts);
        println("Object clock first time: ${tsString}");
        mywait_Clock6(3);
        let tsString2 = runWithClock6_helper(ts);
        println("Object clock second time: ${tsString2}")
    } with Clock6.runWithIO

def runWithClock6_helper(ts: Time): String \ Clock6 = 
    Clock6.getFormattedTimestamp(ts)


///////////////// Wait function for Clock 5//////////////////////
def myrecDelay_Clock5(f: Unit -> b \ ef, delay_t: Int64, now: Int64): b \ {Clock5} + ef = 
    let newTime = Clock5.currentTime(Time.TimeUnit.Seconds);
    if (newTime > now + delay_t) {
        f()
    } else {
        myrecDelay_Clock5(f, delay_t, now)
    }

def mywait_Clock5(t: Int32): Unit \ Clock5 = 
    let now = Clock5.currentTime(Time.TimeUnit.Seconds);
    let t_64 = Int32.toInt64(t);
    myrecDelay_Clock5(() -> (), t_64, now)

///////////////// Wait function for Clock 6//////////////////////
def myrecDelay_Clock6(f: Unit -> b \ ef, delay_t: Int64, now: Int64): b \ {Clock6} + ef = 
    let newTime = Clock6.currentTime(Time.TimeUnit.Seconds);
    if (newTime > now + delay_t) {
        f()
    } else {
        myrecDelay_Clock6(f, delay_t, now)
    }

def mywait_Clock6(t: Int32): Unit \ Clock6 = 
    let now = Clock6.currentTime(Time.TimeUnit.Seconds);
    let t_64 = Int32.toInt64(t);
    myrecDelay_Clock6(() -> (), t_64, now)