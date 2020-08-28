// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

pub const config = @import("termios/config.zig");
pub const cursor = @import("termios/cursor.zig");
pub const screen = @import("termios/screen.zig");
pub const event = @import("termios/event.zig");

const termcon = @import("../termcon.zig");
pub const SupportedFeatures = termcon.SupportedFeatures;

pub fn init() !SupportedFeatures {
    return SupportedFeatures{
        .mouse_events = true,
    };
}

pub fn deinit() void {}
