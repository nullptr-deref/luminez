const std = @import("std");

const glfw = @cImport(@cInclude("GLFW/glfw3.h"));
const gl = @cImport(@cInclude("GL/glew.h"));

const Renderer = @This();

const Logger = @import("Logger.zig");

pub const ContextSettings = struct {
    width: usize,
    height: usize,
    title: []const u8,
};

pub const Context = struct {
    native_context_handle: *glfw.GLFWwindow,

    fn init(settings: ContextSettings) !Context {
        const ctx = glfw.glfwCreateWindow(
            @intCast(settings.width),
            @intCast(settings.height),
            @ptrCast(settings.title),
            null,
            null,
        ) orelse return error.InvalidContext;

        return Context{ .native_context_handle = ctx };
    }

    fn deinit(self: *Context) void {
        glfw.glfwDestroyWindow(self.native_context_handle);
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

    _ = glewInit() orelse return error.GlewInitFailed;

    return Renderer{ .context = context };
}

pub fn windowShouldClose(self: Renderer) bool {
    return glfw.glfwWindowShouldClose(self.context.native_context_handle) == glfw.GLFW_TRUE;
}

pub fn renderFrame(self: *Renderer) void {
    glfw.glfwSwapBuffers(self.context.native_context_handle);
}

pub fn setCurrentContext(self: *Renderer, ctx: *Context) void {
    self.context = ctx;
    glfw.glfwMakeContextCurrent(self.context.native_context_handle);
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

/// Returns `null` if GLEW was initialized successfully,
/// otherwise returns error code.
fn glewInit() ?u8 {
    const glew_status = gl.glewInit();
    return if (glew_status == gl.GLEW_OK) null else @intCast(glew_status);
}
