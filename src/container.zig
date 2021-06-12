usingnamespace @import("cimport.zig");
usingnamespace @import("widget.zig");

pub const Container = struct {
    ptr: *GtkContainer,

    pub fn add(self: Container, widget: Widget) void {
        gtk_container_add(self.ptr, widget.ptr);
    }

    pub fn as_widget(self: Box) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

