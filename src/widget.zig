usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
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

    pub fn to_window(self: Widget) ?Window {
        return Window {
            .ptr = @ptrCast(*GtkWindow, self.ptr),
        };
    }
};

