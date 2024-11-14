const std = @import("std");
const glfw = @import("glfw");
const gl = @import("gl");
const zm = @import("zm");

var gl_procs: gl.ProcTable = undefined;

fn glfwWindowSizeCallback(window: glfw.Window, width: i32, height: i32) void {
    _ = window;
    gl.Viewport(0, 0, @intCast(width), @intCast(height));
}

pub fn main() !void {
    const status = glfw.init(.{});
    if (!status) {
        @panic("Could not initialize GLFW!");
    }
    defer glfw.terminate();

    const window = glfw.Window.create(1280, 720, "play a Video", null, null, .{});
    const window_real = window.?;
    defer window_real.destroy();

    glfw.makeContextCurrent(window);

    if (!gl_procs.init(glfw.getProcAddress)) {
        @panic("could not get glproc");
    }

    gl.makeProcTableCurrent(&gl_procs);

    window_real.setSizeCallback(glfwWindowSizeCallback);

    glfw.swapInterval(1);

    const points: [9]f64 = .{ 0.0, 0.5, 0.0, 0.5, -0.5, 0.0, -0.5, -0.5, 0.0 };
    _ = points; // autofix

    while (!window_real.shouldClose()) {
        window_real.swapBuffers();

        if (window_real.getKey(glfw.Key.escape) == glfw.Action.press) {
            window_real.destroy();
        }

        glfw.pollEvents();
    }
}
