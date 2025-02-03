const std = @import("std");
const glfw = @import("mach-glfw");
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

    window_real.setDropCallback(dropCallback);

    window_real.setSizeCallback(glfwWindowSizeCallback);

    glfw.swapInterval(1);

    const points: [9]f64 = .{ 0.0, 0.5, 0.0, 0.5, -0.5, 0.0, -0.5, -0.5, 0.0 };
    _ = points; // autofix

    while (!window_real.shouldClose()) {
        window_real.swapBuffers();

        if (window_real.getKey(glfw.Key.enter) == glfw.Action.press) {
            window_real.destroy();
        }

        glfw.pollEvents();
    }
}

fn dropCallback(window: glfw.Window, paths: [][*:0]const u8) void {
    _ = window;
    std.debug.print("dropped {} files:\n", .{paths.len});
    for (paths, 0..) |path, i| {
        std.debug.print("{}: {s}\n", .{ i, path });
    }

    //    var video = try ffmpeg.Video.open(paths[0]);
    //    defer video.close();
    //
    //    const videoWidth = video.width;
    //    const videoHeight = video.height;
    //    // const frameDuration = std.time.ns_per_s / video.frame_rate;
    //
    //    var texture: u32 = 0;
    //    gl.GenTextures(1, &texture);
    //    gl.BindTexture(gl.TEXTURE_2D, texture);
    //    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    //    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    //
    //    const startTime = std.time.nanoTimestamp();
    //
    //    while (!window.shouldClose()) {
    //        const elapsed = std.time.nanoTimestamp() - startTime;
    //
    //        const frame = video.decodeFrame(elapsed);
    //        if (frame) {
    //            gl.BindTexture(gl.TEXTURE_2D, texture);
    //            gl.TexSubImage2D(gl.TEXTURE_2D, 0, 0, 0, videoWidth, videoHeight, gl.RGBA, gl.UNSIGNED_BYTE, frame.data);
    //        }
    //
    //        gl.Clear(gl.COLOR_BUFFER_BIT);
    //
    //        window.swapBuffers();
    //        glfw.pollEvents();
    //    }
}
