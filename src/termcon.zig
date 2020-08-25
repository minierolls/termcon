// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const std = @import("std");

const backend = @import("backend.zig").backend;
pub const view = @import("view.zig");
pub const event = @import("event.zig");

pub const Options = struct {
    raw_mode: bool,
    alternate_screen: bool,
    use_handler: bool,
};

pub const TermCon = struct {
    screen: view.Screen,
    event_handler: ?event.Handler,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator, options: Options) !TermCon {
        var result: TermCon = TermCon{};
        try backend.init();

        if (options.use_handler) {
            result.event_handler = event.Handler.init();
        } else {
            result.event_handler = null;
        }

        if (options.raw_mode) {
            try backend.setRawMode(true);
        }

        if (options.alternate_screen) {
            try backend.setAlternateScreen(true);
        }

        result.screen = view.Screen.init();

        return result;
    }
    pub fn deinit(self: *Self) void {
        self.screen.deinit();
        self.event_handler.deinit();
        backend.deinit();
    }
};
