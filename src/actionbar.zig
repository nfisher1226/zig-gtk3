const c = @import("cimport.zig");
const Bin = @import("bin.zig").Bin;
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

/// GtkActionBar is designed to present contextual actions. It is expected to be
/// displayed below the content and expand horizontally to fill the area.
///
/// It allows placing children at the start or the end. In addition, it contains
/// an internal centered box which is centered with respect to the full width of
/// the box, even if the children at either side take up different amounts of space.
/// # CSS
/// GtkActionBar has a single CSS node with name actionbar.
pub const ActionBar = struct {
    ptr: *c.GtkActionBar,

    const Self = @This();

    /// Creates a new ActionBar widget.
    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkActionBar, c.gtk_action_bar_new()),
        };
    }

    /// Adds child to action_bar, packed with reference to the start of the
    /// action_bar.
    pub fn pack_start(self: Self, child: Widget) void {
        c.gtk_action_bar_pack_start(self.ptr, child.ptr);
    }

    /// Adds child to action_bar, packed with reference to the end of the action_bar.
    pub fn pack_end(self: Self, child: Widget) void {
        c.gtk_action_bar_pack_end(self.ptr, child.ptr);
    }

    /// Retrieves the center bar widget of the bar.
    pub fn get_center_widget(self: Self) ?Widget {
        return if (c.gtk_action_bar_get_center_widget(self.ptr)) |w| Widget{
            .ptr = w,
        } else null;
    }

    /// Sets the center widget for the GtkActionBar.
    pub fn set_center_widget(self: Self, child: Widget) void {
        c.gtk_action_bar_set_center_widget(self.ptr, child.ptr);
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

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_action_bar_get_type());
    }
};
