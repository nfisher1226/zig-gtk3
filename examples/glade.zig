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
    const builder = gtk.Builder.new();
    const glade_str = @embedFile("example.glade");
    builder.add_from_string(@embedFile("example.glade")) catch |e| {
        std.debug.print("{s}\n", .{e});
        return;
    };
    builder.set_application(app);
    const window = builder.get_widget("window").?.to_window().?;
    window.set_decorated(false);
    window.as_widget().show_all();
    window.as_widget().connect("delete-event", @ptrCast(gtk.GCallback, gtk.gtk_main_quit), null);

    gtk.gtk_main();
}
