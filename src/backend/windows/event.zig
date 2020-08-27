// Copyright (c) 2020 John Namgung, Luke I. Wilson.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const event = @import("../../event.zig");
const mouse = event.mouse;
const key = event.key;

pub fn getMouseEvent() !?mouse.Event {
    @compileError("Unimplemented");
}

pub fn getKeyEvent() !?key.Event {
    @compileError("Unimplemented");
}
