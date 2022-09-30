const c = @import("cimport.zig");
const common = @import("common.zig");
const bool_to_c_int = common.bool_to_c_int;
const Container = @import("container.zig").Container;
const Dialog = @import("dialog.zig").Dialog;
const WindowType = @import("enums.zig").WindowType;
const Widget = @import("widget.zig").Widget;

pub const ApplicationWindow = struct {
    ptr: *c.GtkApplicationWindow,

    pub fn new(app: *c.GtkApplication) ApplicationWindow {
        return ApplicationWindow{
            .ptr = @ptrCast(*c.GtkApplicationWindow, c.gtk_application_window_new(app)),
        };
    }

    pub fn as_window(self: ApplicationWindow) Window {
        return Window{
            .ptr = @ptrCast(*c.GtkWindow, self.ptr),
        };
    }

    pub fn as_container(self: ApplicationWindow) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: ApplicationWindow) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_application_window_get_type());
    }
};

pub const Window = struct {
    ptr: *c.GtkWindow,

    const Self = @This();

    pub fn new(window_type: WindowType) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkWindow, c.gtk_window_new(@enumToInt(window_type))),
        };
    }

    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_window_set_title(self.ptr, title.ptr);
    }

    pub fn set_default_size(self: Self, hsize: c_int, vsize: c_int) void {
        c.gtk_window_set_default_size(self.ptr, hsize, vsize);
    }

    pub fn set_decorated(self: Self, decorated: bool) void {
        const val = bool_to_c_int(decorated);
        c.gtk_window_set_decorated(self.ptr, val);
    }

    pub fn close(self: Self) void {
        c.gtk_window_close(self.ptr);
    }

    pub fn set_transient_for(self: Self, parent: Self) void {
        c.gtk_window_set_transient_for(self.ptr, parent.ptr);
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_window_get_type() or ApplicationWindow.is_instance(gtype) or Dialog.is_instance(gtype));
    }
};
