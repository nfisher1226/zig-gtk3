const c = @import("cimport.zig");
const Builder = @import("builder.zig").Builder;
const Widget = @import("widget.zig").Widget;
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Buildable = struct {
    ptr: *c.GtkBuildable,

    const Self = @This();

    pub fn set_name(self: Self, name: [:0]const u8) void {
        c.gtk_buildable_set_name(self.ptr, name);
    }

    pub fn get_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_buildable_get_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn add_child(self: Self, builder: Builder, child: *c.GObject, kind: ?[:0]const u8) void {
        c.gtk_buildable_add_child(
            self.ptr,
            builder.ptr,
            child,
            if (kind) |k| k else null,
        );
    }

    pub fn set_buildable_property(self: Self, builder: Builder, name: [:0]const u8, value: c.GValue) void {
        c.gtk_buildable_set_buildable_property(
            self.ptr,
            builder.ptr,
            name,
            value,
        );
    }

    pub fn construct_child(self: Self, builder: Builder, name: [:0]const u8) *c.GObject {
        return c.gtk_buildable_construct_child(self.ptr, builder.ptr, name);
    }

    pub fn get_internal_child(self: Self, builder: Builder, name: [:0]const u8) *c.GObject {
        return c.gtk_buildable_get_internal_child(self.ptr, builder.ptr, name);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_message_dialog_get_type());
    }
};
