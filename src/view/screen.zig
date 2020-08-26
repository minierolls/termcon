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
    // TODO: Figure out what Zig idiomatic mutex/async protection is,
    //       and implement for Screen
    size: Size,
    cursor: Cursor,
    default_style: Style,
    allocator: *std.mem.Allocator,
    buffer: std.ArrayList(Cell),
    buffer_size: Size,

    const Self = @This();

    pub fn init(allocator: *std.mem.Allocator, buffer_size: ?Size) !Screen {
        var result: Screen = Screen{
            .cursor = Cursor{},
            .allocator = allocator,
            .buffer_size = buffer_size orelse Size{ .rows = 300, .cols = 100 },
            .default_style = Style{}, // TODO
        };
        try result.updateSize();
        result.buffer = std.ArrayList(Cell).init(allocator);
        try result.buffer.ensureCapacity(result.buffer_size.rows * result.buffer_size.cols);
        std.mem.set(Cell, result.buffer.items, Cell{
            .rune = Rune{ .value = ' ' },
            .style = result.default_style,
        });
        return result;
    }

    pub fn deinit(self: *Self) void {
        self.buffer.deinit();
    }

    pub fn draw(
        self: *Self,
        buffer_origin: ?Position,
        screen_origin: ?Position,
    ) !void {
        try self.drawPartial(
            Size{
                .rows = self.size.rows - screen_origin.row,
                .cols = self.size.cols - screen_origin.col,
            },
            buffer_origin,
            screen_origin,
        );
    }

    pub fn drawPartial(
        self: *Self,
        size: Size,
        buffer_origin: ?Position,
        screen_origin: ?Position,
    ) !void {
        // TODO: Figure out how to get `zig fmt` *not* to inline everything
        if (size.rows + buffer_origin.row > self.buffer_size.rows or size.cols + buffer_origin.col > self.buffer_size.cols)
            return error.OutOfRange;
        if (size.rows + screen_origin.row > self.size.rows or size.cols + buffer_origin.col > self.size.cols)
            return error.OutOfRange;
        @compileError("Unimplemented");
    }

    pub fn getSize(self: *const Self) Size {
        return self.size;
    }

    pub fn updateSize(self: *Self) !void {
        self.size = try backend.screen.getSize();
    }

    pub fn getBufferSize(self: *const Self) Size {
        return self.size;
    }

    /// Resize the buffer. This function call is expensive; try to minimize
    /// its use. During resize, all cells that are beyond the new row or
    /// column limit are ignored. Any new cells introduced from an expansion
    /// in rows or columns is filled with either the provided `fill_cell` or
    /// an empty default-style cell.
    pub fn setBufferSize(self: *Self, size: Size, fill_cell: ?Cell) !void {
        const b_rows = self.buffer_size.rows;
        const b_cols = self.buffer_size.cols;

        if (size.rows * size.cols != b_rows * b_cols) {
            try self.buffer.ensureCapacity(size.rows * size.cols);
        }

        if (size.cols < b_cols) {
            var row_index: @Type(b_rows) = 1;
            while (row_index < b_rows) : (row_index += 1) {
                std.mem.copy(
                    Cell,
                    self.buffer.items[row_index * b_cols .. row_index * b_cols + size.cols],
                    self.buffer.itmes[row_index * size.cols .. (row_index + 1) * size.cols],
                );
            }
        } else if (size.cols > b_cols) {
            var row_index: @Type(b_rows) = b_rows;
            while (row_index > 0) : (row_index -= 1) {
                r_i = row_index - 1;
                std.mem.copyBackwards(
                    Cell,
                    self.buffer.items[r_i * size.cols .. r_i * size.cols + b_cols],
                    self.buffer.items[r_i * b_cols .. row_index * b_cols],
                );
                std.mem.set(
                    Cell,
                    self.buffer.items[r_i * size.cols + b_cols .. row_index * size.cols],
                    fill_cell orelse Cell{
                        .rune = Rune{ .value = ' ' },
                        .style = self.default_style,
                    },
                );
            }
        }

        if (size.rows > b_rows) {
            std.mem.set(
                Cell,
                self.buffer.items[b_rows * size.cols .. size.rows * size.cols],
                fill_cell orelse Cell{
                    .rune = Rune{ .value = ' ' },
                    .style = self.default_style,
                },
            );
        }

        self.buffer_size.rows = size.rows;
        self.buffer_size.cols = size.cols;
    }

    pub fn getDefaultStyle(self: *const Self) Style {
        return self.default_style;
    }

    pub fn setDefaultStyle(self: *Self, style: Style) void {
        self.default_style = style;
    }

    pub fn getCell(self: *const Self, position: Position) !Cell {
        if (position.row >= self.buffer_size.rows or position.col >= self.buffer_size.cols)
            return error.OutOfRange; // TODO: Better understand defining errors

        return self.buffer.items[position.row * self.buffer_size.cols + position.col];
    }

    pub fn setCell(
        self: *Self,
        position: Position,
        rune: ?Rune,
        style: ?Style,
    ) !void {
        if (position.row >= self.buffer_size.rows or position.col >= self.buffer_size.cols)
            return error.OutOfRange; // TODO: Better understand defining errors

        if (rune == null and style == null) return;

        self.buffer.items[position.row * self.buffer_size.cols + position.col] = Cell{
            .rune = rune orelse Rune{ .value = ' ' },
            .style = style orelse self.default_style,
        };
    }
};
