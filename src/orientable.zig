usingnamespace @import("cimport.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

pub const Orientable = struct {
    ptr: *GtkOrientable,

    pub fn as_widget(self: Box) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};
