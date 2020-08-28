// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const view = @import("../view.zig");
const Rune = view.Rune;
const Style = view.Style;

pub const Position = struct {
    row: u16,
    col: u16,

    const Self = @This();

    pub fn equal(self: *const Self, other: Position) bool {
        return self.row == other.row and self.col == other.col;
    }

    pub fn less(self: *const Self, other: Position) bool {
        if (self.row < other.row) return true;
        return self.row == other.row and self.col < other.col;
    }
};

pub const Cell = struct {
    rune: Rune, style: Style
};
