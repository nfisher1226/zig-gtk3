const c = @import("cimport.zig");
const Buildable = @import("buildable.zig").Buildable;
const Widget = @import("widget.zig").Widget;

const std = @import("std");

pub const Invisible = struct {
    ptr: *c.GtkInvisible,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkInvisible, c.gtk_invisible_new()),
        };
    }

    pub fn new_for_screen(screen: *c.GdkScreen) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkInvisible, c.gtk_invisible_new_for_screen(screen)),
        };
    }

    pub fn set_screen(self: Self, screen: *c.GdkScreen) void {
        c.gtk_invisible_set_screen(self.ptr, screen);
    }

    pub fn get_screen(self: Self) *c.GdkScreen {
        return c.gtk_invisible_get_screen(self.ptr);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @ptrCast(*c.GtkBuildable, self.ptr) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_invisible_get_type());
    }
};
