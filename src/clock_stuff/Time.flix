import java.time.{LocalDateTime => JLocalDateTime}

enum Time (JLocalDateTime)

mod Time {
    import java.time.{LocalDateTime => JLocalDateTime}
    import java.time.format.DateTimeFormatter

    pub def makeTimeString(timeObj: Time): String \ IO = 
        let formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        let javaObj = match timeObj {
            case Time.Time(x) => x
        };
        javaObj.format(formatter)
}