const std = @import("std");

const Arena = @import("Arena.zig");

const Game = @This();

arena: *Arena,

pub fn init(arena: *Arena) Arena {
    return .{ .arena = arena };
}
