// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const backend = @import("../backend.zig").backend;
const cursor = backend.cursor;
const view = @import("../view.zig");

pub const Position = view.Position;

pub const Cursor = struct {
    const Self = @This();

    pub fn getPosition(self: *Self) !Position {
        return cursor.getPosition();
    }

    pub fn setPosition(self: *Self, position: Position) !void {
        return cursor.setPosition(position);
    }

    pub fn getVisibility(self: *Self) bool {
        return cursor.getVisibility();
    }

    pub fn setVisibility(self: *Self, visible: bool) !void {
        return cursor.setVisibility(visible);
    }
};
