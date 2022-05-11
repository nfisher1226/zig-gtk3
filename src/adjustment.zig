const c = @import("cimport.zig");
const signal_connect = @import("common.zig").signal_connect;

/// The GtkAdjustment object represents a value which has an associated lower
/// and upper bound, together with step and page increments, and a page size.
/// It is used within several GTK+ widgets, including GtkSpinButton,
/// GtkViewport, and GtkRange (which is a base class for GtkScrollbar and
/// GtkScale).
///
/// The GtkAdjustment object does not update the value itself. Instead it is
/// left up to the owner of the GtkAdjustment to control the value.
pub const Adjustment = struct {
    ptr: *c.GtkAdjustment,

    const Self = @This();

    /// Create a new Adjustment
    pub fn new(val: f64, lower: f64, upper: f64, step: f64, page: f64, page_size: f64) Self {
        return Self{
            .ptr = c.gtk_adjustment_new(val, lower, upper, step, page, page_size),
        };
    }

    /// Gets the current value of the adjustment. See set_value().
    pub fn get_value(self: Adjustment) f64 {
        return c.gtk_adjustment_get_value(self.ptr);
    }

    /// Sets the GtkAdjustment value. The value is clamped to lie between
    /// “lower” and “upper”.
    ///
    /// Note that for adjustments which are used in a GtkScrollbar, the
    /// effective range of allowed values goes from “lower” to “upper” -
    /// “page-size”.
    pub fn set_value(self: Adjustment, value: f64) void {
        c.gtk_adjustment_set_value(self.ptr, value);
    }

    /// Updates the “value” property to ensure that the range between lower and
    /// upper is in the current page (i.e. between “value” and “value” +
    /// “page-size”). If the range is larger than the page size, then only the
    /// start of it will be in the current page.
    pub fn clamp_page(self: Adjustment, lower: f64, upper: f64) void {
        c.gtk_adjustment_clamp_page(self.ptr, lower, upper);
    }

    /// Sets all properties of the adjustment at once.
    ///
    /// Use this function to avoid multiple emissions of the “changed” signal.
    /// See gtk_adjustment_set_lower() for an alternative way of compressing
    /// multiple emissions of “changed” into one.
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

    /// Retrieves the minimum value of the adjustment.
    pub fn get_lower(self: Self) f64 {
        return c.gtk_adjustment_get_lower(self.ptr);
    }

    /// Retrieves the page increment of the adjustment.
    pub fn get_page_increment(self: Self) f64 {
        return c.gtk_adjustment_get_page_increment(self.ptr);
    }

    /// Retrieves the page size of the adjustment.
    pub fn get_page_size(self: Self) f64 {
        return c.gtk_adjustment_get_page_size(self.ptr);
    }

    /// Retrieves the step increment of the adjustment.
    pub fn get_step_increment(self: Self) f64 {
        return c.gtk_adjustment_get_step_increment(self.ptr);
    }

    /// Gets the smaller of step increment and page increment.
    pub fn get_minimum_increment(self: Self) f64 {
        return c.gtk_adjustment_get_minimum_increment(self.ptr);
    }

    /// Retrieves the maximum value of the adjustment.
    pub fn get_upper(self: Self) f64 {
        return c.gtk_adjustment_get_upper(self.ptr);
    }

    /// Sets the minimum value of the adjustment.
    ///
    /// When setting multiple adjustment properties via their individual
    /// setters, multiple “changed” signals will be emitted. However, since the
    /// emission of the “changed” signal is tied to the emission of the “notify”
    /// signals of the changed properties, it’s possible to compress the
    /// “changed” signals into one by calling g_object_freeze_notify() and
    /// g_object_thaw_notify() around the calls to the individual setters.
    ///
    /// Alternatively, using a single g_object_set() for all the properties to
    /// change, or using gtk_adjustment_configure() has the same effect of
    /// compressing “changed” emissions.
    pub fn set_lower(self: Self, lower: f64) void {
        c.gtk_adjustment_set_lower(self.ptr, lower);
    }

    /// Sets the page increment of the adjustment.
    ///
    /// See gtk_adjustment_set_lower() about how to compress multiple emissions
    /// of the “changed” signal when setting multiple adjustment properties.
    pub fn set_page_increment(self: Self, inc: f64) void {
        c.gtk_adjustment_set_page_increment(self.ptr, inc);
    }

    /// Sets the page size of the adjustment.
    ///
    /// See gtk_adjustment_set_lower() about how to compress multiple emissions
    /// of the GtkAdjustment::changed signal when setting multiple adjustment
    /// properties.
    pub fn set_page_size(self: Self, size: f64) void {
        c.gtk_adjustment_set_page_size(self.ptr, size);
    }

    /// Sets the step increment of the adjustment.
    ///
    /// See gtk_adjustment_set_lower() about how to compress multiple emissions
    /// of the “changed” signal when setting multiple adjustment properties.
    pub fn set_step_increment(self: Self, inc: f64) void {
        c.gtk_adjustment_set_step_increment(self.ptr, inc);
    }

    /// Sets the maximum value of the adjustment.
    ///
    /// See gtk_adjustment_set_lower() about how to compress multiple emissions
    /// of the “changed” signal when setting multiple adjustment properties.
    pub fn set_upper(self: Self, upper: f64) void {
        c.gtk_adjustment_set_upper(self.ptr, upper);
    }

    /// Emitted when one or more of the Adjustment properties have been changed,
    /// other than the “value” property.
    pub fn connect_changed(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        _ = signal_connect(self.ptr, "changed", callback, if (data) |d| d else null);
    }

    /// Emitted when the “value” property has been changed.
    pub fn connect_value_changed(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        _ = signal_connect(self.ptr, "value-changed", callback, if (data) |d| d else null);
    }
};
