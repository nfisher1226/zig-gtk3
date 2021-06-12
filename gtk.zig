pub usingnamespace @import("src/enums.zig");
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// The Gtk function g_signal_connect is defined in a macro which is unfortunately
/// broken for translate-c, so we redefine the function doing what the orignal
/// does internally as  workaround.
pub fn signal_connect(instance: gpointer, detailed_signal: [*c]const gchar, c_handler: GCallback, data: gpointer) gulong {
    var zero: u32 = 0;
    const flags: *GConnectFlags = @ptrCast(*GConnectFlags, &zero);
    return g_signal_connect_data(instance, detailed_signal, c_handler, data, null, flags.*);
}

/// Convenience function which returns a proper GtkWidget pointer or null
pub fn builder_get_widget(builder: *GtkBuilder, name: [*]const u8) ?*GtkWidget {
    const obj = gtk_builder_get_object(builder, name);
    if (obj == null) {
        return null;
    } else {
        var gobject = @ptrCast([*c]GTypeInstance, obj);
        var gwidget = @ptrCast(*GtkWidget, g_type_check_instance_cast(gobject, gtk_widget_get_type()));
        return gwidget;
    }
}

/// Convenience function which returns a proper GtkAdjustment pointer or null
pub fn builder_get_adjustment(builder: *GtkBuilder, name: [*]const u8) ?*GtkAdjustment {
    const obj = gtk_builder_get_object(builder, name);
    if (obj == null) {
        return null;
    } else {
        var gobject = @ptrCast([*c]GTypeInstance, obj);
        var adjustment = @ptrCast(*GtkAdjustment, gobject);
        return adjustment;
    }
}

/// Convenience function which returns a proper bool instead of 0 or 1
pub fn toggle_button_get_active(but: *GtkToggleButton) bool {
    if (gtk_toggle_button_get_active(but) == 0) {
        return false;
    } else {
        return true;
    }
}

/// Convenience function which takes a proper bool instead of 0 or 1
pub fn widget_set_sensitive(widget: *GtkWidget, state: bool) void {
    if (state) {
        gtk_widget_set_sensitive(widget, 1);
    } else {
        gtk_widget_set_sensitive(widget, 0);
    }
}

/// Convenience function which takes a proper bool instead of 0 or 1
pub fn widget_set_visible(widget: *GtkWidget, state: bool) void {
    if (state) {
        gtk_widget_set_visible(widget, 1);
    } else {
        gtk_widget_set_visible(widget, 0);
    }
}

