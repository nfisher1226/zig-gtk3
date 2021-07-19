usingnamespace @import("cimport.zig");
usingnamespace @import("widget.zig");

const std = @import("std");
const fmt = mem.fmt;
const mem = std.mem;

pub const Container = struct {
    ptr: *GtkContainer,

    pub fn add(self: Container, widget: Widget) void {
        gtk_container_add(self.ptr, widget.ptr);
    }

    pub fn remove(self: Container, widget: Widget) void {
        gtk_container_remove(self.ptr, widget.ptr);
    }

    pub fn get_focus_child(self: Container) Widget {
        return Widget{ .ptr = gtk_container_get_focus_child(self.ptr) };
    }

    pub fn set_focus_child(self: Container, child: Widget) void {
        gtk_widget_set_focus_child(self.ptr, child.ptr);
    }

    pub fn get_border_width(self: Container) c_uint {
        gtk_container_get_border_width(self.ptr);
    }

    pub fn set_border_width(self: Container, border: c_uint) void {
        gtk_container_set_border_width(self.ptr, border);
    }

    pub fn get_children(self: Container, allocator: *mem.Allocator) ?std.ArrayList(Widget) {
        var kids = gtk_container_get_children(self.ptr);
        defer g_list_free(kids);
        var list = std.ArrayList(Widget).init(allocator);
        while (kids) |ptr| {
            list.append(Widget{ .ptr = @ptrCast(*GtkWidget, @alignCast(8, ptr.*.data)) }) catch {
                list.deinit();
                return null;
            };
            kids = ptr.*.next;
        }
        return list;
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_container_get_type());
    }

    pub fn as_widget(self: Box) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};
