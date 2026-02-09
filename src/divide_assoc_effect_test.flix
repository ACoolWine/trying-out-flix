eff DivByZero {
    def raise(): Void
}

trait MyDiv[t] {
    type Aef: Eff
    pub def divide(a: t, b: t): t \ MyDiv.Aef[t]
}
instance MyDiv[Int32] {
    type Aef = { DivByZero }
    pub def divide(a: Int32, b: Int32): Int32 \ DivByZero = {
        if (b == 0) DivByZero.raise() else a / b
    }
}
instance MyDiv[Float64] {
    type Aef = { }
    pub def divide(a: Float64, b: Float64): Float64 \ { } = a / b
}

trait MyAdd[t] {
    pub def sum(lst: List[t]): t
}
instance MyAdd[Int32] {
    pub def sum(lst: List[Int32]): Int32 = List.foldLeft(x -> y -> x + y, 0, lst)
}
instance MyAdd[Float64] {
    pub def sum(lst: List[Float64]): Float64 = List.foldLeft(x -> y -> x + y, 0.0, lst)
}

trait TypedLength[t] {
    pub def length(lst: List[t]): t
}
instance TypedLength[Int32] {
    pub def length(lst: List[Int32]): Int32 = List.length(lst)
}
instance TypedLength[Float64] {
    pub def length(lst: List[Float64]): Float64 = Int32.toFloat64(List.length(lst))
}

def average(lst: List[a]): a \ MyDiv.Aef[a] with MyDiv[a], MyAdd[a], TypedLength[a] = {
    MyDiv.divide(TypedLength.length(lst), MyAdd.sum(lst))
}


def runAssocEffectTest(): Unit \ IO = {
    let _ = run {
        let lst = List#{0.0, 0.0};
        println(average(lst))
    } with handler DivByZero {
        def raise(_) = println("AH-  >:O")
    };
    ()
}