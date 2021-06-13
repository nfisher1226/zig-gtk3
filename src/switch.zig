usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("widget.zig");

pub const Switch = struct {
    ptr = *GtkSwitch,

    // Creates a new Switch
    pub fn new() Switch {
        return Switch {
            .ptr = gtk_switch_new(),
        };
    }

    // Gets whether the Switch is in it's "on" or "off" state
    pub fn get_active(self: Switch) bool {
        const ret = if (gtk_switch_get_active(self.ptr) == 1) true else false;
        return ret;
    }

    // Sets the state of Switch on or off
    pub fn set_active(self: Switch, state: bool) void {
        gtk_switch_set_active(self.ptr, bool_to_c_int(state));
    }

    pub fn connect_state_set(self: Switch, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            self.as_widget().connect("state_set", callback, d);
        } else {
            self.as_widget().connect("state-set", callback, null);
        }
    }

    pub fn as_widget(self: Switch) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};
