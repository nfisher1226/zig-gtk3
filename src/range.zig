const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig").Adjustment;
const enums = @import("enums.zig");
const Orientation = enums.Orientation;
const PositionType = enums.PositionType;
const SensitivityType = enums.SensitivityType;
const SpinType = enums.SpinType;
const SpinButtonUpdatePolicy = enums.SpinButtonUpdatePolicy;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

pub const Range = struct {
    ptr: *c.GtkRange,

    const Self = @This();

    pub fn get_fill_level(self: Self) f64 {
        return c.gtk_range_get_fill_level(self.ptr);
    }

    pub fn get_restrict_to_fill_level(self: Self) bool {
        return (c.gtk_range_get_restrict_to_fill_level(self.ptr) == 1);
    }

    pub fn get_show_fill_level(self: Self) bool {
        return (c.gtk_range_get_show_fill_level(self.ptr) == 1);
    }

    pub fn set_fill_level(self: Self, level: f64) void {
        c.gtk_range_set_fill_level(self.ptr, level);
    }

    pub fn set_restrict_to_fill_level(self: Self, restrict: bool) void {
        c.gtk_range_set_restrict_to_fill_level(self.ptr, if (restrict) 1 else 0);
    }

    pub fn set_show_fill_level(self: Self, show: bool) void {
        c.gtk_range_set_show_fill_level(self.ptr, if (show) 1 else 0);
    }

    pub fn get_adjustment(self: Self) Adjustment {
        return Adjustment{
            .ptr = @ptrCast(*c.GtkAdjustment, c.gtk_range_get_adjustment(self.ptr)),
        };
    }

    pub fn set_adjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_range_set_adjustment(self.ptr, adjustment.ptr);
    }

    pub fn get_inverted(self: Self) bool {
        return (c.gtk_range_get_inverted(self.ptr) == 1);
    }

    pub fn set_inverted(self: Self, inverted: bool) void {
        c.gtk_range_set_inverted(self.ptr, if (inverted) 1 else 0);
    }

    pub fn get_value(self: Self) f64 {
        return c.gtk_range_get_value(self.ptr);
    }

    pub fn set_value(self: Self, val: f64) void {
        c.gtk_range_set_value(self.ptr, val);
    }

    pub fn set_increments(self: Self, step: f64, page: f64) void {
        c.gtk_range_set_increments(self.ptr, step, page);
    }

    pub fn set_range(self: Self, min: f64, max: f64) void {
        c.gtk_range_set_range(self.ptr, min, max);
    }

    pub fn get_round_digits(self: Self) c_int {
        return c.gtk_range_get_round_digits(self.ptr);
    }

    pub fn set_round_digits(self: Self, digits: c_int) void {
        c.gtk_range_set_round_digits(self.ptr, digits);
    }

    pub fn set_lower_stepper_sensitivity(self: Self, sensitivity: SensitivityType) void {
        c.gtk_range_set_lower_stepper_sensitivity(self.ptr, @enumToInt(sensitivity));
    }

    pub fn get_lower_stepper_sensitivity(self: Self) SensitivityType {
        return @intToEnum(SensitivityType, c.gtk_range_get_lower_stepper_sensitivity(self.ptr));
    }

    pub fn set_upper_stepper_sensitivity(self: Self, sensitivity: SensitivityType) void {
        c.gtk_range_set_upper_stepper_sensitivity(self.ptr, @enumToInt(sensitivity));
    }

    pub fn get_upper_stepper_sensitivity(self: Self) SensitivityType {
        return @intToEnum(SensitivityType, c.gtk_range_get_upper_stepper_sensitivity(self.ptr));
    }

    pub fn get_flippable(self: Self) bool {
        return (c.gtk_range_get_flippable(self.ptr) == 1);
    }

    pub fn set_flippable(self: Self, flippable: bool) void {
        c.gtk_range_set_flippable(self.ptr, if (flippable) 1 else 0);
    }

    pub fn connect_value_changed(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("value_changed", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_range_get_type() or Scale.is_instance(gtype) or SpinButton.is_instance(gtype));
    }
};

pub const Scale = struct {
    ptr: *c.GtkScale,

    pub fn new(orientation: Orientation, adjustment: Adjustment) Scale {
        return Scale{
            .ptr = @ptrCast(*c.GtkScale, c.gtk_scale_new(@enumToInt(orientation), adjustment.ptr)),
        };
    }

    pub fn new_with_range(orientation: Orientation, min: f64, max: f64, step: f64) Scale {
        return Scale{
            .ptr = @ptrCast(*c.GtkScale, c.gtk_scale_new_with_range(@enumToInt(orientation), min, max, step)),
        };
    }

    pub fn get_digits(self: Scale) c_int {
        return c.gtk_scale_get_digits(self.ptr);
    }

    pub fn set_digits(self: Scale, digits: c_int) void {
        c.gtk_scale_set_digits(self.ptr, digits);
    }

    pub fn get_draw_value(self: Scale) bool {
        return (c.gtk_scale_get_draw_value(self.ptr) == 1);
    }

    pub fn set_draw_value(self: Scale, draw: bool) void {
        c.gtk_scale_set_draw_value(self.ptr, if (draw) 1 else 0);
    }

    pub fn get_has_origin(self: Scale) bool {
        return (c.gtk_scale_get_has_origin(self.ptr) == 1);
    }

    pub fn set_has_origin(self: Scale, origin: bool) void {
        c.gtk_scale_set_has_origin(self.ptr, if (origin) 1 else 0);
    }

    pub fn get_value_pos(self: Scale) PositionType {
        return @intToEnum(PositionType, c.gtk_scale_get_value_pos(self.scale));
    }

    pub fn set_value_pos(self: Scale, pos: PositionType) void {
        c.gtk_scale_set_value_pos(self.ptr, @enumToInt(pos));
    }

    pub fn add_mark(self: Scale, value: f64, pos: PositionType, markup: ?[:0]const u8) void {
        c.gtk_scale_add_mark(self.ptr, value, @enumToInt(pos), if (markup) |t| t else null);
    }

    pub fn clear_marks(self: Scale) void {
        c.gtk_scale_clear_marks(self.ptr);
    }

    pub fn as_orientable(self: Scale) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_range(self: Scale) Range {
        return Range{
            .ptr = @ptrCast(*c.GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: Scale) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_scale_get_type());
    }
};

