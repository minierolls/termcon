// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const view = @import("../../view.zig");

pub const Position = view.Position;

pub fn getPosition() !Position {
    @compileError("Unimplemented");
}

pub fn setPosition(position: Position) !void {
    @compileError("Unimplemented");
}
