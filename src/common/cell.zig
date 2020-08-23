// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const style = @import("style.zig");

pub const Size = struct {
    rows: u16, cols: u16
};

pub const Position = struct {
    row: u16, col: u16
};

pub const Cell = struct {
    value: u8,
    style: style.Style,
};
