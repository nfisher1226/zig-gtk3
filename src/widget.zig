usingnamespace @import("cimport.zig");
usingnamespace @import("button.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("range.zig");
usingnamespace @import("switch.zig");
usingnamespace @import("window.zig");

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Widget = struct {
    ptr: *GtkWidget,

    pub fn show(self: Widget) void {
        gtk_widget_show(self.ptr);
    }

    pub fn show_now(self: Widget) void {
        gtk_widget_show_now(self.ptr);
    }

    pub fn hide(self: Widget) void {
        gtk_widget_hide(self.ptr);
    }

    pub fn show_all(self: Widget) void {
        gtk_widget_show_all(self.ptr);
    }

    pub fn is_focus(self: Widget) bool {
        return (gtk_widget_is_focus(self.ptr) == 1);
    }

    pub fn grab_focus(self: Widget) void {
        gtk_widget_grab_focus(self.ptr);
    }

    pub fn grab_default(self: Widget) void {
        gtk_widget_grab_default(self.ptr);
    }

    pub fn set_name(self: Widget, name: [:0]const u8) void {
        gtk_widget_set_name(self.ptr, name);
    }

    pub fn get_name(self: Widget, allocator: *mem.Allocator) ?[:0]const u8 {
        if (gtk_widget_get_name(self.ptr)) |n| {
            const len = mem.len(n);
            return fmt.allocPrintZ(allocator, "{s}", .{n[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn set_sensitive(self: Widget, visible: bool) void {
        gtk_widget_set_sensitive(self.ptr, bool_to_c_int(visible));
    }

    pub fn get_toplevel(self: Widget) Widget {
        return Widget{
            .ptr = gtk_widget_get_toplevel(self.ptr),
        };
    }

    pub fn get_parent(self: Widget) ?Widget {
        return if (gtk_widget_get_parent(self.ptr)) |w| Widget{ .ptr = w } else null;
    }

    pub fn get_has_toltip(self: Widget) bool {
        return (gtk_widget_get_has_tooltip(self.ptr) == 1);
    }

    pub fn set_has_tooltip(self: Widget, tooltip: bool) void {
        gtk_widget_set_has_tooltip(self.ptr, bool_to_c_int(tooltip));
    }

    pub fn get_tooltip_text(self: Widget, allocator: *mem.Allocator) ?[:0]const u8 {
        return if (gtk_widget_get_tooltip_text(self.ptr)) |t|
            fmt.allocPrintZ(allocator, "{s}", .{t}) catch return null
        else
            null;
    }

    pub fn set_tooltip_text(self: Widget, text: [:0]const u8) void {
        gtk_widget_set_tooltip_text(self.ptr, text);
    }

    pub fn destroy(self: Widget) void {
        gtk_widget_destroy(self.ptr);
    }

    pub fn connect(self: Widget, sig: [:0]const u8, callback: GCallback, data: ?gpointer) void {
        _ = signal_connect(self.ptr, sig, callback, if (data) |d| d else null);
    }

    fn get_g_type(self: Widget) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Widget, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_button(self: Widget) ?Button {
        if (self.isa(Button)) {
            return Button{
                .ptr = @ptrCast(*GtkButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_toggle_button(self: Widget) ?ToggleButton {
        if (self.isa(ToggleButton)) {
            return ToggleButton{
                .ptr = @ptrCast(*GtkToggleButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_check_button(self: Widget) ?CheckButton {
        if (self.isa(CheckButton)) {
            return CheckButton{
                .ptr = @ptrCast(*GtkCheckButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_box(self: Widget) ?Box {
        if (self.isa(Box)) {
            return Box{
                .ptr = @ptrCast(*GtkBox, self.ptr),
            };
        } else return null;
    }

    pub fn to_switch(self: Widget) ?Switch {
        if (self.isa(Switch)) {
            return Switch{
                .ptr = @ptrCast(*GtkSwitch, self.ptr),
            };
        } else return null;
    }

    pub fn to_window(self: Widget) ?Window {
        if (self.isa(Window)) {
            return Window{
                .ptr = @ptrCast(*GtkWindow, self.ptr),
            };
        } else return null;
    }
};
