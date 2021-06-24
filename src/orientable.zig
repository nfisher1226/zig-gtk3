usingnamespace @import("cimport.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

pub const Orientable = struct {
    ptr: *GtkOrientable,

    pub fn as_widget(self: Orientable) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn get_orientation(self: Orientable) Orientation {
        const orientation = gtk_orientable_get_orientation(self.ptr);
        switch (orientation) {
            GTK_ORIENTATION_HORIZONTAL => return .horizontal,
            GTK_ORIENTATION_VERTICAL => return .vertical,
            else => unreachable,
        }
    }

    pub fn set_orientation(self: Orientable, orientation: Orientation) void {
        gtk_orientable_set_orientation(self.ptr, orientation.parse());
    }
};
