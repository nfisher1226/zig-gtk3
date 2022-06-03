const c = @import("cimport.zig");
const common = @import("common.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const ComboBox = struct {
    ptr: *c.GtkComboBox,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkComboBox, c.gtk_combo_box_new()),
        };
    }

    pub fn new_with_entry() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkComboBox, c.gtk_combo_box_new_with_entry()),
        };
    }

    pub fn get_active(self: Self) ?c_int {
        const res = c.gtk_combo_box_get_active(self.ptr);
        return switch (res) {
            -1 => null,
            else => res,
        };
    }

    pub fn set_active(self: Self, item: ?c_int) void {
        c.gtk_commbo_box_set_active(self.ptr, if (item) |i| i else -1);
    }

    pub fn get_active_id(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_combo_box_get_active_id(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn set_active_id(self: Self, id: ?[:0]const u8) void {
        _ = c.gtk_combo_box_set_active_id(self.ptr, if (id) |i| i else null);
    }

    pub fn connect_changed(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("changed", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_combo_box_text(self: Self) ?ComboBoxText {
        if (self.isa(ComboBoxText)) {
            return ComboBoxText{
                .ptr = @ptrCast(*c.GtkComboBoxText, self.ptr),
            };
        } else return null;
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_combo_box_get_type() or ComboBoxText.is_instance(gtype));
    }
};

pub const ComboBoxText = struct {
    ptr: *c.GtkComboBoxText,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = c.gtk_combo_box_text_new(),
        };
    }

    pub fn new_with_entry() Self {
        return Self{
            .ptr = c.gtk_combo_box_text_new_with_entry(),
        };
    }

    pub fn append(self: Self, id: ?[:0]const u8, text: [:0]const u8) void {
        c.gtk_combo_box_text_append(self.ptr, if (id) |i| i else null, text);
    }

    pub fn prepend(self: Self, id: ?[:0]const u8, text: [:0]const u8) void {
        c.gtk_combo_box_text_prepend(self.ptr, if (id) |i| i else null, text);
    }

    pub fn insert(self: Self, position: c_int, id: ?[:0]const u8, text: [:0]const u8) void {
        c.gtk_combo_box_text_append(self.ptr, position, if (id) |i| i else null, text);
    }

    pub fn append_text(self: Self, text: [:0]const u8) void {
        c.gtk_combo_box_append_text(self.ptr, text);
    }

    pub fn prepend_text(self: Self, text: [:0]const u8) void {
        c.gtk_combo_box_prepend_text(self.ptr, text);
    }

    pub fn insert_text(self: Self, position: c_int, text: [:0]const u8) void {
        c.gtk_combo_box_prepend_text(self.ptr, position, text);
    }

    pub fn remove(self: Self, position: c_int) void {
        c.gtk_combo_box_text_remove(self.ptr, position);
    }

    pub fn remove_all(self: Self) void {
        c.gtk_combo_box_remove_all(self.ptr);
    }

    pub fn get_active_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_combo_box_text_get_active_text(self.ptr);
        defer c.g_free(@ptrCast(*c.gpointer, val));
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn as_combo_box(self: Self) ComboBox {
        return ComboBox{
            .ptr = @ptrCast(*c.GtkComboBox, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_combo_box_text_get_type());
    }
};
