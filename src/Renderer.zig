const std = @import("std");
const gl = @import("zgl");

const glfw = @cImport(@cInclude("GLFW/glfw3.h"));

const Renderer = @This();

const Logger = @import("Logger.zig");

pub const ContextSettings = struct {
    width: usize,
    height: usize,
    title: []const u8,
};

pub const Context = struct {
    native_handle: *glfw.GLFWwindow,

    fn init(settings: ContextSettings) !Context {
        const ctx = glfw.glfwCreateWindow(
            @intCast(settings.width),
            @intCast(settings.height),
            @ptrCast(settings.title),
            null,
            null,
        ) orelse return error.InvalidContext;

        return Context{ .native_handle = ctx };
    }

    fn deinit(self: *Context) void {
        glfw.glfwDestroyWindow(self.native_handle);
    }
};

context: Context,

pub fn init(
    width: usize,
    height: usize,
    title: []const u8
) !Renderer {
    try glfwInit();

    const context = try Context.init(.{
        .width = width,
        .height = height,
        .title = title,
    });

    glfw.glfwSwapInterval(1);

    return Renderer{ .context = context };
}

pub fn windowShouldClose(self: Renderer) bool {
    return glfw.glfwWindowShouldClose(self.context.native_handle) == glfw.GLFW_TRUE;
}

pub fn renderFrame(self: *Renderer) void {
    glfw.glfwSwapBuffers(self.context.native_handle);
    // TODO: write actual rendering
}

pub fn setCurrentContext(self: *Renderer, ctx: *Context) void {
    self.context = ctx;
    glfw.glfwMakeContextCurrent(self.context.native_handle);
}

pub fn deinit(self: *Renderer) void {
    self.context.deinit();
    glfw.glfwTerminate();
}

fn glfwInit() !void {
    if (glfw.glfwInit() == glfw.GLFW_FALSE) {
        return error.GlfwInitFailed;
    }
}
