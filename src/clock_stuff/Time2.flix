import java.time.{LocalDateTime => JLocalDateTime}

enum Time2 (JLocalDateTime)


////////// Not needed for Clock 6 ////////////
mod Time2 {
    import java.time.{LocalDateTime => JLocalDateTime}
    import java.time.format.DateTimeFormatter

    pub def makeTimeString(timeObj: Time2): String \ IO = 
        let formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        let javaObj = match timeObj {
            case Time2.Time2(x) => x
        };
        javaObj.format(formatter)
}