pub usingnamespace @cImport({
    @cInclude("gtk/gtk.h");
});

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
            .horizontal => return  @intToEnum(GtkOrientation, GTK_ORIENTATION_HORIZONTAL),
            .vertical => return @intToEnum(GtkOrientation, GTK_ORIENTATION_VERTICAL),
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

pub const Box = struct {
    ptr: *GtkBox,

    pub fn new(orientation: Orientation, spacing: u8) Box {
        const gtk_orientation = orientation.parse();
        return Box {
            .ptr = @ptrCast(*GtkBox, gtk_box_new(gtk_orientation, @as(c_int, spacing))),
        };
    }

    pub fn pack_start(self: Box, widget: *GtkWidget, expand: bool, fill: bool, padding: u8) void {
        const ex: c_int = if (expand) 1 else 0;
        const fl: c_int = if (fill) 1 else 0;
        gtk_box_pack_start(self.ptr, widget, ex, fl, @as(c_uint, padding));
    }

    pub fn pack_end(self: Box, widget: *GtkWidget, expand: bool, fill: bool, padding: u8) void {
        const ex: c_int = if (expand) 1 else 0;
        const fl: c_int = if (fill) 1 else 0;
        gtk_box_pack_end(self.ptr, widget, ex, fl, @as(c_uint, padding));
    }
};
