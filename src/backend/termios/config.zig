// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const c = @cImport({
    @cInclude("termios.h");
});

const std = @import("std");
const stdin = std.io.getStdIn();

var orig_termios: ?c.termios = null;

pub fn getRawMode() bool {
    return orig_termios != null;
}

pub fn setRawMode(enabled: bool) !void {
    if (enabled and orig_termios != null) return;
    if (!enabled and orig_termios == null) return;

    if (enabled) {
        orig_termios = c.termios{};
        if (c.tcgetattr(stdin.handle, &orig_termios) < 0)
            return error.BackendError;

        var new_termios = orig_termios;
        c.cfmakeraw(&new_termios);
        new_termios.cc[c.VMIN] = 0;
        new_termios.cc[c.VTIME] = 1;

        if (c.tcsetattr(stdin.handle, c.TCSANOW, &new_termios) < 0)
            return error.BackendError;
    } else {
        if (c.tcsetattr(stdin.handle, c.TCSANOW, &orig_termios) < 0)
            return error.BackendError;
        orig_termios = null;
    }
}

pub fn getAlternateMode() bool {
    @compileError("Unimplemented");
}

pub fn setAlternateMode(enabled: bool) !void {
    @compileError("Unimplemented");
}
