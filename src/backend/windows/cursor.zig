// Copyright (c) 2020 John Namgung, Luke I. Wilson.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const root = @import("../windows.zig");
const view = @import("../../view.zig");

const std = @import("std");
const windows = std.os.windows;

pub const Position = view.Position;

pub fn getPosition() !Position {
    var csbi = try root.screen.getScreenBufferInfo();
    return Position {
        .row = @intCast(u16, csbi.dwCursorPosition.Y),
        .col = @intCast(u16, csbi.dwCursorPosition.X)
    };
}

pub fn setPosition(position: Position) !void {
    var coord = windows.COORD{ .X = @intCast(i16, position.col), .Y = @intCast(i16, position.row) };
    if (windows.kernel32.SetConsoleCursorPosition(root.hConsole, coord) == 0) return error.SetCursorFailed;
}

pub fn getVisibility() !bool {
    var cursor_info: windows.CONSOLE_CURSOR_INFO = undefined;
    if (windows.kernel32.GetConsoleCursorInfo(root.hConsole, &cursor_info) == 0) return error.GetCursorVisibility;
    return cursor_info.bVisible;
}

pub fn setVisibility(visible: bool) !void {
    var cursor_info = windows.CONSOLE_CURSOR_INFO{
        .dwSize = 100,
        .bVisible = visible
    };
    if (windows.kernel32.SetConsoleCursorInfo(root.hConsole, &cursor_info) == 0) return error.SetCursorVisibility;
}
