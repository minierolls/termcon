// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const backend = @import("../backend.zig").backend;
const cursor = backend.cursor;
const view = @import("../view.zig");

pub const Position = view.Position;

pub const Cursor = struct {
    pub fn getPosition() !Position {
        return cursor.getPosition();
    }

    pub fn setPosition(position: Position) !void {
        return cursor.setPosition(position);
    }

    pub fn getVisibility() bool {
        return cursor.getVisibility();
    }

    pub fn setVisibility(visible: bool) !void {
        return cursor.setVisibility(visible);
    }
};
