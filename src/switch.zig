const c = @import("cimport.zig");
const common = @import("common.zig");
const bool_to_c_int = common.bool_to_c_int;
const Widget = @import("widget.zig").Widget;

pub const Switch = struct {
    ptr: *c.GtkSwitch,

    // Creates a new Switch
    pub fn new() Switch {
        return Switch{
            .ptr = c.gtk_switch_new(),
        };
    }

    // Gets whether the Switch is in it's "on" or "off" state
    pub fn get_active(self: Switch) bool {
        return (c.gtk_switch_get_active(self.ptr) == 1);
    }

    // Sets the state of Switch on or off
    pub fn set_active(self: Switch, state: bool) void {
        c.gtk_switch_set_active(self.ptr, bool_to_c_int(state));
    }

    pub fn connect_state_set(self: Switch, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("state_set", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Switch) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_switch_get_type());
    }
};
