import java.io.File
def copyAndPaste(): Unit \ {IO} = {
    let res = run {
        let path1 = ".\\copyFrom.txt";
        let path2 = ".\\copyTo.txt";
        let text = readFile(path1);
        writeFile(path2, text)
    } with FileRead.runWithIO
    with FileWrite.runWithIO;
    println(res);
    ()
}

def readFile(path: String): String \ {FileRead} = {
    let res = FileRead.read(path);
    res
}

def readFileWResult(path: String): String \ {FileReadWithResult} = {
    let result = FileReadWithResult.read(path);
    match result {
        case Ok(str) => str
        case Err(_) => "Ooopsie doooopsie"
    }
}

def writeFile(path: String, str: String): Unit \ {FileWrite} = {
    FileWrite.write({str=str}, path)
}

def writeFileWResult(path: String): Unit \ {FileWriteWithResult} = {
    let result = FileWriteWithResult.write({str="ksnaknsajknckja"}, path);
    match result {
        case Ok() => ()
        case Err(_) => ()
    }
}