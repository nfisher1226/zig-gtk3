usingnamespace @import("cimport.zig");
usingnamespace @import("button.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("range.zig");
usingnamespace @import("switch.zig");
usingnamespace @import("window.zig");

const std = @import("std");

pub const Widget = struct {
    ptr: *GtkWidget,

    pub fn show_all(self: Widget) void {
        gtk_widget_show_all(self.ptr);
    }

    pub fn connect(self: Widget, sig: [:0]const u8, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            _ = signal_connect(self.ptr, sig, callback, d);
        } else {
            _ = signal_connect(self.ptr, sig, callback, null);
        }
    }

    fn get_g_type(self: Widget) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Widget, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_button(self: Widget) ?Button {
        if (self.isa(Button)) {
            return Button {
                .ptr = @ptrCast(*GtkButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_toggle_button(self: Widget) ?ToggleButton {
        if (self.isa(ToggleButton)) {
            return ToggleButton {
                .ptr = @ptrCast(*GtkToggleButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_check_button(self: Widget) ?CheckButton {
        if (self.isa(CheckButton)) {
            return CheckButton {
                .ptr = @ptrCast(*GtkCheckButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_box(self: Widget) ?Box {
        if (self.isa(Box)) {
            return Box {
                .ptr = @ptrCast(*GtkBox, self.ptr),
            };
        } else return null;
    }

    pub fn to_switch(self: Widget) ?Switch {
        if (self.isa(Switch)) {
            return Switch {
                .ptr = @ptrCast(*GtkSwitch, self.ptr),
            };
        } else return null;
    }

    pub fn to_window(self: Widget) ?Window {
        if (self.isa(Window)) {
            return Window {
                .ptr = @ptrCast(*GtkWindow, self.ptr),
            };
        } else return null;
    }
};
