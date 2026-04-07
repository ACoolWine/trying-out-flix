mod Timestamp {
    import java.time.{ZonedDateTime => JZonedDateTime}

    pub def getDay(): String \ IO = 
        let obj = JZonedDateTime.now();
        let someting = obj.getDayOfWeek()
}