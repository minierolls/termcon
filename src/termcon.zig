// Copyright (c) 2020 John Namgung, Luke I. Wilson.

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

pub const SupportedFeatures = struct {
    mouse_events: bool,
    // TODO: Figure out what other features should be optionally unsupported
    //       while implementing backends
};

pub const TermCon = struct {
    screen: view.Screen,
    event_handler: ?event.Handler,
    supported_features: SupportedFeatures,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator, options: Options) !TermCon {
        var supported_features = try backend.init();

        var event_handler = if (options.use_handler) event.Handler.init(allocator) else null;

        if (options.raw_mode) {
            try backend.setRawMode(true);
        }

        if (options.alternate_screen) {
            try backend.setAlternateScreen(true);
        }

        var screen = try view.Screen.init(allocator, null);

        return TermCon{
            .screen = screen,
            .event_handler = event_handler,
            .supported_features = supported_features,
        };
    }
    pub fn deinit(self: *Self) void {
        self.screen.deinit();
        if (self.event_handler) |*handler| {
            handler.deinit();
        }
        self.event_handler = null;
        backend.deinit();
    }
};
