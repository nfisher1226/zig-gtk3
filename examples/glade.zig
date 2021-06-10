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
    const builder = gtk.gtk_builder_new();
    const glade_str = @embedFile("example.glade");
    var ret = gtk.gtk_builder_add_from_string(builder, glade_str, glade_str.len, @intToPtr([*c][*c]gtk._GError, 0));
    if (ret == 0) {
        std.debug.print("builder file fail\n", .{});
        std.process.exit(1);
    }
    gtk.gtk_builder_set_application(builder, app);
    // The Gtk function gtk_builder_get_object returns a generic gobject pointer,
    // which must be cast (twice) to get a proper widget pointer. The function
    // builder_get_widget is a convenience function which returns a proper widget
    // pointer or null (should you give it a bad string).
    const window = gtk.builder_get_widget(builder, "window").?;
    // In gtk, inheritance is faked because there is no inhertance in C. In order
    // to have access to all methods of a widget, our window is currently a widget
    // type pointer. What follows is that in order to use window methods, we have
    // to cast the pointer to a window type pointer
    const window_ptr = @ptrCast(*gtk.GtkWindow, window);
    gtk.gtk_window_set_decorated(window_ptr, 0);
    gtk.gtk_widget_show_all(window);
    // g_signal_connect is broken for Zig as it is defined in an ugle macro, so
    // call our re-implementation of it instead.
    _ = gtk.signal_connect(
        window, "delete-event", @ptrCast(gtk.GCallback, gtk.gtk_main_quit), null);

    gtk.gtk_main();
}
