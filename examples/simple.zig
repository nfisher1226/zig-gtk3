const std = @import("std");
const gtk = @import("gtk");

pub fn main() !void {
    const app = gtk.gtk_application_new("org.gtk.example", .G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer gtk.g_object_unref(app);

    _ = gtk.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(gtk.GCallback, activate),
        null,
        null,
        gtk.connect_after,
    );
    _ = gtk.g_application_run(@ptrCast(*gtk.GApplication, app), 0, null);
}

fn activate(app: *gtk.GtkApplication, data: gtk.gpointer) void {
    const window = gtk.gtk_application_window_new(app);
    const window_ptr = @ptrCast(*gtk.GtkWindow, window);
    gtk.gtk_window_set_title(window_ptr, "Example Program");
    gtk.gtk_window_set_default_size(window_ptr, 400, 400);
    gtk.gtk_widget_show_all(window);
}
