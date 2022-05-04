const c = @import("cimport.zig");

pub const Adjustment = struct {
    ptr: *c.GtkAdjustment,

    const Self = @This();

    pub fn new(val: f64, lower: f64, upper: f64, step: f64, page: f64, page_size: f64) Self {
        return Self{
            .ptr = c.gtk_adjustment_new(val, lower, upper, step, page, page_size),
        };
    }

    pub fn get_value(self: Adjustment) f64 {
        return c.gtk_adjustment_get_value(self.ptr);
    }

    pub fn set_value(self: Adjustment, value: f64) void {
        c.gtk_adjustment_set_value(self.ptr, value);
    }

    pub fn clamp_page(self: Adjustment, lower: f64, upper: f64) void {
        c.gtk_adjustment_clamp_page(self.ptr, lower, upper);
    }

    pub fn configure(
        self: Self,
        value: f64,
        lower: f64,
        upper: f64,
        step_inc: f64,
        page_inc: f64,
        page_size: f64,
    ) void {
        c.gtk_adjustment_configure(self.ptr, value, lower, upper, step_inc, page_inc, page_size);
    }

    pub fn get_lower(self: Self) f64 {
        return c.gtk_adjustment_get_lower(self.ptr);
    }

    pub fn get_page_increment(self: Self) f64 {
        return c.gtk_adjustment_get_page_increment(self.ptr);
    }

    pub fn get_page_size(self: Self) f64 {
        return c.gtk_adjustment_get_page_size(self.ptr);
    }

    pub fn get_step_increment(self: Self) f64 {
        return c.gtk_adjustment_get_step_increment(self.ptr);
    }

    pub fn get_minimum_increment(self: Self) f64 {
        return c.gtk_adjustment_get_minimum_increment(self.ptr);
    }

    pub fn get_upper(self: Self) f64 {
        return c.gtk_adjustment_get_upper(self.ptr);
    }

    pub fn set_lower(self: Self, lower: f64) void {
        c.gtk_adjustment_set_lower(self.ptr, lower);
    }

    pub fn set_page_increment(self: Self, inc: f64) void {
        c.gtk_adjustment_set_page_increment(self.ptr, inc);
    }

    pub fn set_page_size(self: Self, size: f64) void {
        c.gtk_adjustment_set_page_size(self.ptr, size);
    }

    pub fn set_step_increment(self: Self, inc: f64) void {
        c.gtk_adjustment_set_step_increment(self.ptr, inc);
    }

    pub fn set_minimum_increment(self: Self, inc: f64) void {
        c.gtk_adjustment_set_minimum_increment(self.ptr, inc);
    }

    pub fn set_upper(self: Self, upper: f64) void {
        c.gtk_adjustment_set_upper(self.ptr, upper);
    }
};
