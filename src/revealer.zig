const c = @import("cimport.zig");
const common = @import("common.zig");
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Revealer = struct {
    ptr: *c.GtkRevealer,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkRevealer, c.gtk_revealer_new()),
        };
    }

    pub fn get_reveal_child(self: Self) bool {
        return (c.gtk_revealer_get_reveal_child(self.ptr) == 1);
    }

    pub fn set_reveal_child(self: Self, reveal: bool) void {
        c.gtk_revealer_set_reveal_child(self.ptr, if (reveal) 1 else 0);
    }

    pub fn get_child_revealed(self: Self) bool {
        return (c.gtk_revealer_get_child_revealed(self.ptr) == 1);
    }

    pub fn get_transition_duration(self: Self) c_uint {
        return c.gtk_revealer_get_transition_duration(self.ptr);
    }

    pub fn set_transition_duration(self: Self, duration: c_uint) void {
        c.gtk_revealer_set_transition_duration(self.ptr, duration);
    }

    pub fn get_transition_type(self: Self) TransitionType {
        return c.gtk_revealer_get_transition_type(self.ptr);
    }

    pub fn set_transition_type(self: Self, transition: TransitionType) void {
        c.gtk_revealer_set_transition_type(self.ptr, @enumToInt(transition));
    }

    pub fn as_container(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_revealer_get_type());
    }
};

pub const TransitionType = enum(c_uint) {
    none = c.GTK_REVEALER_TRANSITION_TYPE_NONE,
    crossfade = c.GTK_REVEALER_TRANSITION_TYPE_CROSSFADE,
    slide_right = c.GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT,
    slide_left = c.GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT,
    slide_up = c.GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP,
    slide_down = c.GTK_REVEALER_TRANSITION_TYPE_DOWN,
};
