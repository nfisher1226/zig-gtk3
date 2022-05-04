const c = @import("cimport.zig");
const Bin = @import("bin.zig").Bin;
const Container = @import("container.zig").Container;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

pub const Paned = struct {
    ptr: *c.GtkPaned,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkPaned, c.gtk_paned_new()),
        };
    }

    pub fn add1(self: Self, child: Widget) void {
        c.gtk_paned_add1(self.ptr, child.ptr);
    }

    pub fn add2(self: Self, child: Widget) void {
        c.gtk_paned_add2(self.ptr, child.ptr);
    }

    pub fn pack1(self: Self, child: Widget, resize: bool, shrink: bool) void {
        c.gtk_paned_pack1(
            self.ptr,
            child.ptr,
            if (resize) 1 else 0,
            if (shrink) 1 else 0,
        );
    }

    pub fn pack2(self: Self, child: Widget, resize: bool, shrink: bool) void {
        c.gtk_paned_pack2(
            self.ptr,
            child.ptr,
            if (resize) 1 else 0,
            if (shrink) 1 else 0,
        );
    }

    pub fn get_child1(self: Self) ?Widget {
        return if (c.gtk_paned_get_child1(self.ptr)) |child| Widget{
            .ptr = child,
        } else null;
    }

    pub fn get_child2(self: Self) ?Widget {
        return if (c.gtk_paned_get_child2(self.ptr)) |child| Widget{
            .ptr = child,
        } else null;
    }

    pub fn set_position(self: Self, pos: c_int) void {
        c.gtk_paned_set_position(self.ptr, pos);
    }

    pub fn get_position(self: Self) c_int {
        return c.gtk_paned_get_position(self.ptr);
    }

    pub fn get_handle_window(self: Self) Window {
        return Window{
            .ptr = c.gtk_paned_get_handle_window(self.ptr),
        };
    }

    pub fn set_wide_handle(self: Self, wide: bool) void {
        c.gtk_paned_set_wide_handle(self.ptr, if (wide) 1 else 0);
    }

    pub fn get_wide_handle(self: Self) bool {
        return (c.gtk_paned_get_wide_handle(self.ptr) == 1);
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
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
        return (gtype == c.gtk_paned_get_type());
    }
};
