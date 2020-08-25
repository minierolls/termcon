// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

//! Ziro is a super-simple terminal text editor written in Zig.
//! Ziro is inspired by [kilo](https://github.com/antirez/kilo),
//! and is intended to provide an example of using the `termcon`
//! library.

const std = @import("std");

const termcon = @import("../src/termcon.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
}