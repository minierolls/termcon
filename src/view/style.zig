// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

pub const Style = struct {
    fg_color: Color,
    bg_color: Color,
    text_decorations: TextDecorations,

    const Self = @This();

    pub fn equal(self: *const Self, other: Style) bool {
        return self.fg_color.equal(other.fg_color) and
            self.bg_color.equal(other.bg_color) and
            self.text_decorations.equal(other.text_decorations);
    }
};

pub const TextDecorations = struct {
    italic: bool,
    bold: bool,
    underline: bool,

    const Self = @This();

    pub fn equal(self: *const Self, other: TextDecorations) bool {
        return (self.italic == other.italic and
            self.bold == other.bold and
            self.underline == other.underline);
    }
};

pub const Color = union(ColorType) {
    Default: ColorDefault,
    Named8: ColorNamed8,
    Named16: ColorNamed16,
    Bit8: ColorBit8,
    Bit24: ColorBit24,

    const Self = @This();

    pub fn equal(self: Self, other: Color) bool {
        if (@as(ColorType, self) != @as(ColorType, other)) return false;
        return switch (self) {
            ColorType.Default => |v| v == other.Default,
            ColorType.Named8 => |v| v == other.Named8,
            ColorType.Named16 => |v| v == other.Named16,
            ColorType.Bit8 => |v| v.code == other.Bit8.code,
            ColorType.Bit24 => |v| v.code == other.Bit24.code,
        };
    }
};

pub const ColorType = enum {
    Default,
    Named8,
    Named16,
    Bit8,
    Bit24,
};

pub const ColorDefault = enum {
    Foreground,
    Background,
    SelectionForeground,
    SelectionBackground,
    CursorForeground,
    CursorBackground,
    Bold,
};

/// Color names and values based on:
/// [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
pub const ColorNamed8 = enum(u3) {
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
};

/// Color names and values based on:
/// [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
pub const ColorNamed16 = enum(u4) {
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    BrightBlack,
    BrightRed,
    BrightGreen,
    BrightYellow,
    BrightBlue,
    BrightMagenta,
    BrightCyan,
    BrightWhite,

    pub fn fromNamed8(name: ColorNamed8) ColorNamed16 {
        return switch (name) {
            ColorNamed8.Black => Black,
            ColorNamed8.Red => Red,
            ColorNamed8.Green => Green,
            ColorNamed8.Yellow => Yellow,
            ColorNamed8.Blue => Blue,
            ColorNamed8.Magenta => Magenta,
            ColorNamed8.Cyan => Cyan,
            ColorNamed8.White => White,
        };
    }
};

/// Color values based on:
/// [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
pub const ColorBit8 = struct {
    code: u8,

    pub fn init(code: u8) ColorBit8 {
        return ColorBit8{ .code = code };
    }

    pub fn fromNamed8(name: ColorNamed8) ColorBit8 {
        return ColorBit8{ .code = @enumToInt(name) };
    }

    pub fn fromNamed16(name: ColorNamed16) ColorBit8 {
        return ColorBit8{ .code = @enumToInt(name) };
    }
};

pub const ColorBit24 = struct {
    code: u24,

    pub fn init(code: u24) ColorBit24 {
        return ColorBit24{ .code = code };
    }

    pub fn initRGB(red: u8, green: u8, blue: u8) ColorBit24 {
        var code: u24 = 0;
        code |= blue;
        code |= @as(u16, green) << 8;
        code |= @as(u24, red) << 16;
        return ColorBit24{ .code = code };
    }

    /// Color values based on:
    /// [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
    /// VGA values
    pub fn fromNamed8(name: ColorNamed8) ColorBit24 {
        return switch (name) {
            ColorNamed8.Black => self.initRGB(0, 0, 0),
            ColorNamed8.Red => self.initRGB(170, 0, 0),
            ColorNamed8.Green => self.initRGB(0, 170, 0),
            ColorNamed8.Yellow => self.initRGB(170, 85, 0),
            ColorNamed8.Blue => self.initRGB(0, 0, 170),
            ColorNamed8.Magenta => self.initRGB(170, 0, 170),
            ColorNamed8.Cyan => self.initRGB(0, 170, 170),
            ColorNamed8.White => self.initRGB(170, 170, 170),
        };
    }

    /// Color values based on:
    /// [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
    /// VGA values
    pub fn fromNamed16(name: ColorNamed16) ColorBit24 {
        return switch (name) {
            ColorNamed16.Black => self.initRGB(0, 0, 0),
            ColorNamed16.Red => self.initRGB(170, 0, 0),
            ColorNamed16.Green => self.initRGB(0, 170, 0),
            ColorNamed16.Yellow => self.initRGB(170, 85, 0),
            ColorNamed16.Blue => self.initRGB(0, 0, 170),
            ColorNamed16.Magenta => self.initRGB(170, 0, 170),
            ColorNamed16.Cyan => self.initRGB(0, 170, 170),
            ColorNamed16.White => self.initRGB(170, 170, 170),
            ColorNamed16.BrightBlack => self.initRGB(85, 85, 85),
            ColorNamed16.BrightRed => self.initRGB(255, 85, 85),
            ColorNamed16.BrightGreen => self.initRGB(85, 255, 85),
            ColorNamed16.BrightYellow => self.initRGB(255, 255, 85),
            ColorNamed16.BrightBlue => self.initRGB(85, 85, 255),
            ColorNamed16.BrightMagenta => self.initRGB(255, 85, 255),
            ColorNamed16.BrightCyan => self.initRGB(85, 255, 255),
            ColorNamed16.BrightWhite => self.initRGB(255, 255, 255),
        };
    }
};
