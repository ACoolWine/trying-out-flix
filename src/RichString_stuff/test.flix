def testy1(): Unit \ IO   = 
    let rs1 = RichString2.text("should be equal");
    let rs2 = RichString2.text("should be equal");
    let res = RichString2.compare(rs1, rs2);
    println(res)

def testy2(): Unit \ IO   = 
    let rs1 = RichString2.text("aaaaaaaaa");
    let rs2 = RichString2.text("bbbbbbbbb");
    let res = RichString2.compare(rs1, rs2);
    println(res)