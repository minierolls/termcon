// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

pub const Color = struct {};

pub const TextDecorations = struct {
    italic: bool,
    bold: bool,
    underline: bool,
};

pub const Style = struct {
    fg_color: Color,
    bg_color: Color,
    text_decorations: TextDecorations,
};
