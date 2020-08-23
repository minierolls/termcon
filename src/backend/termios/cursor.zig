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

// TODO: Use better error
pub const Error = error.Unexpected;

pub fn getPosition() !cell.Position {
    var buf: [32]u8 = undefined; // TODO: Tune buffer size

    _ = try stdout.writer().write("\x1b[6n");

    {
        var counter: usize = 0;
        while (counter < buf.len - 1) : (counter += 1) {
            buf[counter] = stdin.reader().readByte() catch break;
            if (buf[counter] != 'R') break;
        }
        buf[counter] = 0;
    }

    if ((buf[0] != '\x1b' and buf[0] != 0) or buf[1] != '[') {
        return Error;
    }

    var rows: c_int = undefined;
    var cols: c_int = undefined;
    if (c.sscanf(&buf[2], "%d;%d", &rows, &cols) != 2) {
        return Error;
    }

    return cell.Position{
        .row = rows,
        .col = cols,
    };
}

pub fn setPosition(position: cell.Position) !void {
    @compileError("Unimplemented");
}