// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const std = @import("std");

pub const key = @import("event/key.zig");
pub const mouse = @import("event/mouse.zig");

const view = @import("view.zig");
pub const Size = view.Size;

pub const Handler = struct {
    // TODO: Add field to keep track of child thread
    key_callbacks: std.ArrayList(fn (e: key.Event) void),
    mouse_callbacks: std.ArrayList(fn (e: mouse.Event) void),
    resize_callbacks: std.ArrayList(fn (e: Size) void),

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator) Handler {
        // TODO: implement initializer function
        return Handler {
            .key_callbacks = std.ArrayList(fn (e: key.Event) void).init(allocator),
            .mouse_callbacks = std.ArrayList(fn (e: mouse.Event) void).init(allocator),
            .resize_callbacks = std.ArrayList(fn (e: Size) void).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.key_callbacks.deinit();
        self.mouse_callbacks.deinit();
        self.resize_callbacks.deinit();
    }

    pub fn start(self: *Self) !void {
        // Note: This should start an infinite loop
        //       in another thread and immediately return
        @compileError("Unimplemented");
    }

    pub fn end(self: *Self) void {
        @compileError("Unimplemented");
    }

    pub fn registerKeyCallback(
        self: *Self,
        function: fn (e: key.Event) void,
    ) !void {
        @compileError("Unimplemented");
    }

    pub fn registerMouseCallback(
        self: *Self,
        function: fn (e: mouse.Event) void,
    ) !void {
        @compileError("Unimplemented");
    }

    pub fn registerResizeCallback(
        self: *Self,
        function: fn (e: Size) void,
    ) !void {
        @compileError("Unimplemented");
    }
};
