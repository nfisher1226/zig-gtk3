usingnamespace @import("cimport.zig");
usingnamespace @import("container.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("orientable.zig");
usingnamespace @import("widget.zig");

pub const Box = struct {
    ptr: *GtkBox,

    pub fn new(orientation: Orientation, spacing: u8) Box {
        const gtk_orientation = orientation.parse();
        return Box{
            .ptr = @ptrCast(*GtkBox, gtk_box_new(gtk_orientation, @as(c_int, spacing))),
        };
    }

    pub fn pack_start(self: Box, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        gtk_box_pack_start(self.ptr, widget.ptr, bool_to_c_int(expand), bool_to_c_int(fill), padding);
    }

    pub fn pack_end(self: Box, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        gtk_box_pack_end(self.ptr, widget.ptr, bool_to_c_int(expand), bool_to_c_int(fill), padding);
    }

    pub fn as_orientable(self: Box) Orientable {
        return Orientable{
            .ptr = @ptrCast(*GtkOrientable, self.ptr),
        };
    }

    pub fn as_container(self: Box) Container {
        return Container{
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Box) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_box_get_type());
    }
};
