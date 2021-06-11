pub usingnamespace @cImport({
    @cInclude("gtk/gtk.h");
});
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// enum GConnectFlags
pub const connect_after = @intToEnum(GConnectFlags, G_CONNECT_AFTER);
pub const connect_swapped = @intToEnum(GConnectFlags, G_CONNECT_SWAPPED);

/// enum IconSize
pub const IconSize = enum {
    icon_size_invalid,
    icon_size_menu,
    icon_size_small_toolbar,
    icon_size_large_toolbar,
    icon_size_button,
    icon_size_dnd,
    icon_size_dialog,

    /// Parses an IconSize into a GtkIconSize
    fn parse(self: IconSize) GtkIconSize {
        switch (self) {
            .icon_size_invalid => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_INVALID),
            .icon_size_menu => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_MENU),
            .icon_size_small_toolbar => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_SMALL_TOOLBAR),
            .icon_size_large_toolbar => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_LARGE_TOOLBAR),
            .icon_size_button => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_BUTTON),
            .icon_size_dnd => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_DND),
            .icon_size_dialog => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_DIALOG),
        }
    }
};

/// Gtk enum GtkIconSize
pub const icon_size_invalid = @intToEnum(GtkIconSize, GTK_ICON_SIZE_INVALID);
pub const icon_size_menu = @intToEnum(GtkIconSize, GTK_ICON_SIZE_MENU);
pub const icon_size_small_toolbar = @intToEnum(GtkIconSize, GTK_ICON_SIZE_SMALL_TOOLBAR);
pub const icon_size_large_toolbar = @intToEnum(GtkIconSize, GTK_ICON_SIZE_LARGE_TOOLBAR);
pub const icon_size_button = @intToEnum(GtkIconSize, GTK_ICON_SIZE_BUTTON);
pub const icon_size_dnd = @intToEnum(GtkIconSize, GTK_ICON_SIZE_DND);
pub const icon_size_dialog = @intToEnum(GtkIconSize, GTK_ICON_SIZE_DIALOG);

/// enum GtkBaselinePosition
pub const baseline_position_top = @intToEnum(GtkBaselinePosition, GTK_BASELINE_POSITION_TOP);
pub const baseline_position_center = @intToEnum(GtkBaselinePosition, GTK_BASELINE_POSITION_CENTER);
pub const baseline_position_bottom = @intToEnum(GtkBaselinePosition, GTK_BASELINE_POSITION_BOTTOM);

/// enum GtkDeleteType
pub const gtk_delete_chars = @intToEnum(GtkDeleteType, GTK_DELETE_CHARS);
pub const gtk_delete_word_ends = @intToEnum(GtkDeleteType, GTK_DELETE_WORD_ENDS);
pub const gtk_delete_words = @intToEnum(GtkDeleteType, GTK_DELETE_WORDS);
pub const gtk_delete_line_ends = @intToEnum(GtkDeleteType, GTK_DELETE_LINE_ENDS);
pub const gtk_delete_lines = @intToEnum(GtkDeleteType, GTK_DELETE_LINES);
pub const gtk_delete_paragraph_ends = @intToEnum(GtkDeleteType, GTK_DELETE_PARAGRAPH_ENDS);
pub const gtk_delete_paragraphs = @intToEnum(GtkDeleteType, GTK_DELETE_PARAGRAPHS);
pub const gtk_delete_whitespace = @intToEnum(GtkDeleteType, GTK_DELETE_WHITESPACE);

/// enum GtkDirectionType
pub const dir_tab_forward = @intToEnum(GtkDirectionType, GTK_DIR_TAB_FORWARD);
pub const dir_tab_backward = @intToEnum(GtkDirectionType, GTK_DIR_TAB_BACKWARD);
pub const dir_up = @intToEnum(GtkDirectionType, GTK_DIR_UP);
pub const dir_down = @intToEnum(GtkDirectionType, GTK_DIR_DOWN);
pub const dir_left = @intToEnum(GtkDirectionType, GTK_DIR_LEFT);
pub const dir_right = @intToEnum(GtkDirectionType, GTK_DIR_RIGHT);

/// enum GtkOrientation
pub const orientation_horizontal = @intToEnum(GtkOrientation, GTK_ORIENTATION_HORIZONTAL);
pub const orientation_vertical = @intToEnum(GtkOrientation, GTK_ORIENTATION_VERTICAL);

pub const Orientation = enum {
    horizontal,
    vertical,

    fn parse(self: Orientation) GtkOrientation {
        switch (self) {
            .horizontal => return orientation_horizontal,
            .vertical => return orientation_vertical,
        }
    }

};

///enum GtkWindowType
pub const window_toplevel = @intToEnum(GtkWindowType, GTK_WINDOW_TOPLEVEL);
pub const window_popup = @intToEnum(GtkWindowType, GTK_WINDOW_POPUP);

pub const WindowType = enum {
    toplevel,
    popup,

    fn parse(self: WindowType) GtkWindowType {
        switch (self) {
            .toplevel => return window_toplevel,
            .popup => return window_popup,
        }
    }
};

/// Enum GtkPackType
pub const pack_end = @intToEnum(GtkPackType, GTK_PACK_END);
pub const pack_start = @intToEnum(GtkPackType, GTK_PACK_START);

/// Enum GtkReliefStyle
pub const relief_normal = @intToEnum(GtkReliefStyle, GTK_RELIEF_NORMAL);
pub const relief_none = @intToEnum(GtkReliefStyle, GTK_RELIEF_NONE);

/// Enum GdkModifierType
pub const shift_mask = @intToEnum(GdkModifierType, GDK_SHIFT_MASK);
/// Mod1 generally maps to Alt key
pub const mod1_mask = @intToEnum(GdkModifierType, GDK_MOD1_MASK);
pub const ctrl_mask = @intToEnum(GdkModifierType, GDK_CONTROL_MASK);

/// Enum GtkAccelFlags
pub const accel_locked = @intToEnum(GtkAccelFlags, GTK_ACCEL_LOCKED);

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

    pub fn as_container(self: Window) Container {
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
};
