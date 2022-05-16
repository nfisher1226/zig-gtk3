const c = @import("cimport.zig");
const Box = @import("box.zig").Box;
const Buildable = @import("buildable.zig").Buildable;
const Button = @import("button.zig").Button;
const Container = @import("container.zig").Container;
const Orientable = @import("orientable.zig").Orientable;
const Orientation = @import("enums.zig").Orientation;
const Widget = @import("widget.zig").Widget;

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

/// A button box should be used to provide a consistent layout of buttons
/// throughout your application. The layout/spacing can be altered by the
/// programmer, or if desired, by the user to alter the “feel” of a program
/// to a small degree.
///
/// gtk_button_box_get_layout() and gtk_button_box_set_layout() retrieve and
/// alter the method used to spread the buttons in a button box across the
/// container, respectively.
///
/// The main purpose of GtkButtonBox is to make sure the children have all the
/// same size. GtkButtonBox gives all children the same size, but it does allow
/// 'outliers' to keep their own larger size.
///
/// To exempt individual children from homogeneous sizing regardless of their
/// 'outlier' status, you can set the non-homogeneous child property.
/// ### CSS
/// GtkButtonBox uses a single CSS node with name buttonbox.
pub const ButtonBox = struct {
    ptr: *c.GtkButtonBox,

    const Self = @This();

    pub const Style = enum(c_uint) {
        spread = c.GTK_BUTTONBOX_SPREAD,
        edge = c.GTK_BUTTONBOX_EDGE,
        start = c.GTK_BUTTONBOX_START,
        end = c.GTK_BUTTONBOX_END,
        center = c.GTK_BUTTONBOX_CENTER,
        expand = c.GTK_BUTTONBOX_EXPAND,
    };

    /// Creates a new GtkButtonBox.
    pub fn new(orientation: Orientation) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkButtonBox, c.gtk_button_box_new(orientation)),
        };
    }

    /// Retrieves the method being used to arrange the buttons in a button box.
    pub fn get_layout(self: Self) Style {
        return c.gtk_button_box_get_layout(self.ptr);
    }

    /// Returns whether child should appear in a secondary group of children.
    pub fn get_child_secondary(self: Self, child: Widget) bool {
        return (c.gtk_button_box_get_child_secondary(self.ptr, child.ptr) == 1);
    }

    /// Returns whether the child is exempted from homogenous sizing.
    pub fn get_child_non_homogeneous(self: Self, child: Widget) bool {
        return (c.gtk_button_box_get_child_non_homogeneous(self.ptr, child.ptr) == 1);
    }

    /// Changes the way buttons are arranged in their container.
    pub fn set_layout(self: Self, layout: Style) void {
        c.gtk_button_box_set_layout(self.ptr, layout);
    }

    /// Sets whether child should appear in a secondary group of children. A
    /// typical use of a secondary child is the help button in a dialog.
    ///
    /// This group appears after the other children if the style is
    /// GTK_BUTTONBOX_START, GTK_BUTTONBOX_SPREAD or GTK_BUTTONBOX_EDGE, and
    /// before the other children if the style is GTK_BUTTONBOX_END. For
    /// horizontal button boxes, the definition of before/after depends on
    /// direction of the widget (see gtk_widget_set_direction()). If the style
    /// is GTK_BUTTONBOX_START or GTK_BUTTONBOX_END, then the secondary children
    /// are aligned at the other end of the button box from the main children.
    /// For the other styles, they appear immediately next to the main children.
    pub fn set_child_secondary(self: Self, set: bool) void {
        c.gtk_button_box_set_child_secondary(self.ptr, if (set) 1 else 0);
    }

    /// Sets whether the child is exempted from homogeous sizing.
    pub fn set_child_non_homogeneous(self: Self, child: Widget, set: bool) void {
        c.gtk_button_box_set_child_non_homogeneous(self.ptr, child.ptr, if (set) 1 else 0);
    }

    pub fn as_box(self: Self) Box {
        return Box{
            .ptr = @ptrCast(*c.GtkBox, self.ptr),
        };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    pub fn as_button(self: Self) Button {
        return Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_check_button_box_get_type());
    }
};
