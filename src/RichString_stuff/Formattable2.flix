///
/// A trait for types that can be formatted as a `RichString2`.
///
pub trait Formattable2[a] {
    ///
    /// The associated effect of the Formattable2 which represents the effect of formatting.
    ///
    type Aef[a]: Eff = {}

    pub def format(x: a): RichString2 \ Formattable2.Aef[a]
}

instance Formattable2[Unit] {
    pub def format(x: Unit): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Bool] {
    pub def format(x: Bool): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Char] {
    pub def format(x: Char): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Int8] {
    pub def format(x: Int8): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Int16] {
    pub def format(x: Int16): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Int32] {
    pub def format(x: Int32): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Int64] {
    pub def format(x: Int64): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Float32] {
    pub def format(x: Float32): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[Float64] {
    pub def format(x: Float64): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[String] {
    pub def format(x: String): RichString2 = RichString2.fromString(x)
}

instance Formattable2[BigInt] {
    pub def format(x: BigInt): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[BigDecimal] {
    pub def format(x: BigDecimal): RichString2 = RichString2.fromString(ToString.toString(x))
}

instance Formattable2[(a1, a2)] with Formattable2[a1], Formattable2[a2] {
    type Aef[(a1, a2)] = Formattable2.Aef[a1] + Formattable2.Aef[a2]

    pub def format(x: (a1, a2)): RichString2 \ Formattable2.Aef[a1] + Formattable2.Aef[a2] =
        let (v1, v2) = x;
        RichString2.fromString("(") + Formattable2.format(v1) + RichString2.fromString(", ") + Formattable2.format(v2) + RichString2.fromString(")")
}