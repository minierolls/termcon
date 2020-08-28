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
    screen: *view.Screen,
    key_callbacks: std.ArrayList(KeyCallback),
    mouse_callbacks: std.ArrayList(MouseCallback),
    resize_callbacks: std.ArrayList(ResizeCallback),
    main_loop: std.Thread,
    running: bool,

    const Self = @This();

    pub fn init(
        allocator: *std.mem.Allocator,
        screen: *view.Screen,
    ) Handler {
        return Handler{
            .screen = screen,
            .key_callbacks = std.ArrayList(KeyCallback).init(allocator),
            .mouse_callbacks = std.ArrayList(MouseCallback).init(allocator),
            .resize_callbacks = std.ArrayList(ResizeCallback).init(allocator),
            .main_loop = undefined,
            .running = false,
        };
    }

    pub fn deinit(self: *Self) void {
        if (self.running) self.end();
        self.key_callbacks.deinit();
        self.mouse_callbacks.deinit();
        self.resize_callbacks.deinit();
    }

    pub fn start(self: *Self, poll_rate: u8) !void {
        // Note: This should start an infinite loop
        //       in another thread and immediately return
        self.running = true;
        self.main_loop = std.Thread.spawn(
            MainLoopContext{
                .poll_rate = poll_rate,
                .screen = self.screen,
                .run_flag = &self.running,
                .key_callbacks = &self.key_callbacks,
                .mouse_callbacks = &self.mouse_callbacks,
                .resize_callbacks = &self.resize_callbacks,
            },
            mainLoop,
        ) catch |err| {
            self.running = false;
            return err;
        };
    }

    pub fn end(self: *Self) void {
        self.running = false;
        self.main_loop.wait();
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

    const MainLoopContext = struct {
        poll_rate: u8,
        screen: *view.Screen,
        run_flag: *bool,
        key_callbacks: *std.ArrayList(KeyCallback),
        mouse_callbacks: *std.ArrayList(MouseCallback),
        resize_callbacks: *std.ArrayList(ResizeCallback),
    };

    fn mainLoop(context: MainLoopContext) void {
        while (context.run_flag.*) {
            std.time.sleep(@as(u64, poll_rate) * 1000000);

            if (key.Event.poll() catch null) |keyevent| {
                for (context.key_callbacks.*.items) |callback| {
                    callback(keyevent);
                }
            }
            if (mouse.Event.poll() catch null) |mouseevent| {
                for (context.mouse_callbacks.*.items) |callback| {
                    callback(mouseevent);
                }
            }

            const orig_size: Size = context.screen.getSize();
            context.screen.updateSize() catch {};
            const new_size = context.screen.getSize();
            if (orig_size != new_size) {
                for (context.resize_callbacks.*.items) |callback| {
                    callback(new_size);
                }
            }
        }
    }
};
