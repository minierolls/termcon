// Copyright (c) 2020 John Namgung, Luke I. Wilson.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

//! This module handles provides functions to interface with the terminal
//! screen.

const view = @import("../../view.zig");

const std = @import("std");
const windows = std.os.windows;

pub const Size = view.Size;
pub const Rune = view.Rune;
pub const Style = view.Style;

/// Get the size of the screen in terms of rows and columns.
pub fn getSize() !Size {
    var csbi: windows.kernel32.CONSOLE_SCREEN_BUFFER_INFO = undefined;
    var size = Size {
        .rows = 0, .cols = 0
    };

    var handle = windows.kernel32.GetStdHandle(windows.STD_OUTPUT_HANDLE) orelse return error.InvalidHandle;
    if (windows.kernel32.GetConsoleScreenBufferInfo(handle, &csbi) == 0) return error.FailedToGetBuffer; // TODO: use GetLastError and zig wrapper function to return real error value
    size.cols = @intCast(u16, csbi.srWindow.Right - csbi.srWindow.Left + 1);
    size.rows = @intCast(u16, csbi.srWindow.Bottom - csbi.srWindow.Top + 1);

    return size;
}

/// Write styled text to the screen at the cursor's position,
/// moving the cursor accordingly.
pub fn write(runes: []const Rune, styles: []const Style) !void {
    @compileError("Unimplemented");
}

/// Clear all runes and styles on the screen.
pub fn clearScreen() !void {
    @compileError("Unimplemented");
}
