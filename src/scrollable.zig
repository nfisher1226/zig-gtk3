const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig").Adjustment;
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

/// GtkScrollable is an interface that is implemented by widgets with native
/// scrolling ability.
///
/// To implement this interface you should override the “hadjustment” and
/// “vadjustment” properties.
/// ### Creating a scrollable widget
/// All scrollable widgets should do the following.
/// * When a parent widget sets the scrollable child widget’s adjustments, the widget should populate the adjustments’ “lower”, “upper”, “step-increment”, “page-increment” and “page-size” properties and connect to the “value-changed” signal.
/// * Because its preferred size is the size for a fully expanded widget, the scrollable widget must be able to cope with underallocations. This means that it must accept any value passed to its GtkWidgetClass.size_allocate() function.
/// * When the parent allocates space to the scrollable child widget, the widget should update the adjustments’ properties with new values.
/// * When any of the adjustments emits the “value-changed” signal, the scrollable widget should scroll its contents.
pub const Scrollable = struct {
    ptr: *c.GtkScrollable,

    const Self = @This();

    /// Defines the policy to be used in a scrollable widget when updating the
    /// scrolled window adjustments in a given orientation.
    pub const Policy = enum(c_uint) {
        /// Scrollable adjustments are based on the minimum size
        minimum = c.GTK_SCROLL_MINIMUM,
        /// Scrollable adjustments are based on the natural size
        natural = c.GTK_SCROLL_NATURAL,
    };

    /// Retrieves the GtkAdjustment used for horizontal scrolling.
    pub fn get_hadjustment(self: Self) Adjustment {
        return Adjustment{
            .ptr = c.gtk_scrollable_get_hadjustment(self.ptr),
        };
    }

    /// Sets the horizontal adjustment of the GtkScrollable.
    pub fn set_hadjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_scrollable_set_hadjustment(self.ptr, adjustment.ptr);
    }

    /// Retrieves the GtkAdjustment used for vertical scrolling.
    pub fn get_vadjustment(self: Self) Adjustment {
        return Adjustment{
            .ptr = c.gtk_scrollable_get_vadjustment(self.ptr),
        };
    }

    /// Sets the vertical adjustment of the GtkScrollable.
    pub fn set_vadjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_scrollable_set_vadjustment(self.ptr, adjustment.ptr);
    }

    /// Gets the horizontal GtkScrollablePolicy.
    pub fn get_hscroll_policy(self: Self) Policy {
        return @intToEnum(Policy, c.gtk_scrollable_get_hscroll_policy(self.ptr));
    }

    /// Sets the horizontal GtkScrollablePolicy.
    pub fn set_hscroll_policy(self: Self) Policy {
        return @intToEnum(Policy, c.gtk_scrollable_set_hscroll_policy(self.ptr));
    }

    /// Gets the vertical GtkScrollablePolicy.
    pub fn get_vscroll_policy(self: Self) Policy {
        return @intToEnum(Policy, c.gtk_scrollable_get_vscroll_policy(self.ptr));
    }

    /// Sets the vertical GtkScrollablePolicy.
    pub fn set_vscroll_policy(self: Self) Policy {
        return @intToEnum(Policy, c.gtk_scrollable_set_vscroll_policy(self.ptr));
    }

    /// Returns the size of a non-scrolling border around the outside of the
    /// scrollable. An example for this would be treeview headers. GTK+ can use
    /// this information to display overlayed graphics, like the overshoot
    /// indication, at the right position.
    pub fn get_border(self: Self) ?c.GtkBorder {
        var border = c.GtkBorder{
            .left = 0,
            .right = 0,
            .top = 0,
            .bottom = 0,
        };
        return if (c.gtk_scrollable_get_border(self.ptr, &border) == 1) border else null;
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_scrollable_get_type());
    }
};
