const std = @import("std");
usingnamespace @import("gtk");

pub fn main() !void {
    const app = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, activate),
        null,
        null,
        c.G_CONNECT_AFTER,
    );
    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}

fn activate(app: *c.GtkApplication) void {
    const builder = gtk.Builder.new();
    builder.add_from_string(@embedFile("example.glade")) catch |e| {
        std.debug.print("{s}\n", .{e});
        return;
    };
    builder.set_application(app);
    // Builder.get_widget() returns an optional, so unwrap if there is a value
    if (builder.get_widget("window")) |w| {
        w.show_all();
        w.connect("delete-event", @ptrCast(c.GCallback, c.gtk_main_quit), null);
        // Widget.to_[otherwidget]() functions return an optional, as we're going to check
        // whether it's a valid instance before returning
        if (w.to_window()) |window| {
            window.set_decorated(false);
        }
    }
    if (builder.get_widget("ok_button")) |w| {
        if (w.to_button()) |b| {
            b.connect_clicked(@ptrCast(c.GCallback, c.gtk_main_quit), null);
        }
    }
    if (builder.get_widget("cancel_button")) |w| {
        if (w.to_button()) |b| {
            b.connect_clicked(@ptrCast(c.GCallback, c.gtk_main_quit), null);
        }
    }

    c.gtk_main();
}
