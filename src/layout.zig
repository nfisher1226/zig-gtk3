const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig").Adjustment;
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Scrollable = @import("scrollable.zig").Scrollable;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

/// GtkLayout is similar to GtkDrawingArea in that it’s a “blank slate” and
/// doesn’t do anything except paint a blank background by default. It’s
/// different in that it supports scrolling natively due to implementing
/// GtkScrollable, and can contain child widgets since it’s a GtkContainer.
///
/// If you just want to draw, a GtkDrawingArea is a better choice since it has
/// lower overhead. If you just need to position child widgets at specific
/// points, then GtkFixed provides that functionality on its own.
///
/// When handling expose events on a GtkLayout, you must draw to the GdkWindow
/// returned by gtk_layout_get_bin_window(), rather than to the one returned by
/// gtk_widget_get_window() as you would for a GtkDrawingArea.
pub const Layout = struct {
    ptr: *c.GtkLayout,

    const Self = @This();

    pub const Size = struct {
        x: c_uint,
        y: c_uint,
    };

    /// Creates a new GtkLayout. Unless you have a specific adjustment you’d
    /// like the layout to use for scrolling, pass NULL for hadjustment and
    /// vadjustment.
    pub fn new(horizontal: Adjustment, vertical: Adjustment) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkLayout, c.gtk_layout_new(horizontal, vertical)),
        };
    }

    /// Adds child_widget to layout , at position (x ,y ). layout becomes the
    /// new parent container of child_widget.
    pub fn put(self: Self, child: Widget, x: c_int, y: c_int) void {
        c.gtk_layout_put(self.ptr, child.ptr, x, y);
    }

    /// Moves a current child of layout to a new position.
    pub fn move(self: Self, child: Widget, x: c_int, y: c_int) void {
        c.gtk_layout_move(self.ptr, child.ptr, x, y);
    }

    /// Sets the size of the scrollable area of the layout.
    pub fn set_size(self: Self, x: c_uint, y: c_uint) void {
        c.gtk_layout_set_size(self.ptr, x, y);
    }

    /// Gets the size that has been set on the layout, and that determines the
    /// total extents of the layout’s scrollbar area. See gtk_layout_set_size().
    pub fn get_size(self: Self) Size {
        var x: c_uint = undefined;
        var y: c_uint = undefined;
        c.gtk_layout_get_size(self.ptr, &x, &y);
        return Size{ .x = x, .y = y };
    }

    /// Retrieve the bin window of the layout used for drawing operations.
    pub fn get_bin_window(self: Self) Window {
        return Window{
            .ptr = @ptrCast(*c.GtkWindow, c.gtk_layout_get_bin_window(self.ptr)),
        };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_scrollable(self: Self) Scrollable {
        return Scrollable{
            .ptr = @ptrCast(*c.GtkScrollable, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_fixed_get_type());
    }
};
