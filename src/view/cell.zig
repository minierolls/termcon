// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const view = @import("../view.zig");
const Rune = view.Rune;
const Style = view.Style;

pub const Position = struct {
    row: u16, col: u16
};

pub const Cell = struct {
    rune: ?Rune, style: ?Style
};
