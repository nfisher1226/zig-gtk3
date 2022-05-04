const c = @import("cimport.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");

pub const Spinner = struct {
    ptr: *c.GtkSpinner,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkSpinner, c.gtk_spinner_new()),
        };
    }

    pub fn start(self: Self) void {
        c.gtk_spinner_start(self.ptr);
    }

    pub fn stop(self: Self) void {
        c.gtk_spinner_stop(self.ptr);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_spinner_get_type());
    }
};
