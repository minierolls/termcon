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

const view = @import("../../view.zig");

pub const Position = view.Position;

var cursor_visible = true;

pub fn getPosition() !Position {
    var buf: [32]u8 = undefined; // TODO: Tune buffer size

    _ = try stdout.writer().write("\x1b[6n");

    // {
    // var counter: usize = 0;
    // while (counter < buf.len - 1) : (counter += 1) {
    // buf[counter] = stdin.reader().readByte() catch break;
    // if (buf[counter] != 'R') break;
    // }
    // buf[counter] = 0;
    // }

    const num_read = try stdin.reader().read(&buf);

    if ((buf[0] != '\x1b') or buf[1] != '[') {
        return error.BackendError;
    }

    var rows: u16 = 0;
    var cols: u16 = 0;
    var split_iterator = std.mem.split(buf[2 .. num_read - 1], ";");
    while (split_iterator.next()) |slice| {
        if (rows > 0) {
            cols = try std.fmt.parseUnsigned(u16, slice, 10);
        } else {
            rows = try std.fmt.parseUnsigned(u16, slice, 10);
        }
    }

    if (rows == 0 or cols == 0) {
        return error.BackendError;
    }

    return Position{
        .row = rows,
        .col = cols,
    };
}

pub fn setPosition(position: Position) !void {
    _ = try stdout.writer().print(
        "\x1b[{};{}H",
        .{ position.row + 1, position.col + 1 },
    );
}

pub fn getVisibility() bool {
    return cursor_visible;
}

pub fn setVisibility(visible: bool) !void {
    if (visible and cursor_visible) return;
    if (!visible and !cursor_visible) return;

    if (visible) {
        _ = try stdout.writer().write("\x1b[?25h");
        cursor_visible = true;
    } else {
        _ = try stdout.writer().write("\x1b[?25l");
        cursor_visible = false;
    }
}
