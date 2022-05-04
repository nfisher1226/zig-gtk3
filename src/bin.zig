const c = @import("cimport.zig");
const com = @import("common.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");

pub const Bin = struct {
    ptr: *c.GtkBin,

    const Self = @This();

    pub fn get_child(self: Self) ?Widget {
        return if (c.gtk_bin_get_child(self.ptr)) |ch| Widget{
            .ptr = ch,
        } else null;
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_bin_get_type());
    }
};
