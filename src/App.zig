const std = @import("std");
const glfw = @cImport(@cInclude("GLFW/glfw3.h"));

const Renderer = @import("Renderer.zig");
const Logger = @import("Logger.zig");

const App = @This();

const EXIT_FAILURE = 127;

running: bool,
renderer: Renderer,

pub fn init(width: usize,
    height: usize,
    title: []const u8,
    allocator: std.mem.Allocator,
) !App {
    return App{
        .running = true,
        .renderer = try Renderer.init(width, height, title, allocator),
    };
}

pub fn deinit(self: *App) void {
    self.running = false;
}

pub fn run(self: *App) anyerror!void {
    glfw.glfwWindowHint(glfw.GLFW_DECORATED, glfw.GLFW_FALSE);
    glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MINOR, 3);

    self.running = true;

    while (!self.renderer.windowShouldClose()) {
        glfw.glfwPollEvents();
        self.renderer.renderFrame();
    }
}
