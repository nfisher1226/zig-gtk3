const std = @import("std");
const gtk = @import("gtk");
const mem = std.mem;

var widgets: Widgets = undefined;
var toggled = false;

const Widgets = struct {
    window: *gtk.GtkWidget,
    label: *gtk.GtkWidget,
    button: *gtk.GtkWidget,

    fn init(app: *gtk.GtkApplication) Widgets {
        return Widgets {
            .window = gtk.gtk_application_window_new(app),
            .label = gtk.gtk_label_new("Off"),
            .button = gtk.gtk_button_new_with_label("Click Me"),
        };
    }

    fn toggle_label(self: Widgets) void {
        const label_ptr = @ptrCast(*gtk.GtkLabel, self.label);
        if (toggled) {
            gtk.gtk_label_set_text(label_ptr, "Off");
            toggled = false;
        } else {
            gtk.gtk_label_set_text(label_ptr, "On");
            toggled = true;
        }
    }

    fn connect_signals(self: Widgets) void {
        _ = gtk.signal_connect(
            self.button, "clicked", @ptrCast(gtk.GCallback, button_callback), null);
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
    const window_ptr = @ptrCast(*gtk.GtkWindow, widgets.window);
    const box = gtk.Box.new(gtk.Orientation.vertical, 5);
    box.pack_start(widgets.label, false, true, 1);
    box.pack_start(widgets.button, false, true, 1);
    gtk.gtk_container_add(
        @ptrCast(*gtk.GtkContainer, widgets.window),
        @ptrCast(*gtk.GtkWidget, box.ptr),
    );
    gtk.gtk_window_set_title(window_ptr, "Callbacks Example");
    gtk.gtk_window_set_default_size(window_ptr, 400, -1);
    gtk.gtk_widget_show_all(widgets.window);
}

fn button_callback(button: *gtk.GtkButton, data: gtk.gpointer) void {
    const label = @ptrCast(*gtk.GtkLabel, widgets.label);
    widgets.toggle_label();
}
