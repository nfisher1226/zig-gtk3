usingnamespace @import("cimport.zig");
usingnamespace @import("widget.zig");

pub const Button = struct {
    ptr: *GtkButton,

    pub fn new_with_label(text: [:0]const u8) Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, gtk_button_new_with_label(text)),
        };
    }

    pub fn as_widget(self: Button) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn connect_clicked(self: Button, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            self.as_widget().connect("clicked", callback, d);
        } else {
            self.as_widget().connect("clicked", callback, null);
        }
    }
};
