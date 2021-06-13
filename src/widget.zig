usingnamespace @import("cimport.zig");
usingnamespace @import("button.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("range.zig");
usingnamespace @import("switch.zig");
usingnamespace @import("window.zig");

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

    pub fn to_button(self: Widget) ?Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, self.ptr),
        };
    }

    pub fn to_toggle_button(self: Widget) ?ToggleButton {
        return ToggleButton {
            .ptr = @ptrCast(*GtkToggleButton, self.ptr),
        };
    }

    pub fn to_check_button(self: Widget) ?CheckButton {
        return CheckButton {
            .ptr = @ptrCast(*GtkCheckButton, self.ptr),
        };
    }

    pub fn to_switch(self: Widget) ?Switch {
        return Switch {
            .ptr = @ptrCast(*GtkSwitch, self.ptr),
        };
    }

    pub fn to_window(self: Widget) ?Window {
        return Window {
            .ptr = @ptrCast(*GtkWindow, self.ptr),
        };
    }
};

