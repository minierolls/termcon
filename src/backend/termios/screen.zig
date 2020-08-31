// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const c = @cImport({
    @cInclude("termios.h");
    @cInclude("sys/ioctl.h");
});

const std = @import("std");
const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();

const cursor = @import("cursor.zig");

const view = @import("../../view.zig");

pub const Size = view.Size;
pub const Rune = view.Rune;
pub const Style = view.Style;

const Color = view.Color;
const ColorType = view.ColorType;
const ColorNamed8 = view.ColorNamed8;
const ColorNamed16 = view.ColorNamed16;
const ColorBit8 = view.ColorBit8;
const ColorBit24 = view.ColorBit24;

const Position = view.Position;

/// Get the size of the screen in terms of rows and columns.
pub fn getSize() !Size {
    var ws: c.winsize = undefined;

    var filehandle = stdout.handle;
    // TODO: Set to "/dev/tty" raw filehandle if available

    if (c.ioctl(filehandle, c.TIOCGWINSZ, &ws) < 0 or ws.ws_col == 0 or ws.ws_row == 0) {
        _ = try stdout.writer().write("\x1b[65535C\x1b[65535B");
        const position: Position = try cursor.getPosition();
        return Size{
            .rows = position.row,
            .cols = position.col,
        };
    } else {
        return Size{
            .rows = ws.ws_row,
            .cols = ws.ws_col,
        };
    }
}

