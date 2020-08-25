// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const std = @import("std");

const backend = @import("../backend.zig").backend;

const view = @import("../view.zig");
pub const Cell = view.Cell;
pub const Position = view.Position;
pub const Rune = view.Rune;
pub const Style = view.Style;
pub const Cursor = view.Cursor;

pub const Size = struct {
    rows: u16, cols: u16
};

pub const Screen = struct {
    buffer: std.ArrayList(std.ArrayList(Cell)),
    size: Size,
    cursor: Cursor,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator) Screen {
        @compileError("Unimplemented");
    }

    pub fn deinit(self: *Self) void {
        @compileError("Unimplemented");
    }

    pub fn draw(self: *Self) !void {
        @compileError("Unimplemented");
    }

    pub fn getSize(self: *const Self) Size {
        @compileError("Unimplemented");
    }

    pub fn updateSize(self: *Self) !void {
        @compileError("Unimplemented");
    }

    pub fn getCell(self: *const Self, position: Position) !Cell {
        @compileError("Unimplemented");
    }

    pub fn setCell(
        self: *Self,
        position: Position,
        rune: ?Rune,
        style: ?Style,
    ) !void {
        @compileError("Unimplemented");
    }

    pub fn setCells(
        self: *Self,
        position: Position,
        runes: ?[]const Rune,
        style: ?Style,
    ) !void {
        @compileError("Unimplemented");
    }
};
