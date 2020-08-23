// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const c = @cImport({
    @cInclude("termios.h");
});

const std = @import("std");
const stdin = std.io.getStdIn();

// TODO: Wrap this in mutex/semaphore/other asynchronous protection
//       in a Zig-idiomatic way
var orig_termios: ?c.termios = null;

// TODO: Use better error
pub const Error = error.Unexpected;

pub fn getRawMode() bool {
    return orig_termios != null;
}

pub fn setRawMode(enabled: bool) Error!void {
    if (enabled and orig_termios != null) return;
    if (!enabled and orig_termios == null) return;

    if (enabled) {
        // TODO: Lock `orig_termios` here, with unlock deferred
        orig_termios = c.termios{};
        if (c.tcgetattr(stdin.handle, &orig_termios) < 0) return Error;

        var new_termios = orig_termios;
        c.cfmakeraw(&new_termios);
        new_termios.cc[c.VMIN] = 0;
        new_termios.cc[c.VTIME] = 1;

        if (c.tcsetattr(stdin.handle, c.TCSANOW, &new_termios) < 0) return Error;
    } else {
        // TODO: Lock `orig_termios` here, with unlock deferred
        if (c.tcsetattr(stdin.handle, c.TCSANOW, &orig_termios) < 0) return Error;
        orig_termios = null;
    }
}
