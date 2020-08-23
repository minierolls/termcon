// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

// TODO: Define colors based on what is available in environment
pub const Color = enum {
    _
};

// TODO: Define type styles based on what is available in environment
pub const TextStyle = enum {
    Bold, Italic, Underline, Strikethrough, _
};

pub const Style = struct {
    fg_color: ?Color, bg_color: ?Color, text_styles: ?[]TextStyle
};
