// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const backend = @import("../backend.zig").backend;
const view = @import("../view.zig");
pub const Rune = view.Rune;

pub const ModifierKey = enum(u4) {
    Shift,
    Control,
    Alternate,
    AlternateGraphic,
    Meta,
    Function,
    _,
};

pub const FunctionKey = enum {
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
};

pub const NavigationKey = enum {
    Escape,
    Home,
    End,
    PageUp,
    PageDown,
    ArrowUp,
    ArrowDown,
    ArrowLeft,
    ArrowRight,
};

pub const EditKey = enum {
    Backspace,
    Insert,
    Delete,
};

pub const ValueType = enum {
    AlphaNumeric,
    Function,
    Navigation,
    Edit,
};

pub const Value = union(ValueType) {
    AlphaNumeric: Rune,
    Function: FunctionKey,
    Navigation: NavigationKey,
    Edit: EditKey,
};

pub const Event = struct {
    value: Value,
    modifier: ?ModifierKey,

    pub fn poll() !?Event {
        return backend.event.getKeyEvent();
    }
};