pub const SpinButton = struct {
    ptr: *c.GtkSpinButton,

    const Self = @This();

    pub const Increments = struct {
        step: f64,
        page: f64,
    };

    pub const Bounds = struct {
        min: f64,
        max: f64,
    };

    pub fn configure(self: Self, adjustment: Adjustment, climb_rate: f64, digits: c_uint) void {
        c.gtk_spin_button_configure(self.ptr, adjustment.ptr, climb_rate, digits);
    }

    pub fn new(adjustment: Adjustment, climb_rate: f64, digits: c_uint) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkSpinButton, c.gtk_spin_button_new(adjustment.ptr, climb_rate, digits)),
        };
    }

    pub fn new_with_range(min: f64, max: f64, step: f64) Self {
        return Self{
            .ptr = c.gtk_spin_button_new_with_range(min, max, step),
        };
    }

    pub fn set_adjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_spin_button_set_adjustment(self.ptr, adjustment.ptr);
    }

    pub fn get_adjustment(self: Self) Adjustment {
        return Adjustment{
            .ptr = c.gtk_spin_button_get_adjustment(self.ptr),
        };
    }

    pub fn set_digits(self: Self, digits: c_uint) void {
        c.gtk_spin_button_set_digits(self.ptr, digits);
    }

    pub fn set_increments(self: Self, step: f64, page: f64) void {
        c.gtk_spin_button_set_increments(self.ptr, step, page);
    }

    pub fn set_range(self: Self, min: f64, max: f64) void {
        c.gtk_spin_button_set_range(self.ptr, min, max);
    }

    pub fn get_value_as_int(self: Self) c_int {
        return c.gtk_spin_button_get_value_as_int(self.ptr);
    }

    pub fn set_value(self: Self, value: f64) void {
        c.gtk_spin_button_set_value(self.ptr, value);
    }

    pub fn set_update_policy(self: Self, policy: SpinButtonUpdatePolicy) void {
        c.gtk_spin_button_set_update_policy(self.ptr, @enumToInt(policy));
    }

    pub fn set_numeric(self: Self, numeric: bool) void {
        c.gtk_spin_button_set_numeric(self.ptr, if (numeric) 1 else 0);
    }

    pub fn spin(self: Self, direction: SpinType, increment: f64) void {
        c.gtk_spin_button_spin(self.ptr, @enumToInt(direction), increment);
    }

    pub fn set_wrap(self: Self, wrap: bool) void {
        c.gtk_spin_button_set_wrap(self.ptr, if (wrap) 1 else 0);
    }

    pub fn set_snap_to_ticks(self: Self, snap: bool) void {
        c.gtk_spin_button_set_snap_to_ticks(self.ptr, if (snap) 1 else 0);
    }

    pub fn update(self: Self) void {
        c.gtk_spin_button_update(self.ptr);
    }

    pub fn get_digits(self: Self) c_uint {
        return c.gtk_spin_button_get_digits(self.ptr);
    }

    pub fn get_increments(self: Self) Increments {
        var step: f64 = 0;
        var page: f64 = 0;
        c.gtk_spin_button_get_increments(self.ptr, step, page);
        return Increments{ .step = step, .page = page };
    }

    pub fn get_numeric(self: Self) bool {
        return (c.gtk_spin_button_get_numeric(self.ptr) == 1);
    }

    pub fn get_range(self: Self) Bounds {
        var min: f64 = 0;
        var max: f64 = 0;
        c.gtk_spin_button_get_range(self.ptr, min, max);
        return Bounds{ .min = min, .max = max };
    }

    pub fn get_snap_to_ticks(self: Self) bool {
        return (c.gtk_spin_button_get_snap_to_ticks(self.ptr) == 1);
    }

    pub fn get_update_policy(self: Self) SpinButtonUpdatePolicy {
        return @intToEnum(SpinButtonUpdatePolicy, c.gtk_spin_button_get_update_policy(self.ptr));
    }

    pub fn get_value(self: Self) f64 {
        return c.gtk_spin_button_get_value(self.ptr);
    }

    pub fn get_wrap(self: Self) bool {
        return (c.gtk_spin_button_get_wrap(self.ptr) == 1);
    }

    pub fn connect_value_changed(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("value_changed", callback, if (data) |d| d else null);
    }

    pub fn as_range(self: Self) Range {
        return Range{
            .ptr = @ptrCast(*c.GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_spin_button_get_type());
    }
};
