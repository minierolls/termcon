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

/// Write styled text to the screen at the cursor's position,
/// moving the cursor accordingly.
pub fn write(runes: []const Rune, styles: []const Style) !void {
    _ = try stdout.writer().write(runes);
}

/// Clear all runes and styles at the cursor's row.
pub fn clearLine() !void {
    _ = try stdout.writer().write("\x1b[2K");
}

/// Clear all runes and styles on the screen.
pub fn clearScreen() !void {
    _ = try stdout.writer().write("\x1b[2J");
}
