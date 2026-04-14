///
/// A trait for types that can be formatted as a `RichString3`.
///
pub trait Formattable3[a] {
    ///
    /// The associated effect of the Formattable3 which represents the effect of formatting.
    ///
    type Aef[a]: Eff = {}

    pub def format(x: a): RichString3 \ Formattable3.Aef[a]
}

instance Formattable3[Unit] {
    pub def format(x: Unit): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Bool] {
    pub def format(x: Bool): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Char] {
    pub def format(x: Char): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Int8] {
    pub def format(x: Int8): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Int16] {
    pub def format(x: Int16): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Int32] {
    pub def format(x: Int32): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Int64] {
    pub def format(x: Int64): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Float32] {
    pub def format(x: Float32): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[Float64] {
    pub def format(x: Float64): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[String] {
    pub def format(x: String): RichString3 = RichString3.fromString(x)
}

instance Formattable3[BigInt] {
    pub def format(x: BigInt): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[BigDecimal] {
    pub def format(x: BigDecimal): RichString3 = RichString3.fromString(ToString.toString(x))
}

instance Formattable3[(a1, a2)] with Formattable3[a1], Formattable3[a2] {
    type Aef[(a1, a2)] = Formattable3.Aef[a1] + Formattable3.Aef[a2]

    pub def format(x: (a1, a2)): RichString3 \ Formattable3.Aef[a1] + Formattable3.Aef[a2] =
        let (v1, v2) = x;
        RichString3.fromString("(") + Formattable3.format(v1) + RichString3.fromString(", ") + Formattable3.format(v2) + RichString3.fromString(")")
}