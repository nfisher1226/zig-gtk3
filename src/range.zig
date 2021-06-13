usingnamespace @import("cimport.zig");
usingnamespace @import("adjustment.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

pub const Range = struct {
    ptr: *GtkRange,

    pub fn as_widget(self: Range) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

pub const Scale = struct {
    ptr: *GtkScale,

    pub fn new(orientation: Orientation, adjustment: Adjustment) Scale {
        return Scale {
            .ptr = @ptrCast(*GtkScale, gtk_scale_new(orientation.parse, adjustment.ptr)),
        };
    }

    pub fn new_with_range(orientation: Orientation, min: f64, max: f64, step: f64) Scale {
        return Scale {
            .ptr = @ptrCast(*GtkScale, gtk_scale_new_with_range(orientation.parse, min, max, step)),
        };
    }

    pub fn get_digits(self: Scale) i64 {
        return @as(i64, gtk_scale_get_digits(self.ptr));
    }

    pub fn set_digits(self: Scale, digits: i64) void {
        gtk_scale_set_digits(self.ptr, @as(c_int, digits));
    }

    pub fn get_draw_value(self: Scale) bool {
        const ret = if (gtk_scale_get_draw_value(self.ptr) == 1) true else false;
        return ret;
    }

    pub fn set_draw_value(self: Scale, draw: bool) void {
        gtk_scale_set_draw_value(self.ptr, bool_to_c_int(draw));
    }

    pub fn get_has_origin(self: Scale) bool {
        const ret = if (gtk_scale_get_has_origin(self.ptr) == 1) true else false;
        return ret;
    }

    pub fn set_has_origin(self: Scale, origin: bool) void {
        gtk_scale_set_has_origin(self.ptr, bool_to_c_int(origin));
    }

    pub fn get_value_position(self: Scale) PositionType {
        const val = gtk_scale_get_position_type(self.scale);
        switch (val) {
            pos_left => return PositionType.pos_left,
            pos_right => return PositionType.pos_right,
            pos_top => return PositionType.pos_top,
            pos_bottom => return PositionType.pos_bottom,
            else => unreachable,
        }
    }

    pub fn set_value_position(self: Scale, pos: PositionType) void {
        gtk_scale_set_value_position(self.ptr, pos.parse());
    }
};

pub const SpinButton = struct {
    ptr: *GtkSpinButton,
};
