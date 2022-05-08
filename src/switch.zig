const c = @import("cimport.zig");

const Actionable = @import("actionable.zig").Actionable;
const Widget = @import("widget.zig").Widget;

pub const Switch = struct {
    ptr: *c.GtkSwitch,

    const Self = @This();

    // Creates a new Switch
    pub fn new() Self {
        return Self{
            .ptr = c.gtk_switch_new(),
        };
    }

    // Gets whether the Switch is in it's "on" or "off" state
    pub fn get_active(self: Self) bool {
        return (c.gtk_switch_get_active(self.ptr) == 1);
    }

    // Sets the state of Switch on or off
    pub fn set_active(self: Self, state: bool) void {
        c.gtk_switch_set_active(self.ptr, if (state) 1 else 0);
    }

    pub fn connect_state_set(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("state_set", callback, if (data) |d| d else null);
    }

    pub fn as_actionable(self: Self) Actionable {
        return Actionable{
            .ptr = @ptrCast(*c.GtkActionable, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_switch_get_type());
    }
};
