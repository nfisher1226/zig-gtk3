usingnamespace @import("cimport.zig");
usingnamespace @import("adjustment.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("orientable.zig");
usingnamespace @import("widget.zig");

pub const Range = struct {
    ptr: *GtkRange,

    pub fn get_value(self: Range) f64 {
        return gtk_range_get_value(self.ptr);
    }

    pub fn set_value(self: Range, val: f64) void {
        gtk_range_set_value(self.ptr, val);
    }

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
            .ptr = @ptrCast(*GtkScale, gtk_scale_new(orientation.parse(), adjustment.ptr)),
        };
    }

    pub fn new_with_range(orientation: Orientation, min: f64, max: f64, step: f64) Scale {
        return Scale {
            .ptr = @ptrCast(*GtkScale, gtk_scale_new_with_range(orientation.parse(), min, max, step)),
        };
    }

    pub fn get_digits(self: Scale) c_int {
        return gtk_scale_get_digits(self.ptr);
    }

    pub fn set_digits(self: Scale, digits: c_int) void {
        gtk_scale_set_digits(self.ptr, digits);
    }

    pub fn get_draw_value(self: Scale) bool {
        return if (gtk_scale_get_draw_value(self.ptr) == 1) true else false;
    }

    pub fn set_draw_value(self: Scale, draw: bool) void {
        gtk_scale_set_draw_value(self.ptr, bool_to_c_int(draw));
    }

    pub fn get_has_origin(self: Scale) bool {
        return if (gtk_scale_get_has_origin(self.ptr) == 1) true else false;
    }

    pub fn set_has_origin(self: Scale, origin: bool) void {
        gtk_scale_set_has_origin(self.ptr, bool_to_c_int(origin));
    }

    pub fn get_value_pos(self: Scale) PositionType {
        const val = gtk_scale_get_value_pos(self.scale);
        switch (val) {
            GTK_POS_LEFT => return .left,
            GTK_POS_RIGHT => return .right,
            GTK_POS_TOP => return .top,
            GTK_POS_BOTTOM => return .bottom,
            else => unreachable,
        }
    }

    pub fn set_value_pos(self: Scale, pos: PositionType) void {
        gtk_scale_set_value_pos(self.ptr, pos.parse());
    }

    pub fn add_mark(self: Scale, value: f64, pos: PositionType, markup: ?[:0]const u8) void {
        gtk_scale_add_mark(self.ptr, value, pos.parse(), if (markup) |t| t else null);
    }

    pub fn clear_marks(self: Scale) void {
        gtk_scale_clear_marks(self.ptr);
    }

    pub fn as_orientable(self: Scale) Orientable {
        return Orientable {
            .ptr = @ptrCast(*GtkOrientable, self.ptr),
        };
    }

    pub fn as_range(self: Scale) Range {
        return Range {
            .ptr = @ptrCast(*GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: Scale) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_scale_get_type());
    }
};

pub const SpinButton = struct {
    ptr: *GtkSpinButton,

    pub fn new(adjustment: Adjustment, climb_rate: f64, digits: c_uint) SpinButton {
        return SpinButton {
            .ptr = @ptrCast(*GtkSpinButton, gtk_spin_button_new(adjustment.ptr, climb_rate, digits)),
        };
    }

    pub fn as_range(self: SpinButton) Range {
        return Range {
            .ptr = @ptrCast(*GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: SpinButton) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_spin_button_get_type());
    }
};
