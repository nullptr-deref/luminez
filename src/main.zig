const std = @import("std");

const App = @import("App.zig");

pub fn main() !void {
    const game_title = "lumines";
    var app = try App.init(640, 480, game_title);
    defer app.deinit();

    try app.run();
}
