const std = @import("std");
const gtk = @import("gtk");
const allocator = std.heap.page_allocator;
const fmt = std.fmt;
const mem = std.mem;

var widgets: Widgets = undefined;

const Widgets = struct {
    window: gtk.ApplicationWindow,
    label: gtk.Label,
    button: gtk.Button,

    fn init(app: *gtk.GtkApplication) Widgets {
        return Widgets {
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
        self.button.connect_clicked(@ptrCast(gtk.GCallback, button_callback), null);
    }
};

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

fn button_callback(button: *gtk.GtkButton, data: gtk.gpointer) void {
    widgets.toggle_label();
}