pub const ApplicationWindow = struct {
    ptr: *GtkApplicationWindow,

    pub fn new(app: *GtkApplication) ApplicationWindow {
        return ApplicationWindow {
            .ptr = @ptrCast(*GtkApplicationWindow, gtk_application_window_new(app)),
        };
    }

    pub fn as_window(self: ApplicationWindow) Window {
        return Window {
            .ptr = @ptrCast(*GtkWindow, self.ptr),
        };
    }

    pub fn as_container(self: ApplicationWindow) Container {
        return Container {
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: ApplicationWindow) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Window = struct {
    ptr: *GtkWindow,

    pub fn new(window_type: WindowType) Window {
        return Window {
            .ptr = @ptrCast(*GtkWindow, gtk_window_new(window_type.parse())),
        };
    }

    pub fn set_title(self: Window, title: [:0]const u8) void {
        gtk_window_set_title(self.ptr, title);
    }

    pub fn set_default_size(self: Window, hsize: c_int, vsize: c_int) void {
        gtk_window_set_default_size(self.ptr, hsize, vsize);
    }

    pub fn set_decorated(self: Window, decorated: bool) void {
        const val = bool_to_c_int(decorated);
        gtk_window_set_decorated(self.ptr, val);
    }

    pub fn as_container(self: Window) Container {
        return Container {
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Window) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Box = struct {
    ptr: *GtkBox,

    pub fn new(orientation: Orientation, spacing: u8) Box {
        const gtk_orientation = orientation.parse();
        return Box {
            .ptr = @ptrCast(*GtkBox, gtk_box_new(gtk_orientation, @as(c_int, spacing))),
        };
    }

    pub fn pack_start(self: Box, widget: Widget, expand: bool, fill: bool, padding: u8) void {
        const ex: c_int = if (expand) 1 else 0;
        const fl: c_int = if (fill) 1 else 0;
        gtk_box_pack_start(self.ptr, widget.ptr, ex, fl, @as(c_uint, padding));
    }

    pub fn pack_end(self: Box, widget: *GtkWidget, expand: bool, fill: bool, padding: u8) void {
        const ex: c_int = if (expand) 1 else 0;
        const fl: c_int = if (fill) 1 else 0;
        gtk_box_pack_end(self.ptr, widget, ex, fl, @as(c_uint, padding));
    }

    pub fn as_orientable(self: Box) Orientable {
        return Orientable {
            .ptr = @ptrCast(*GtkOrientable, self.ptr),
        };
    }

    pub fn as_container(self: Box) Container {
        return Container {
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Box) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Orientable = struct {
    ptr: *GtkOrientable,

    pub fn as_widget(self: Box) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Container = struct {
    ptr: *GtkContainer,

    pub fn add(self: Container, widget: Widget) void {
        gtk_container_add(self.ptr, widget.ptr);
    }

    pub fn as_widget(self: Box) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Label = struct {
    ptr: *GtkLabel,

    pub fn new(text: ?[:0]const u8) Label {
        return Label {
            .ptr = if (text) |t| @ptrCast(*GtkLabel, gtk_label_new(t)) else @ptrCast(*GtkLabel, gtk_label_new(null)),
        };
    }

    pub fn get_text(self: Label, allocator: *mem.Allocator) ?[:0]const u8 {
        const val = gtk_label_get_text(self.ptr);
        const len = mem.len(val);
        const text = fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch {
            return null;
        };
        return text;
    }

    pub fn set_text(self: Label, text: [:0]const u8) void {
        gtk_label_set_text(self.ptr, text);
    }

    pub fn as_widget(self: Label) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Button = struct {
    ptr: *GtkButton,

    pub fn new_with_label(text: [:0]const u8) Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, gtk_button_new_with_label(text)),
        };
    }

    pub fn as_widget(self: Button) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn connect_clicked(self: Button, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            self.as_widget().connect("clicked", callback, d);
        } else {
            self.as_widget().connect("clicked", callback, null);
        }
    }
};

pub const Widget = struct {
    ptr: *GtkWidget,

    pub fn show_all(self: Widget) void {
        gtk_widget_show_all(self.ptr);
    }

    pub fn connect(self: Widget, sig: [:0]const u8, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            _ = signal_connect(self.ptr, sig, callback, d);
        } else {
            _ = signal_connect(self.ptr, sig, callback, null);
        }
    }

    pub fn to_window(self: Widget) ?Window {
        return Window {
            .ptr = @ptrCast(*GtkWindow, self.ptr),
        };
    }
};

const BuilderError = error {
    ParseStringError,
    ParseFileError,
};

pub const Builder = struct {
    ptr: *GtkBuilder,

    pub fn new() Builder {
        return Builder {
            .ptr = gtk_builder_new(),
        };
    }

    pub fn add_from_string(self: Builder, string: []const u8) BuilderError!void {
        const len = mem.len(string);
        var ret = gtk_builder_add_from_string(self.ptr, string.ptr, len, @intToPtr([*c][*c]_GError, 0));
        if (ret == 0) {
            return BuilderError.ParseStringError;
        }
    }

    pub fn get_widget(self: Builder, string: [:0]const u8) ?Widget {
        if (builder_get_widget(self.ptr, string.ptr)) |w| {
            return Widget {
                .ptr = w,
            };
        } else return null;
    }

    pub fn get_adjustment(self: Builder, string: [:0]const u8) ?Adjustment {
        if (builder_get_adjustment(self.ptr, string.ptr)) |a| {
            return Adjustment {
                .ptr = a,
            };
        } else return null;
    }

    pub fn set_application(self: Builder, app: *GtkApplication) void {
        gtk_builder_set_application(self.ptr, app);
    }
};

pub const Adjustment = struct {
    ptr: *GtkAdjustment,
};

///Support functions
fn bool_to_c_int(boolean: bool) c_int {
    const val: c_int = if (boolean) 1 else 0;
    return val;
}
