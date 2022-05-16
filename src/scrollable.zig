const c = @import("cimport.zig");
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

pub const Scrollable = struct {
    ptr: *c.GtkScrollable,

    const Self = @This();

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
        return (gtype == c.gtk_fixed_get_type());
    }
};
