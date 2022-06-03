const c = @import("cimport.zig");
const com = @import("common.zig");
const Bin = @import("bin.zig").Bin;
const Box = @import("box.zig").Box;
const Container = @import("container.zig").Container;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Stack = struct {
    ptr: *c.GtkStack,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkStack, c.gtk_stack_new()),
        };
    }

    pub fn add_named(self: Self, child: Widget, name: [:0]const u8) void {
        c.gtk_stack_add_named(self.ptr, child.ptr, name);
    }

    pub fn add_titled(self: Self, child: Widget, name: [:0]const u8, title: [:0]const u8) void {
        c.gtk_stack_add_titled(self.ptr, child.ptr, name, title);
    }

    pub fn get_child_by_name(self: Self, name: [:0]const u8) ?Widget {
        return if (c.gtk_stack_get_child_by_name(self.ptr, name)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn set_visible_child(self: Self, child: Widget) void {
        c.gtk_stack_set_visible_child(self.ptr, child.ptr);
    }

    pub fn get_visible_child(self: Self) ?Widget {
        return if (c.gtk_stack_get_visible_child(self.ptr)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn set_visible_child_name(self: Self, child: [:0]const u8) void {
        c.gtk_stack_set_visible_child_name(self.ptr, child);
    }

    pub fn get_visible_child_name(self: Self) ?[:0]const u8 {
        return if (c.gtk_stack_get_visible_child_name(self.ptr)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn set_visible_child_full(self: Self, name: [:0]const u8, transition: StackTransitionStyle) void {
        c.gtk_stack_set_visible_child_full(self.ptr, name, @enumToInt(transition));
    }

    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_stack_get_homeogeneous(self.ptr) == 1);
    }

    pub fn set_hhomogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_hhomogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_hhomogeneous(self: Self) bool {
        return (c.gtk_stack_get_hhomeogeneous(self.ptr) == 1);
    }

    pub fn set_vhomogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_vhomogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_vhomogeneous(self: Self) bool {
        return (c.gtk_stack_get_vhomeogeneous(self.ptr) == 1);
    }

    pub fn set_transition_duration(self: Self, duration: c_uint) void {
        c.gtk_stack_set_transition_duration(self.ptr, duration);
    }

    pub fn get_transition_duration(self: Self) c_uint {
        return c.gtk_stack_get_transition_duration(self.ptr);
    }

    pub fn set_transition_type(self: Self, transition: StackTransitionStyle) void {
        c.gtk_stack_set_transition_type(self.ptr, @enumToInt(transition));
    }

    pub fn get_transition_type(self: Self) StackTransitionStyle {
        return @intToEnum(StackTransitionStyle, c.gtk_stack_get_transition_type(self.ptr));
    }

    pub fn get_transition_running(self: Self) bool {
        return (c.gtk_stack_get_transition_running(self.ptr) == 1);
    }

    pub fn get_interpolate_size(self: Self) bool {
        return (c.gtk_stack_get_interpolate_size(self.ptr) == 1);
    }

    pub fn set_interpolate_size(self: Self, interpolate_size: bool) void {
        c.gtk_stack_set_interpolate_size(self.ptr, if (interpolate_size) 1 else 0);
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
        return (gtype == c.gtk_stack_get_type());
    }
};

pub const StackSwitcher = struct {
    ptr: *c.GtkStackSwitcher,

    const Self = @This();

    pub fn new() Self {
        return Self{ .ptr = @ptrCast(*c.GtkStackSwitcher, c.gtk_stack_switcher_new()) };
    }

    pub fn set_stack(self: Self, stack: Stack) void {
        c.gtk_stack_switcher_set_stack(self.ptr, stack.ptr);
    }

    pub fn get_stack(self: Self) Stack {
        return Stack{ .ptr = c.gtk_stack_switcher_get_stack(self.ptr) };
    }

    pub fn as_box(self: Self) Box {
        return Box{
            .ptr = @ptrCast(*c.GtkBox, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_stack_switcher_get_type());
    }
};

pub const StackSidebar = struct {
    ptr: *c.GtkStackSidebar,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkStackSidebar, c.gtk_stack_sidebar_new()),
        };
    }

    pub fn set_stack(self: Self, stack: Stack) void {
        c.gtk_stack_sidebar_set_stack(self.ptr, stack.ptr);
    }

    pub fn get_stack(self: Self) Stack {
        return Stack{ .ptr = c.gtk_stack_sidebar_get_stack(self.ptr) };
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
        return (gtype == c.gtk_stack_sidebar_get_type());
    }
};

/// enum StackTransitionStyle
pub const StackTransitionStyle = enum(c_uint) {
    none = c.GTK_STACK_TRANSITION_TYPE_NONE,
    crossfade = c.GTK_STACK_TRANSITION_TYPE_CROSSFADE,
    slide_right = c.GTK_STACK_TRANSITION_TYPE_RIGHT,
    slide_left = c.GTK_STACK_TRANSITION_TYPE_LEFT,
    slide_up = c.GTK_STACK_TRANSITION_TYPE_UP,
    slide_down = c.GTK_STACK_TRANSITION_TYPE_DOWN,
    slide_left_right = c.GTK_STACK_TRANSITION_TYPE_LEFT_RIGHT,
    slide_up_down = c.GTK_STACK_TRANSITION_TYPE_UP_DOWN,
    over_up = c.GTK_STACK_TRANSITION_TYPE_OVER_UP,
    over_down = c.GTK_STACK_TRANSITION_TYPE_OVER_DOWN,
    over_left = c.GTK_STACK_TRANSITION_TYPE_OVER_LEFT,
    over_right = c.GTK_STACK_TRANSITION_TYPE_OVER_RIGHT,
    under_up = c.GTK_STACK_TRANSITION_TYPE_UNDER_UP,
    under_down = c.GTK_STACK_TRANSITION_TYPE_UNDER_DOWN,
    under_left = c.GTK_STACK_TRANSITION_TYPE_UNDER_LEFT,
    under_right = c.GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT,
    over_up_down = c.GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN,
    over_down_up = c.GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP,
    over_left_right = c.GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT,
    over_right_left = c.GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT,
};
