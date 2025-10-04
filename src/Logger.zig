const std = @import("std");

const File = std.fs.File;

pub const Logger = @This();

stdout: File,
stderr: File,

pub const init = Logger{
    .stdout = std.io.getStdOut(),
    .stderr = std.io.getStdErr(),
};

pub fn printError(self: Logger, comptime fmt_str: []const u8, ins: anytype) !void {
    var bw = std.io.bufferedWriter(self.stderr.writer());
    const writer = bw.writer();
    _ = try writer.print(fmt_str, ins);
    try bw.flush();
}

pub fn printMessage(self: Logger, comptime fmt_str: []const u8, ins: anytype) !void {
    var bw = std.io.bufferedWriter(self.stdout.writer());
    const writer = bw.writer();
    _ = try writer.print(fmt_str, ins);
    try bw.flush();
}
