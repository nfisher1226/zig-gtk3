usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("container.zig");
usingnamespace @import("dialog.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

pub const ApplicationWindow = struct {
    ptr: *GtkApplicationWindow,

    pub fn new(app: *GtkApplication) ApplicationWindow {
        return ApplicationWindow{
            .ptr = @ptrCast(*GtkApplicationWindow, gtk_application_window_new(app)),
        };
    }

    pub fn as_window(self: ApplicationWindow) Window {
        return Window{
            .ptr = @ptrCast(*GtkWindow, self.ptr),
        };
    }

    pub fn as_container(self: ApplicationWindow) Container {
        return Container{
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: ApplicationWindow) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_application_window_get_type());
    }
};

pub const Window = struct {
    ptr: *GtkWindow,

    pub fn new(window_type: WindowType) Window {
        return Window{
            .ptr = @ptrCast(*GtkWindow, gtk_window_new(window_type.parse())),
        };
    }

    pub fn set_title(self: Window, title: [:0]const u8) void {
        gtk_window_set_title(self.ptr, title);
    }

    pub fn set_default_size(self: Window, hsize: c_int, vsize: c_int) void {
        gtk_window_set_default_size(self.ptr, hsize, vsize);
    }

    pub fn set_decorated(self: Window, decorated: bool) void {
        const val = bool_to_c_int(decorated);
        gtk_window_set_decorated(self.ptr, val);
    }

    pub fn close(self: Window) void {
        gtk_window_close(self.ptr);
    }

    pub fn as_container(self: Window) Container {
        return Container{
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Window) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_window_get_type() or ApplicationWindow.is_instance(gtype) or Dialog.is_instance(gtype));
    }
};
