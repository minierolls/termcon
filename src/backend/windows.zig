// Copyright (c) 2020 John Namgung, Luke I. Wilson.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

pub const config = @import("windows/config.zig");
pub const cursor = @import("windows/cursor.zig");
pub const screen = @import("windows/screen.zig");
pub const event = @import("windows/event.zig");

const std = @import("std");

const termcon = @import("../termcon.zig");
pub const SupportedFeatures = termcon.SupportedFeatures;

pub fn init() !SupportedFeatures {
    // @compileError("Unimplemented Windows backend");
    var size = try screen.getSize(); // Use Windows.h to print the console window size
    std.debug.warn("{} {}\n", .{size.cols, size.rows});

    return SupportedFeatures {
        .mouse_events = false
    };
}

pub fn deinit() void {
    // TODO: anything need to be undone?
}

pub fn setRawMode(value: bool) !void {
    return; // TODO: implement this function
}

pub fn setAlternateScreen(value: bool) !void {
    return; // TODO: implement
}
