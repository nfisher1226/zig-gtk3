const c = @import("cimport.zig");
const common = @import("common.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Label = struct {
    ptr: *c.GtkLabel,

    const Self = @This();

    pub fn new(text: ?[:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkLabel, c.gtk_label_new(if (text) |t| t else null)),
        };
    }

    pub fn get_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_label_get_text(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn set_text(self: Self, text: [:0]const u8) void {
        c.gtk_label_set_text(self.ptr, text);
    }

    pub fn set_markup(self: Self, text: [:0]const u8) void {
        c.gtk_label_set_markup(self.ptr, text);
    }

    pub fn set_line_wrap(self: Self, wrap: bool) void {
        c.gtk_label_set_line_wrap(self.ptr, if (wrap) 1 else 0);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_label_get_type());
    }
};