fn writeStyle(style: Style) !void {
    const writer = stdout.writer();
    _ = try writer.write("\x1b[0m");

    if (style.text_decorations.italic) {
        _ = try writer.write("\x1b[3m");
    }
    if (style.text_decorations.bold) {
        _ = try writer.write("\x1b[1m");
    }
    if (style.text_decorations.underline) {
        _ = try writer.write("\x1b[4m");
    }

    switch (style.fg_color) {
        ColorType.Default => {
            _ = try writer.write("\x1b[39m");
        },
        ColorType.Named8 => |v| switch (v) {
            ColorNamed8.Black => {
                _ = try writer.write("\x1b[30m");
            },
            ColorNamed8.Red => {
                _ = try writer.write("\x1b[31m");
            },
            ColorNamed8.Green => {
                _ = try writer.write("\x1b[32m");
            },
            ColorNamed8.Yellow => {
                _ = try writer.write("\x1b[33m");
            },
            ColorNamed8.Blue => {
                _ = try writer.write("\x1b[34m");
            },
            ColorNamed8.Magenta => {
                _ = try writer.write("\x1b[35m");
            },
            ColorNamed8.Cyan => {
                _ = try writer.write("\x1b36m");
            },
            ColorNamed8.White => {
                _ = try writer.write("\x1b37m");
            },
        },
        ColorType.Named16 => |v| switch (v) {
            ColorNamed16.Black => {
                _ = try writer.write("\x1b[30m");
            },
            ColorNamed16.Red => {
                _ = try writer.write("\x1b[31m");
            },
            ColorNamed16.Green => {
                _ = try writer.write("\x1b[32m");
            },
            ColorNamed16.Yellow => {
                _ = try writer.write("\x1b[33m");
            },
            ColorNamed16.Blue => {
                _ = try writer.write("\x1b[34m");
            },
            ColorNamed16.Magenta => {
                _ = try writer.write("\x1b[35m");
            },
            ColorNamed16.Cyan => {
                _ = try writer.write("\x1b36m");
            },
            ColorNamed16.White => {
                _ = try writer.write("\x1b37m");
            },
            ColorNamed16.BrightBlack => {
                _ = try writer.write("\x1b[90m");
            },
            ColorNamed16.BrightRed => {
                _ = try writer.write("\x1b[91m");
            },
            ColorNamed16.BrightGreen => {
                _ = try writer.write("\x1b[92m");
            },
            ColorNamed16.BrightYellow => {
                _ = try writer.write("\x1b[93m");
            },
            ColorNamed16.BrightBlue => {
                _ = try writer.write("\x1b[94m");
            },
            ColorNamed16.BrightMagenta => {
                _ = try writer.write("\x1b[95m");
            },
            ColorNamed16.BrightCyan => {
                _ = try writer.write("\x1b96m");
            },
            ColorNamed16.BrightWhite => {
                _ = try writer.write("\x1b97m");
            },
        },
        ColorType.Bit8 => |v| {
            _ = try writer.print("\x1b[38;5;{}m", .{v.code});
        },
        ColorType.Bit24 => |v| {
            _ = try writer.print(
                "\x1b[38;2;{};{};{}m",
                .{
                    v.code >> 16,
                    (v.code & 255) >> 8,
                    v.code & 255,
                },
            );
        },
    }
    switch (style.bg_color) {
        ColorType.Default => {
            _ = try writer.write("\x1b[49m");
        },
        ColorType.Named8 => |v| switch (v) {
            ColorNamed8.Black => {
                _ = try writer.write("\x1b[40m");
            },
            ColorNamed8.Red => {
                _ = try writer.write("\x1b[41m");
            },
            ColorNamed8.Green => {
                _ = try writer.write("\x1b[42m");
            },
            ColorNamed8.Yellow => {
                _ = try writer.write("\x1b[44m");
            },
            ColorNamed8.Blue => {
                _ = try writer.write("\x1b[44m");
            },
            ColorNamed8.Magenta => {
                _ = try writer.write("\x1b[45m");
            },
            ColorNamed8.Cyan => {
                _ = try writer.write("\x1b46m");
            },
            ColorNamed8.White => {
                _ = try writer.write("\x1b47m");
            },
        },
        ColorType.Named16 => |v| switch (v) {
            ColorNamed16.Black => {
                _ = try writer.write("\x1b[40m");
            },
            ColorNamed16.Red => {
                _ = try writer.write("\x1b[41m");
            },
            ColorNamed16.Green => {
                _ = try writer.write("\x1b[42m");
            },
            ColorNamed16.Yellow => {
                _ = try writer.write("\x1b[44m");
            },
            ColorNamed16.Blue => {
                _ = try writer.write("\x1b[44m");
            },
            ColorNamed16.Magenta => {
                _ = try writer.write("\x1b[45m");
            },
            ColorNamed16.Cyan => {
                _ = try writer.write("\x1b46m");
            },
            ColorNamed16.White => {
                _ = try writer.write("\x1b47m");
            },
            ColorNamed16.BrightBlack => {
                _ = try writer.write("\x1b[100m");
            },
            ColorNamed16.BrightRed => {
                _ = try writer.write("\x1b[101m");
            },
            ColorNamed16.BrightGreen => {
                _ = try writer.write("\x1b[102m");
            },
            ColorNamed16.BrightYellow => {
                _ = try writer.write("\x1b[103m");
            },
            ColorNamed16.BrightBlue => {
                _ = try writer.write("\x1b[104m");
            },
            ColorNamed16.BrightMagenta => {
                _ = try writer.write("\x1b[105m");
            },
            ColorNamed16.BrightCyan => {
                _ = try writer.write("\x1b106m");
            },
            ColorNamed16.BrightWhite => {
                _ = try writer.write("\x1b107m");
            },
        },
        ColorType.Bit8 => |v| {
            _ = try writer.print("\x1b[48;5;{}m", .{v.code});
        },
        ColorType.Bit24 => |v| {
            _ = try writer.print(
                "\x1b[48;2;{};{};{}m",
                .{
                    v.code >> 16,
                    (v.code & 255) >> 8,
                    v.code & 255,
                },
            );
        },
    }
}

/// Write styled text to the screen at the cursor's position,
/// moving the cursor accordingly.
pub fn write(runes: []const Rune, styles: []const Style) !void {
    if (runes.len != styles.len) return error.BackendError;
    if (runes.len == 0) return;

    var orig_style_index: usize = 0;
    try writeStyle(styles[0]);
    for (styles) |style, index| {
        if (!styles[orig_style_index].equal(style)) {
            _ = try stdout.writer().write(runes[orig_style_index..index]);
            orig_style_index = index;
            try writeStyle(style);
        }
    }
    _ = try stdout.writer().write(runes[orig_style_index..]);
    _ = try stdout.writer().write("\x1b[0m");
}

/// Clear all runes and styles at the cursor's row.
pub fn clearLine() !void {
    _ = try stdout.writer().write("\x1b[2K");
}

/// Clear all runes and styles on the screen.
pub fn clearScreen() !void {
    _ = try stdout.writer().write("\x1b[2J");
}
