/*
 * Copyright 2025 Magnus Madsen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

///
/// A rich string composed of multiple styled spans.
///
pub enum RichString2 {
    case RichString2(Chain[RichString2.Span])
}

instance Add[RichString2] {
    pub def add(x: RichString2, y: RichString2): RichString2 = RichString2.combine(x, y)
}

instance ToString[RichString2] {
    pub def toString(x: RichString2): String = RichString2.toString(x)
}

instance SemiGroup[RichString2] {
    pub def combine(x: RichString2, y: RichString2): RichString2 = RichString2.combine(x, y)
}

instance Monoid[RichString2] {
    pub def empty(): RichString2 = RichString2.empty()
}

instance Formattable2[RichString2] {
    pub def format(x: RichString2): RichString2 = x
}

instance Eq[RichString2] {
    pub def eq(x: RichString2, y: RichString2): Bool = RichString2.equals(x, y)
}

pub mod RichString2 {

    use Sys.Env

    ///
    /// Represents a color with RGB components or the terminal's default color.
    ///
    /// For RGB, each component is a value from 0 to 255 representing red, green, and blue intensity.
    /// Default represents no color override, using the terminal's current color settings.
    ///
    pub enum Color with Eq {
        case Default,                   // Use terminal's default color
        case Rgb(Int32, Int32, Int32)   // Red, Green, Blue components
    }

    ///
    /// Compares c1 and c2. 
    ///
    /// It follows normal rules for enum comparison, except when given two Rgb values. Here, it compares red-, green- and blue-value in this order of priority
    ///
    instance Order[Color] {
        pub def compare(c1: Color, c2: Color): Comparison = match (c1, c2) {
            case (Color.Default, Color.Default) => c1 <=> c2
            case (Color.Rgb(r1, g1, b1), Color.Rgb(r2, g2, b2)) => 
                let comp_r = r1 <=> r2;
                let comp_g = g1 <=> g2;
                let comp_b = b1 <=> b2;
                if (comp_r != Comparison.EqualTo) comp_r 
                else if (comp_g != Comparison.EqualTo) comp_g
                else comp_b
            case (Color.Default, Color.Rgb(_,_,_)) => Comparison.LessThan
            case (Color.Rgb(_,_,_), Color.Default) => Comparison.GreaterThan
        }
    }

    ///
    /// Represents text styling options.
    ///
    /// Defines the visual appearance of text spans beyond color.
    ///
    pub enum Style with Eq, Order {
        case Bold,
        case Underline
    }

    ///
    /// A text span with content, foreground color, background color, and styles.
    ///
    /// A span represents a contiguous piece of text with uniform styling.
    ///
    pub enum Span {
        case Span({text = String, fgColor = Color, bgColor = Color, styles = Set[Style]})
    }

    ///
    ///
    ///
    instance Order[Span] {
        pub def compare(s1: Span, s2: Span): Comparison = match (s1, s2) {
            case _ => ???
        }
    }

    ///
    /// A record type representing a palette of colors.
    ///
    type alias ColorPalette = {
        black   = Color,
        gray    = Color,
        red     = Color,
        green   = Color,
        yellow  = Color,
        blue    = Color,
        magenta = Color,
        cyan    = Color,
        white   = Color
    }

    ///
    /// Returns an empty `RichString2`.
    ///
    pub def empty(): RichString2 =
        RichString2(Chain.empty())

    ///
    /// Returns a `RichString2` with the given text `x` using default colors and normal style.
    ///
    pub def text(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        Formattable2.format(x)

    ///
    /// Returns a `RichString2` with the function `f` applied to every span.
    ///
    pub def map(f: Span -> Span, rs: RichString2): RichString2 = match rs {
        case RichString2(spans) => RichString2(Chain.map(f, spans))
    }
    
    ///
    /// Returns a `Bool` according to the equality of `rs1` and `rs2`.
    ///
    /// Checks whether text and styling is equivalent for each individual character.
    ///
    pub def equals(rs1: RichString2, rs2: RichString2): Bool = 
        let (RichString2(chain1), RichString2(chain2)) = (rs1, rs2);
        let splitSpans = (match Span.Span({text = t, fgColor = fg, bgColor = bg, styles}) -> { 
            String.toList(t) |> List.toChain |> Chain.map(c -> (Span.Span({text = Char.toString(c), fgColor = fg, bgColor = bg, styles = styles})))
        });
        let l1 = Chain.flatMap(splitSpans, chain1);
        let l2 = Chain.flatMap(splitSpans, chain2);
        if (Chain.length(l1) != Chain.length(l2)) {
            false
        } else {
            Chain.zip(l1, l2) |> Chain.forAll((match (e1, e2) -> spanEquals(e1, e2)))
        }

    def spanEquals(s1: Span, s2: Span): Bool =
        let Span.Span({text = t1, fgColor = fg1, bgColor = bg1, styles = style1}) = s1;
        let Span.Span({text = t2, fgColor = fg2, bgColor = bg2, styles = style2}) = s2;
        t1 == t2 and fg1 == fg2 and bg1 == bg2 and style1 == style2

    ///
    /// Returns a `RichString2` from given text `x` with all spans updated to use the given foreground color `c`.
    ///
    pub def withColor(c: Color, x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        let rs = Formattable2.format(x);
        map(match Span.Span(r) ->
            Span.Span({text = r#text, fgColor = c, bgColor = r#bgColor, styles = r#styles}), rs)

    ///
    /// Returns a `RichString2` from given text `x` with all spans updated to use the given background color `c`.
    ///
    pub def withBgColor(c: Color, x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        let rs = Formattable2.format(x);
        map(match Span.Span(r) ->
            Span.Span({text = r#text, fgColor = r#fgColor, bgColor = c, styles = r#styles}), rs)

    ///
    /// Returns a `RichString2` from given text `x` with the given `style` in addition to any other styles it already has.
    ///
    pub def withStyle(style: Style, x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        let rs = Formattable2.format(x);
        map(match Span.Span(r) ->
            Span.Span({text = r#text, fgColor = r#fgColor, bgColor = r#bgColor, styles = Set.insert(style, r#styles)}), rs)

    ///
    /// Returns a `RichString2` containing the given span `s`.
    ///
    pub def fromSpan(s: Span): RichString2 =
        RichString2(Chain.singleton(s))

    ///
    /// Returns a `RichString2` from the given string `s` using default colors and no styles.
    ///
    pub def fromString(s: String): RichString2 =
        RichString2(Chain.singleton(Span.Span({text = s, fgColor = Color.Default, bgColor = Color.Default, styles = Set.empty()})))

    ///
    /// Returns a `RichString2` with the given text `x` in black color.
    ///
    pub def black(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#black, x)

    ///
    /// Returns a `RichString2` with the given text `x` in red color.
    ///
    pub def red(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#red, x)

    ///
    /// Returns a `RichString2` with the given text `x` in gray color.
    ///
    pub def gray(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#gray, x)

    ///
    /// Returns a `RichString2` with the given text `x` in green color.
    ///
    pub def green(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#green, x)

    ///
    /// Returns a `RichString2` with the given text `x` in yellow color.
    ///
    pub def yellow(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#yellow, x)

    ///
    /// Returns a `RichString2` with the given text `x` in blue color.
    ///
    pub def blue(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#blue, x)

    ///
    /// Returns a `RichString2` with the given text `x` in magenta color.
    ///
    pub def magenta(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#magenta, x)

    ///
    /// Returns a `RichString2` with the given text `x` in cyan color.
    ///
    pub def cyan(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#cyan, x)

    ///
    /// Returns a `RichString2` with the given text `x` in white color.
    ///
    pub def white(x: a): RichString2 \ Formattable2.Aef[a] with Formattable2[a] =
        withColor(colors()#fg#white, x)

    ///
    /// Returns a `RichString2` with the given text `x` on black background.
    ///
    pub def bgBlack(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#black, x)

    ///
    /// Returns a `RichString2` with the given text `x` on red background.
    ///
    pub def bgRed(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#red, x)

    ///
    /// Returns a `RichString2` with the given text `x` on green background.
    ///
    pub def bgGreen(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#green, x)

    ///
    /// Returns a `RichString2` with the given text `x` on yellow background.
    ///
    pub def bgYellow(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#yellow, x)

    ///
    /// Returns a `RichString2` with the given text `x` on blue background.
    ///
    pub def bgBlue(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#blue, x)

    ///
    /// Returns a `RichString2` with the given text `x` on magenta background.
    ///
    pub def bgMagenta(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#magenta, x)

    ///
    /// Returns a `RichString2` with the given text `x` on cyan background.
    ///
    pub def bgCyan(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#cyan, x)

    ///
    /// Returns a `RichString2` with the given text `x` on white background.
    ///
    pub def bgWhite(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withBgColor(colors()#bg#white, x)

    ///
    /// Returns a `RichString2` with the given text `x` in bold style.
    ///
    pub def bold(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withStyle(Style.Bold, x)

    ///
    /// Returns a `RichString2` with the given text `x` in underline style.
    ///
    pub def underline(x: a): RichString2  \ Formattable2.Aef[a] with Formattable2[a] =
        withStyle(Style.Underline, x)

    ///
    /// Returns the concatenation of the elements in `xs` formatted with RichString2 `sep` inserted between each.
    ///
    /// Uses the Formattable2 trait to format each element.
    ///
    pub def join(sep: RichString2, xs: t[a]): RichString2 \ (Formattable2.Aef[a] + Foldable.Aef[t]) with Formattable2[a], Foldable[t] =
        joinWith(Formattable2.format, sep, xs)

    ///
    /// Returns the concatenation of elements in `xs` according to `f` with RichString2 `sep` inserted between each.
    ///
    pub def joinWith(f: a -> RichString2 \ ef, sep: RichString2, xs: t[a]): RichString2 \ (ef + Foldable.Aef[t]) with Foldable[t] =
        let l = Foldable.toList(xs);
        match l {
            case Nil       => empty()
            case x :: Nil  => f(x)
            case x :: rest =>
                List.foldLeft((acc, elem) -> acc + sep + f(elem), f(x), rest)
        }

    ///
    /// Returns the concatenation of `rs1` and `rs2`.
    ///
    /// The spans from `rs1` appear first, followed by the spans from `rs2`.
    ///
    pub def combine(rs1: RichString2, rs2: RichString2): RichString2 = match (rs1, rs2) {
        case (RichString2(spans1), RichString2(spans2)) =>
            RichString2(Chain.append(spans1, spans2))
    }

    ///
    /// Returns a string representation of the given `rs`.
    ///
    /// If the terminal supports ANSI colors, returns the string with ANSI escape codes.
    /// Otherwise, returns the plain text representation without styling.
    ///
    pub def toString(rs: RichString2): String =
        if (isColorTerm()) toAnsiString(rs) else toPlainString(rs)

    ///
    /// Returns the plain text representation of the `RichString2` `rs`.
    ///
    /// All styling and color information is discarded.
    ///
    pub def toPlainString(rs: RichString2): String = match rs {
        case RichString2(spans) =>
            Chain.joinWith(match Span.Span(r) -> r#text, "", spans)
    }

    ///
    /// Returns the string representation of the `RichString2` `rs` with ANSI escape codes.
    ///
    /// The returned string includes ANSI color and style codes for terminal display.
    ///
    def toAnsiString(rs: RichString2): String = match rs {
        case RichString2(spans) =>
            Chain.joinWith(match Span.Span(r) -> {
                // Collect all codes in a list
                let styleCodes = r#styles |> Set.toList |> List.map(s -> match s {
                    case Style.Bold => "1"
                    case Style.Underline => "4"
                });

                let fgCodes = match r#fgColor {
                    case Color.Rgb(red, green, blue) => "38;2;${red};${green};${blue}" :: Nil
                    case Color.Default => Nil
                };

                let bgCodes = match r#bgColor {
                    case Color.Rgb(red, green, blue) => "48;2;${red};${green};${blue}" :: Nil
                    case Color.Default => Nil
                };

                let allCodes = styleCodes ::: fgCodes ::: bgCodes;

                if (List.isEmpty(allCodes))
                    r#text
                else
                    "\u001B[${List.join(";", allCodes)}m${r#text}\u001B[0m"
            }, "", spans)
    }

    ///
    /// Returns a record containing all color definitions for foreground and background colors.
    ///
    /// The returned record has two fields:
    /// - `fg`: A `ColorPalette` record containing foreground colors
    /// - `bg`: A `ColorPalette` record containing background colors
    ///
    def colors(): {fg = ColorPalette, bg = ColorPalette} = {
        fg = {
            black   = Color.Rgb(0, 0, 0),
            gray    = Color.Rgb(128, 128, 128),
            red     = Color.Rgb(220, 105, 105),
            green   = Color.Rgb(13, 188, 121),
            yellow  = Color.Rgb(229, 192, 123),
            blue    = Color.Rgb(100, 130, 160),
            magenta = Color.Rgb(210, 125, 210),
            cyan    = Color.Rgb(17, 168, 205),
            white   = Color.Rgb(255, 255, 255)
        },
        bg = {
            black   = Color.Rgb(40, 40, 40),
            gray    = Color.Rgb(128, 128, 128),
            red     = Color.Rgb(205, 49, 49),
            green   = Color.Rgb(13, 188, 121),
            yellow  = Color.Rgb(229, 192, 123),
            blue    = Color.Rgb(36, 114, 200),
            magenta = Color.Rgb(188, 63, 188),
            cyan    = Color.Rgb(17, 168, 205),
            white   = Color.Rgb(255, 255, 255)
        }
    }

    ///
    /// Returns `true` unless color output is explicitly disabled.
    ///
    /// Returns `false` when:
    /// - NO_COLOR environment variable is set (following the no-color.org standard)
    /// - TERM=dumb (indicates a terminal with no capabilities)
    ///
    def isColorTerm(): Bool = unsafe IO {
        run {
            let noColor = Env.getVar("NO_COLOR") |> Option.nonEmpty;
            let isDumbTerm = Env.getVar("TERM") |> Option.exists(t -> t == "dumb");
            not (noColor or isDumbTerm)
        } with Env.runWithIO
    }

}