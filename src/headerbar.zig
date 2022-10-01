const c = @import("cimport.zig");
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const HeaderBar = struct {
    ptr: c.GtkHeaderBar,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkHeaderBar, c.gtk_header_bar_new()),
        };
    }

    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_header_bar_set_title(self.ptr, title.ptr);
    }

    pub fn get_title(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_header_bar_get_title(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_subtitle(self: Self, sub: [:0]const u8) void {
        c.gtk_header_bar_set_subtitle(self.ptr, sub.ptr);
    }

    pub fn get_subtitle(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_header_bar_get_subtitle(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn set_has_subtitle(self: Self, set: bool) void {
        c.gtk_header_bar_set_has_subtitle(self.ptr, if (set) 1 else 0);
    }

    pub fn get_has_subtitle(self: Self) bool {
        return (c.gtk_header_bar_get_has_subtitle(self.ptr) == 1);
    }

    pub fn set_custom_title(self: Self, title: ?Widget) void {
        c.gtk_header_bar_set_custom_title(self.ptr, if (title) |t| t.ptr else null);
    }

    pub fn get_custom_title(self: Self) ?Widget {
        return if (c.gtk_header_bar_get_custom_title(self.ptr)) |t| Widget{
            .ptr = t,
        } else null;
    }

    pub fn pack_start(self: Self, child: Widget) void {
        c.gtk_header_bar_pack_start(self.ptr, child.ptr);
    }

    pub fn pack_end(self: Self, child: Widget) void {
        c.gtk_header_bar_pack_end(self.ptr, child.ptr);
    }

    pub fn set_show_close_button(self: Self, show: bool) void {
        c.gtk_header_bar_set_show_close_button(self.ptr, if (show) 1 else 0);
    }

    pub fn get_show_close_button(self: Self) bool {
        return (c.gtk_header_bar_get_show_close_button(self.ptr) == 1);
    }

    pub fn set_decoration_layout(self: Self, layout: [:0]const u8) void {
        c.gtk_header_bar_set_decoration_layout(self.ptr, layout.ptr);
    }

    pub fn get_decoration_layout(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_header_bar_get_decoration_layout(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_header_bar_get_type());
    }
};
