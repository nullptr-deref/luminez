const std = @import("std");
const gl = @import("zgl");

const glfw = @cImport(@cInclude("GLFW/glfw3.h"));

const Renderer = @import("Renderer.zig");

const App = @This();

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
    var brick_buffers: [6]gl.Buffer = undefined;
    gl.genBuffers(&brick_buffers);

    while (!self.renderer.windowShouldClose()) {
        glfw.glfwPollEvents();
        self.renderer.renderFrame();
    }
}

//zig vim:et:ts=4:sw=4:tw=80
