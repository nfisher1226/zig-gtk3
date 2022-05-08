const c = @import("cimport.zig");
const common = @import("common.zig");
const enums = @import("enums.zig");

const Actionable = @import("actionable.zig").Actionable;
const Dialog = @import("dialog.zig").Dialog;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const FontChooser = struct {
    ptr: *c.GtkFontChooser,

    const Self = @This();

    pub fn get_font_family(self: Self) ?*c.PangoFontFamily {
        return if (c.gtk_font_chooser_get_font_family(self.ptr)) |f| f else null;
    }

    pub fn get_font_face(self: Self) ?*c.PangoFontFace {
        return if (c.gtk_font_chooser_get_font_face(self.ptr)) |f| f else null;
    }

    pub fn get_font_size(self: Self) ?c_int {
        const s = c.gtk_font_chooser_get_font_size(self.ptr);
        return if (s == -1) null else s;
    }

    pub fn get_font(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_font_chooser_get_font(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn set_font(self: Self, font: [:0]const u8) void {
        c.gtk_font_chooser_set_font(self.ptr, font);
    }

    pub fn get_font_desc(self: Self) ?*c.PangoFontDescription {
        return if (c.gtk_font_chooser_get_font_desc(self.ptr)) |d| d else null;
    }

    pub fn set_font_desc(self: Self, desc: *c.PangoFontDescription) void {
        c.gtk_font_chooser_set_font_desc(self.ptr, desc);
    }

    pub fn get_preview_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_font_chooser_get_preview_text(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn set_preview_text(self: Self, text: [:0]const u8) void {
        c.gtk_font_chooser_set_preview_text(self.ptr, text);
    }

    pub fn get_show_preview_entry(self: Self) bool {
        return (c.gtk_font_chooser_get_show_preview_entry(self.ptr) == 1);
    }

    pub fn set_show_preview_entry(self: Self, show: bool) void {
        c.gtk_font_chooser_set_show_preview_entry(self.ptr, if (show) 1 else 0);
    }

    pub fn set_font_map(self: Self, map: *c.PangoFontMap) void {
        c.gtk_font_chooser_set_font_map(self.ptr, map);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn to_font_button(self: Self) ?FontButton {
        return if (self.as_widget().isa(FontButton)) FontButton{
            .ptr = @ptrCast(*c.GtkFontButton, self.ptr),
        } else null;
    }

    pub fn to_font_chooser_widget(self: Self) ?FontChooserWidget {
        return if (self.as_widget().isa(FontChooserWidget)) FontChooserWidget{
            .ptr = @ptrCast(*c.GtkFontChooserWidget, self.ptr),
        } else null;
    }

    pub fn to_font_chooser_dialog(self: Self) ?FontChooserDialog {
        return if (self.as_widget().isa(FontChooserDialog)) FontChooserDialog{
            .ptr = @ptrCast(*c.GtkFontChooserDialog, self.ptr),
        } else null;
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_font_chooser_get_type() or FontButton.is_instance(gtype) or FontChooserWidget.is_instance(gtype) or FontChooserDialog.is_instance(gtype));
    }
};

pub const FontButton = struct {
    ptr: *c.GtkFontButton,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkFontButton, c.gtk_font_button_new()),
        };
    }

    pub fn new_with_font(name: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkGontButton, c.gtk_font_button_new_with_font(name)),
        };
    }

    pub fn set_show_style(self: Self, show: bool) void {
        c.gtk_font_button_set_show_style(self.ptr, if (show) 1 else 0);
    }

    pub fn get_show_style(self: Self) bool {
        return (c.gtk_font_button_get_show_style(self.ptr) == 1);
    }

    pub fn set_show_size(self: Self, show: bool) void {
        c.gtk_font_button_set_show_size(self.ptr, if (show) 1 else 0);
    }

    pub fn get_show_size(self: Self) bool {
        return (c.gtk_font_button_get_show_size(self.ptr) == 1);
    }

    pub fn set_use_font(self: Self, use: bool) void {
        c.gtk_font_button_set_use_font(self.ptr, if (use) 1 else 0);
    }

    pub fn get_use_font(self: Self) bool {
        return (c.gtk_font_button_get_use_font(self.ptr) == 1);
    }

    pub fn set_use_size(self: Self, use: bool) void {
        c.gtk_font_button_set_use_size(self.ptr, if (use) 1 else 0);
    }

    pub fn get_use_size(self: Self) bool {
        return (c.gtk_font_button_get_use_size(self.ptr) == 1);
    }

    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_font_button_set_title(self.ptr, title);
    }

    pub fn get_title(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_font_button_get_title(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn as_actionable(self: Self) Actionable {
        return Actionable{
            .ptr = @ptrCast(*c.GtkActionable, self.ptr),
        };
    }

    pub fn as_font_chooser(self: Self) FontChooser {
        return FontChooser{
            .ptr = @ptrCast(*c.GtkFontChooser, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_font_button_get_type());
    }
};

pub const FontChooserWidget = struct {
    ptr: *c.GtkFontChooserWidget,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkFontChooserWidget, c.gtk_font_chooser_widget_new()),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn as_font_chooser(self: Self) Widget {
        return FontChooser{
            .ptr = @ptrCast(*c.GtkFontChooser, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_font_chooser_widget_get_type());
    }
};

pub const FontChooserDialog = struct {
    ptr: *c.GtkFontChooserDialog,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkFontChooserDialog, c.gtk_font_chooser_dialog_new()),
        };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        };
    }

    pub fn as_font_chooser(self: Self) Widget {
        return FontChooser{
            .ptr = @ptrCast(*c.GtkFontChooser, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_font_chooser_dialog_get_type());
    }
};
