// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

//! Ziro is a super-simple terminal text editor written in Zig.
//! Ziro is inspired by [kilo](https://github.com/antirez/kilo),
//! and is intended to provide an example of using the `termcon`
//! library.

const std = @import("std");

const termcon = @import("termcon");
const Rune = termcon.view.Rune;
const Position = termcon.view.Position;
const Cell = termcon.view.Cell;
const Style = termcon.view.Style;
const Color = termcon.view.Color;
const ColorBit8 = termcon.view.ColorBit8;
const TextDecorations = termcon.view.TextDecorations;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const options = termcon.Options{
        .raw_mode = true,
        .alternate_screen = true,
        .use_handler = true,
    };

    var tcon = try termcon.TermCon.init(&gpa.allocator, options);
    defer _ = tcon.deinit();

    // var cpos = try tcon.screen.cursor.getPosition();
    // std.debug.warn("cpos: x:{} y:{}", .{cpos.col, cpos.row});

    try tcon.screen.setCell(
        Position{ .row = 0, .col = 0 },
        Cell{
            .rune = 'X',
            .style = Style{
                .fg_color = Color{ .Bit8 = ColorBit8{ .code = 148 } },
                .bg_color = Color{ .Bit8 = ColorBit8{ .code = 197 } },
                .text_decorations = TextDecorations{
                    .italic = false,
                    .bold = true,
                    .underline = false,
                },
            },
        },
    );
    try tcon.screen.setCell(
        Position{ .row = 0, .col = 1 },
        Cell{
            .rune = 'X',
            .style = tcon.screen.getDefaultStyle(),
        },
    );
    try tcon.screen.draw();
}
