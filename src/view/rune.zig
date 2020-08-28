// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

pub const Rune = packed struct {
    value: u8,

    const Self = @This();

    pub fn equal(self: *const Self, other: Rune) bool {
        return self.value == other.value;
    }
};
