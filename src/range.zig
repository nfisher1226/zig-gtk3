usingnamespace @import("cimport.zig");
usingnamespace @import("adjustment.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

pub const Range = struct {
    .ptr: *GtkRange,

    pub fn as_widget(self: Range) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Scale = struct {
    .ptr: *GtkScale,

    pub fn new(orientation: Orientation, adjustment: Adjustment) Scale {
        return Scale {
            .ptr = @ptrCast(*GtkScale, gtk_scale_new(orientation.parse, adjustment.ptr)),
        };
    }
};

pub const SpinButton = struct {
    .ptr: *GtkSpinButton,
};
