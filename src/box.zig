usingnamespace @import("cimport.zig");
usingnamespace @import("container.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("orientable.zig");
usingnamespace @import("widget.zig");

pub const Box = struct {
    ptr: *GtkBox,

    pub fn new(orientation: Orientation, spacing: u8) Box {
        const gtk_orientation = orientation.parse();
        return Box {
            .ptr = @ptrCast(*GtkBox, gtk_box_new(gtk_orientation, @as(c_int, spacing))),
        };
    }

    pub fn pack_start(self: Box, widget: Widget, expand: bool, fill: bool, padding: u8) void {
        const ex: c_int = if (expand) 1 else 0;
        const fl: c_int = if (fill) 1 else 0;
        gtk_box_pack_start(self.ptr, widget.ptr, ex, fl, @as(c_uint, padding));
    }

    pub fn pack_end(self: Box, widget: *GtkWidget, expand: bool, fill: bool, padding: u8) void {
        const ex: c_int = if (expand) 1 else 0;
        const fl: c_int = if (fill) 1 else 0;
        gtk_box_pack_end(self.ptr, widget, ex, fl, @as(c_uint, padding));
    }

    pub fn as_orientable(self: Box) Orientable {
        return Orientable {
            .ptr = @ptrCast(*GtkOrientable, self.ptr),
        };
    }

    pub fn as_container(self: Box) Container {
        return Container {
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Box) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_box_get_type());
    }
};

