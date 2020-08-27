// Copyright (c) 2020 John Namgung, Luke I. Wilson.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const windows = @cImport({
    @cInclude("Windows.h");
});

pub const config = @import("windows/config.zig");
pub const cursor = @import("windows/cursor.zig");
pub const screen = @import("windows/screen.zig");
pub const event = @import("windows/event.zig");

const termcon = @import("../termcon.zig");
pub const SupportedFeatures = termcon.SupportedFeatures;

pub fn init() !SupportedFeatures {
    @compileError("Unimplemented Windows backend");
}

pub fn deinit() void {
    @compileError("Unimplemented");
}
