const c = @import("cimport.zig");
const enums = @import("enums.zig");

const Actionable = @import("actionable.zig").Actionable;
const Button = @import("button.zig").Button;
const Dialog = @import("dialog.zig").Dialog;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const ColorChooser = struct {
    ptr: *c.GtkColorChooser,

    pub fn get_rgba(self: ColorChooser) c.GdkRGBA {
        var rgba: c.GdkRGBA = undefined;
        _ = c.gtk_color_chooser_get_rgba(self.ptr, &rgba);
        return rgba;
    }

    pub fn set_rgba(self: ColorChooser, rgba: c.GdkRGBA) void {
        c.gtk_color_chooser_set_rgba(self.ptr, &rgba);
    }

    pub fn get_use_alpha(self: ColorChooser) bool {
        return (c.gtk_color_chooser_get_use_alpha(self.ptr) == 1);
    }

    pub fn set_use_alpha(self: ColorChooser, use: bool) void {
        c.gtk_color_chooser_set_use_alpha(self.ptr, if (use) 1 else 0);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_chooser_get_type() or ColorButton.is_instance(gtype) or ColorChooserWidget.is_instance(gtype) or ColorChooserDialog.is_instance(gtype));
    }

    pub fn to_color_button(self: ColorChooser) ?ColorButton {
        if (self.as_widget().isa(ColorButton)) {
            return ColorButton{
                .ptr = @ptrCast(*c.GtkColorButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_widget(self: ColorChooser) ?ColorChooserWidget {
        if (self.as_widget().isa(ColorChooserWidget)) {
            return ColorChooserWidget{
                .ptr = @ptrCast(*c.GtkColorChooserWidget, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_dialog(self: ColorChooser) ?ColorChooserDialog {
        if (self.as_widget().isa(ColorChooserWidget)) {
            return ColorChooserDialog{
                .ptr = @ptrCast(*c.GtkColorChooserDialog, self.ptr),
            };
        } else return null;
    }

    /// Emitted when a color is activated from the color chooser. This usually
    /// happens when the user clicks a color swatch, or a color is selected and
    /// the user presses one of the keys Space, Shift+Space, Return or Enter.
    pub fn connect_color_activated(self: Button, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("color-activated", callback, if (data) |d| d else null);
    }
};

pub const ColorButton = struct {
    ptr: *c.GtkColorButton,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkColorButton, c.gtk_color_button_new()),
        };
    }

    pub fn new_sith_rgba(rgba: c.GdkRGBA) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkColorButton, c.gtk_color_button_new_with_rgba(rgba)),
        };
    }

    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_color_button_set_title(self.ptr, title);
    }

    pub fn get_title(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_color_button_get_title(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    /// The ::color-set signal is emitted when the user selects a color. When
    /// handling this signal, use gtk_color_button_get_rgba() to find out which
    /// color was just selected.
    ///
    /// Note that this signal is only emitted when the user changes the color.
    /// If you need to react to programmatic color changes as well, use the
    /// notify::color signal.
    pub fn connect_color_set(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("color-set", callback, if (data) |d| d else null);
    }

    pub fn as_actionable(self: Self) Actionable {
        return Actionable{
            .ptr = @ptrCast(*c.GtkActionable, self.ptr),
        };
    }

    pub fn as_button(self: Self) Button {
        return Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        };
    }

    pub fn as_color_chooser(self: Self) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_button_get_type());
    }
};

pub const ColorChooserWidget = struct {
    ptr: *c.GtkColorChooserWidget,

    const Self = @This();

    pub fn as_color_chooser(self: Self) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_chooser_widget_get_type());
    }
};

pub const ColorChooserDialog = struct {
    ptr: *c.GtkColorChooserDialog,

    const Self = @This();

    pub fn as_color_chooser(self: Self) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_chooser_dialog_get_type());
    }
};
