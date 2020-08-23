// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const c = @cImport({
    @cInclude("termios.h");
    @cInclude("ioctl.h");
});

const std = @import("std");
const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();

const common = @import("../../common.zig");
const cell = common.cell;

pub fn getSize(self: *Self) !cell.Size {
    var ws: c.winsize = c.winsize{};

    var filehandle = stdout.handle();
    // TODO: Set to "/dev/tty" raw filehandle if available

    if (c.ioctl(filehandle, c.TIOCGWINSZ, &ws) < 0 or ws.ws_col == 0 or ws.ws_row == 0) {
        _ = try stdout.writer().write("\x1b[65535C\x1b[65535B");
        const position: cell.Position = try cursor.getPosition();
        return cell.Size{
            .rows = position.row,
            .cols = position.col,
        };
    } else {
        return cell.Size{
            .rows = ws.ws_row,
            .cols = ws.ws_col,
        };
    }
}
