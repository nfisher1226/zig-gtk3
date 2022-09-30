const std = @import("std");
const GTK = @import("gtk");
const c = GTK.c;
const gtk = GTK.gtk;
const allocator = std.heap.page_allocator;
const fmt = std.fmt;
const mem = std.mem;

var widgets: Widgets = undefined;

const Widgets = struct {
    window: gtk.ApplicationWindow,
    label: gtk.Label,
    button: gtk.Button,

    fn init(app: *c.GtkApplication) Widgets {
        return Widgets{
            .window = gtk.ApplicationWindow.new(app),
            .label = gtk.Label.new("Off"),
            .button = gtk.Button.new_with_label("Click Me"),
        };
    }

    fn toggle_label(self: Widgets) void {
        const text = self.label.get_text(allocator);
        if (text) |t| {
            defer allocator.free(t);
            if (mem.eql(u8, t, "On")) {
                self.label.set_text("Off");
            } else {
                self.label.set_text("On");
            }
        }
    }

    fn connect_signals(self: Widgets) void {
        self.button.connect_clicked(@ptrCast(c.GCallback, &button_callback), null);
    }
};

pub fn main() !void {
    const app = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, &activate),
        null,
        null,
        c.G_CONNECT_AFTER,
    );
    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}

fn activate(app: *c.GtkApplication) void {
    widgets = Widgets.init(app);
    widgets.connect_signals();
    const box = gtk.Box.new(gtk.Orientation.vertical, 5);
    const window = widgets.window.as_window();
    box.pack_start(widgets.label.as_widget(), false, true, 1);
    box.pack_start(widgets.button.as_widget(), false, true, 1);
    widgets.window.as_container().add(box.as_widget());
    window.set_title("Callbacks Example");
    window.set_default_size(400, -1);
    widgets.window.as_widget().show_all();
}

fn button_callback() void {
    widgets.toggle_label();
}
