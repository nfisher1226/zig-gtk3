const c = @import("cimport.zig");
const com = @import("common.zig");
const Bin = @import("bin.zig").Bin;
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Expander = struct {
    ptr: *c.GtkExpander,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkExpander, c.gtk_expander_new()),
        };
    }

    pub fn new_with_mnemonic(label: Widget) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkExpander, c.gtk_expander_new_with_mnemonic(label.ptr)),
        };
    }

    pub fn set_expanded(self: Self, ex: bool) void {
        c.gtk_expander_set_expanded(self.ptr, if (ex) 1 else 0);
    }

    pub fn get_expanded(self: Self) bool {
        return (c.gtk_expander_get_expanded(self.ptr) == 1);
    }

    pub fn as_bin(self: Self) Bin {
        return Bin{ .ptr = @ptrCast(*c.GtkBin, self.ptr) };
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
        return (gtype == c.gtk_expander_get_type());
    }
};
