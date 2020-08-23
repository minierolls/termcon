// Copyright (c) 2020 John Namgung.

// SPDX-License-Identifier: MIT
// This file is part of the `termcon` project under the MIT license.

const std = @import("std");
const Builder = std.build.Builder;
const fs = std.fs;

pub fn build(b: *Builder) !void {
    b.setPreferredReleaseMode(.ReleaseFast);
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const output_path = fs.path.join(b.allocator, &[_][]const u8{ b.build_root, "build" }) catch unreachable;

    const lib = b.addStaticLibrary("termcon", "src/termcon.zig");
    lib.setBuildMode(mode);
    lib.setTarget(target);
    lib.setOutputDir(output_path);
    lib.linkLibC();
    // lib.emit_h = true; // TODO: Expose public C interface

    b.default_step.dependOn(&lib.step);
}
