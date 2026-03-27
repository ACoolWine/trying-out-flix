import java.io.File
use Fs.FileRead
use Fs.FileWrite

def copyAndPaste(): Unit \ {IO} = {
    let res = run {
        let path1 = ".\\src\\file_copying\\copyFrom.txt";
        let path2 = ".\\src\\file_copying\\copyTo.txt";
        let text = match FileRead.read(path1) {
            case Ok(x) => x
            case Err(_) => "Oopsie doopsie"
        };
        FileWrite.write({str=text}, path2)
    } with FileRead.runWithIO
    with FileWrite.runWithIO;
    println(res);
    ()
}

def readFile(path: String): String \ {FileRead} = {
    let res = match FileRead.read(path) {
        case Ok(x) => x
        case Err(_) => "Oopsie doopsie"
    };
    res
}

def readFileWResult(path: String): String \ {FileRead} = {
    let result = FileRead.read(path);
    match result {
        case Ok(str) => str
        case Err(_) => "Ooopsie doooopsie"
    }
}

def writeFile(path: String, str: String): Unit \ {FileWrite} = {
    let _ = FileWrite.write({str=str}, path);
    ()
}

def writeFileWResult(path: String): Unit \ {FileWrite} = {
    let result = FileWrite.write({str="ksnaknsajknckja"}, path);
    match result {
        case Ok() => ()
        case Err(_) => ()
    }
}