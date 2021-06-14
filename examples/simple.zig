const std = @import("std");
usingnamespace @import("gtk");

pub fn main() !void {
    const app = c.gtk_application_new("org.gtk.example", .G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    // Call the C function directly to connect our "activate" signal
    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, activate),
        null,
        null,
        gtk.connect_after,
    );
    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}

// Whatever we connect to the "activate" signal in main() actually builds and runs our application window
fn activate(app: *c.GtkApplication, data: c.gpointer) void {
    // Create an ApplicationWindow using our *GtkApplication pointer, which we then use as a window
    // in order to inherit the Window methods
    const window = gtk.ApplicationWindow.new(app).as_window();
    window.set_title("Example Program");
    window.set_default_size(400, 400);
    // show_all() is a Widget method
    window.as_widget().show_all();
}
