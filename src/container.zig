const c = @import("cimport.zig");
const Box = @import("box.zig").Box;
const Grid = @import("grid.zig").Grid;
const Notebook = @import("notebook.zig").Notebook;
const Stack = @import("stack.zig").Stack;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = mem.fmt;
const mem = std.mem;

pub const Container = struct {
    ptr: *c.GtkContainer,

    const Self = @This();

    pub fn add(self: Self, widget: Widget) void {
        c.gtk_container_add(self.ptr, widget.ptr);
    }

    pub fn remove(self: Self, widget: Widget) void {
        c.gtk_container_remove(self.ptr, widget.ptr);
    }

    pub fn check_resize(self: Self) void {
        c.gtk_container_check_resize(self.ptr);
    }

    pub fn foreach(self: Self, callback: *c.GtkCallback, data: c.gpointer) void {
        c.gtk_container_foreach(self.ptr, callback, data);
    }

    pub fn get_children(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        var kids = c.gtk_container_get_children(self.ptr);
        defer c.g_list_free(kids);
        var list = std.ArrayList(Widget).init(allocator);
        while (kids) |ptr| {
            list.append(Widget{ .ptr = @ptrCast(*c.GtkWidget, @alignCast(8, ptr.*.data)) }) catch {
                list.deinit();
                return null;
            };
            kids = ptr.*.next;
        }
        return list;
    }

    pub fn get_focus_child(self: Self) Widget {
        return Widget{ .ptr = c.gtk_container_get_focus_child(self.ptr) };
    }

    pub fn set_focus_child(self: Self, child: Widget) void {
        c.gtk_widget_set_focus_child(self.ptr, child.ptr);
    }

    pub fn get_border_width(self: Self) c_uint {
        c.gtk_container_get_border_width(self.ptr);
    }

    pub fn set_border_width(self: Self, border: c_uint) void {
        c.gtk_container_set_border_width(self.ptr, border);
    }

    pub fn connect_add(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("add", callback, if (data) |d| d else null);
    }

    pub fn connect_check_resize(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("check-resize", callback, if (data) |d| d else null);
    }

    pub fn connect_remove(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("remove", callback, if (data) |d| d else null);
    }

    pub fn connect_set_focus_child(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("set-focus-child", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_container_get_type() or Box.is_instance(gtype) or Grid.is_instance(gtype) or Notebook.is_instance(gtype) or Stack.is_instance(gtype));
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }
};
