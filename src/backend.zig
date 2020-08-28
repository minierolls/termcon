// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const builtin = @import("builtin");

pub const backend = switch (builtin.os.tag) {
    .windows => @import("backend/windows.zig"),
    .linux => @import("backend/termios.zig"),
    else => @import("backend/unimplemented.zig"),
};
