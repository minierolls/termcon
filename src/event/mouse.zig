// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const backend = @import("../backend.zig").backend;
const view = @import("../view.zig");
pub const Position = view.Position;

pub const Button = enum {
    Main, // Left Mouse Button
    Secondary, // Right Mouse Button
    Auxiliary, // Middle Mouse Button
    Fourth,
    Fifth,
};

pub const Action = enum {
    ScrollUp,
    ScrollDown,
    Click,
    DoubleClick,
    TripleClick,
    _,
};

pub const Event = struct {
    action: Action,
    button: ?Button,
    position: ?Position,

    pub fn poll() !?Event {
        return backend.event.getMouseEvent();
    }
};
