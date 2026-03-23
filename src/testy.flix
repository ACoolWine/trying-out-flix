def testing_timeunit(): Unit \ IO = 
    println(Time.TimeUnit.toMilliseconds(Time.TimeUnit.Days))

def testing_duration(): Unit \ IO = 
    println(Time.Duration.days(1))