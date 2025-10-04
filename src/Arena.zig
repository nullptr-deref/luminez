const Arena = @This();

pub const width = 16;
pub const height = 24;

cells: [width*height]u8 = [_]u8{0} ** (width * height),

pub fn clearCells(self: *Arena) void {
    for (&self.cells) |*cell| {
        cell.* = 0;
    }
}

pub var init: Arena = .{};
