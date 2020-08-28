// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const c = @cImport({
    @cInclude("termios.h");
});

const std = @import("std");
const stdin = std.io.getStdIn();
const stdout = std.io.getStdOut();

var orig_termios: c.termios = undefined;
var raw: bool = false;
var alternate: bool = false;

pub fn getRawMode() bool {
    return raw;
}

pub fn setRawMode(enabled: bool) !void {
    if (enabled and raw) return;
    if (!enabled and !raw) return;

    if (enabled) {
        if (c.tcgetattr(stdin.handle, &orig_termios) < 0)
            return error.BackendError;

        var new_termios = orig_termios;
        c.cfmakeraw(&new_termios);
        new_termios.c_cc[c.VMIN] = 0;
        new_termios.c_cc[c.VTIME] = 1;

        if (c.tcsetattr(stdin.handle, c.TCSANOW, &new_termios) < 0)
            return error.BackendError;
        raw = true;
    } else {
        if (c.tcsetattr(stdin.handle, c.TCSANOW, &orig_termios) < 0)
            return error.BackendError;
        raw = false;
    }
}

pub fn getAlternateScreen() bool {
    return alternate;
}

pub fn setAlternateScreen(enabled: bool) !void {
    if (enabled and raw) return;
    if (!enabled and !raw) return;

    if (enabled) {
        _ = try stdout.writer().write("\x1b[?1049h");
        alternate = true;
    } else {
        _ = try stdout.writer().write("\x1b[?1049l");
        alternate = false;
    }
}
