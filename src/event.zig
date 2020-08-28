// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const std = @import("std");

pub const key = @import("event/key.zig");
pub const mouse = @import("event/mouse.zig");

const view = @import("view.zig");
pub const Size = view.Size;

pub const KeyCallback = fn (e: key.Event) void;
pub const MouseCallback = fn (e: mouse.Event) void;
pub const ResizeCallback = fn (e: Size) void;

const Thread = std.thread.Thread;

pub const Handler = struct {
    // TODO: Add field to keep track of child thread
    key_callbacks: std.ArrayList(KeyCallback),
    mouse_callbacks: std.ArrayList(MouseCallback),
    resize_callbacks: std.ArrayList(ResizeCallback),
    running: bool,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator) Handler {
        return Handler{
            .key_callbacks = std.ArrayList(KeyCallback).init(allocator),
            .mouse_callbacks = std.ArrayList(MouseCallback).init(allocator),
            .resize_callbacks = std.ArrayList(ResizeCallback).init(allocator),
            .running = false,
        };
    }

    pub fn deinit(self: *Self) void {
        if (self.running) self.end();
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

    pub fn registerKeyCallback(self: *Self, function: KeyCallback) !void {
        try self.key_callbacks.append(function);
    }

    pub fn registerMouseCallback(self: *Self, function: MouseCallback) !void {
        try self.mouse_callbacks.append(function);
    }

    pub fn registerResizeCallback(
        self: *Self,
        function: ResizeCallback,
    ) !void {
        try self.resize_callbacks.append(function);
    }
};
