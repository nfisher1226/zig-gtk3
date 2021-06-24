usingnamespace @import("cimport.zig");
usingnamespace @import("container.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const MenuItem = struct {
    ptr: *GtkMenuItem,

    pub fn new() MenuItem {
        return MenuItem{
            .ptr = @ptrCast(*GtkMenuItem, gtk_menu_tem_new()),
        };
    }

    pub fn new_with_label(text: [:0]const u8) MenuItem {
        return MenuItem{
            .ptr = @ptrCast(*GtkMenuItem, gtk_menu_item_new_with_label(text)),
        };
    }

    pub fn new_with_mnemonic(text: [:0]const u8) MenuItem {
        return MenuItem{
            .ptr = @ptrCast(*GtkMenuItem, gtk_menu_item_new_with_mnemonic(text)),
        };
    }

    pub fn get_label(self: MenuItem, allocator: *mem.Allocator) ?[:0]const u8 {
        if (gtk_menu_item_get_label(self.ptr)) |v| {
            const len = mem.len(v);
            return fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn set_label(self: MenuItem, text: [:0]const u8) void {
        gtk_menu_item_set_label(self.ptr, text);
    }

    pub fn get_use_underline(self: MenuItem) bool {
        return (gtk_menu_item_get_use_underline(self.ptr) == 1);
    }

    pub fn set_use_underline(self: MenuItem, use: bool) void {
        gtk_menu_item_set_use_underline(self.ptr, bool_to_c_int(use));
    }

    pub fn get_submenu(self: MenuItem) ?Widget {
        return if (gtk_menu_item_get_submenu(self.ptr)) |w| Widget{ .ptr = w } else null;
    }

    pub fn set_submenu(self: MenuItem, widget: Widget) void {
        gtk_menu_item_set_submenu(self.ptr, widget.ptr);
    }

    pub fn get_submenu(self: MenuItem) ?Widget {
        return if (gtk_menu_item_get_submenu(self.ptr)) |s| Widget{ .ptr = s } else null;
    }

    pub fn set_accel_path(self: MenuItem, path: ?[:0]const u8) void {
        gtk_menu_item_set_accel_path(self.ptr, if (path) |p| p else null);
    }

    pub fn get_accel_path(self: MenuItem, allocator: *mem.Allocator) ?[:0]const u8 {
        if (gtk_menu_item_get_accel_path(self.ptr)) |v| {
            const len = mem.len(v);
            return fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn get_reserve_indicator(self: MenuItem) bool {
        return (gtk_menu_item_get_reserve_indicator(self.ptr) == 1);
    }

    pub fn as_container(self: MenuItem) Container {
        return Container{
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: MenuItem) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_menu_item_get_type());
    }
};
