usingnamespace @import("cimport.zig");

pub const Adjustment = struct {
    ptr: *GtkAdjustment,

    pub fn new(val: f64, lower: f64, upper: f64, step: f64, page: f64, page_size: f64) Adjustment {
        return Adjustment {
            .ptr = gtk_adjustment_new(val, lower, upper, step, page, page_size),
        };
    }

    pub fn get_value(self: Adjustment) f64 {
        return gtk_adjustment_get_value(self.ptr);
    }

    pub fn set_value(self: Adjustment, value: f64) void {
        gtk_adjustment_set_value(self.ptr, value);
    }
};
