const c = @import("cimport.zig");
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

const button = @import("button.zig");
const Button = button.Button;
const CheckButton = button.CheckButton;
const Widget = @import("widget.zig").Widget;

/// This interface provides a convenient way of associating widgets with actions
/// on an ApplicationWindow or Application.
///
/// It primarily consists of two properties: “action-name” and “action-target”.
/// There are also some convenience APIs for setting these properties.
///
/// The action will be looked up in action groups that are found among the widgets
/// ancestors. Most commonly, these will be the actions with the “win.” or “app.”
/// prefix that are associated with the ApplicationWindow or Application, but other
/// action groups that are added with Widget.insert_action_group() will be consulted
/// as well.
pub const Actionable = struct {
    ptr: *c.GtkActionable,

    const Self = @This();

    /// Gets the action name for actionable .
    ///
    /// See set_action_name() for more information.
    pub fn get_action_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_actionable_get_action_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    /// Specifies the name of the action with which this widget should be associated.
    /// If action_name is `null` then the widget will be unassociated from any previous
    /// action.
    ///
    /// Usually this function is used when the widget is located (or will be located)
    /// within the hierarchy of a GtkApplicationWindow.
    ///
    /// Names are of the form “win.save” or “app.quit” for actions on the containing
    /// ApplicationWindow or its associated Application, respectively. This is the
    /// same form used for actions in the GMenu associated with the window.
    pub fn set_action_name(self: Self, name: ?[:0]const u8) void {
        c.gtk_actionable_get_action_name(self.ptr, if (name) |n| n else null);
    }

    /// Gets the current target value of actionable .
    ///
    /// See set_action_target_value() for more information.
    pub fn get_action_target_value(self: Self) c.GVariant {
        return c.gtk_actionable_get_target_value(self.ptr);
    }

    /// Sets the target value of an actionable widget.
    ///
    /// If target_value is NULL then the target value is unset.
    ///
    /// The target value has two purposes. First, it is used as the parameter to
    /// activation of the action associated with the GtkActionable widget. Second,
    /// it is used to determine if the widget should be rendered as “active” — the
    /// widget is active if the state is equal to the given target.
    ///
    /// Consider the example of associating a set of buttons with a GAction with string
    /// state in a typical “radio button” situation. Each button will be associated with
    /// the same action, but with a different target value for that action. Clicking on
    /// a particular button will activate the action with the target of that button, which
    /// will typically cause the action’s state to change to that value. Since the action’s
    /// state is now equal to the target value of the button, the button will now be
    /// rendered as active (and the other buttons, with different targets, rendered
    /// inactive).
    pub fn set_action_target_value(self: Self, target: ?*c.GVariant) void {
        c.gtk_actionable_set_action_target_value(self.ptr, if (target) |t| t else null);
    }

    /// Sets the target of an actionable widget.
    ///
    /// This is a convenience function that calls g_variant_new() for format_string and
    /// uses the result to call set_action_target_value().
    ///
    /// If you are setting a string-valued target and want to set the action name at the
    /// same time, you can use set_detailed_action_name().
    pub fn set_action_target(self: Self, format: [:0]const u8, args: anytype) void {
        c.gtk_actionable_set_action_target(self.ptr, format, args);
    }

    /// Sets the action-name and associated string target value of an actionable widget.
    ///
    /// name is a string in the format accepted by g_action_parse_detailed_name().
    ///
    /// > (Note that prior to version 3.22.25, this function is only usable for actions
    /// > with a simple "s" target, and detailed_action_name must be of the form
    /// > "action::target" where action is the action name and target is the string to
    /// use as the target.)
    pub fn set_detailed_action_name(self: Self, name: [:0]const u8) void {
        c.gtk_actionable_set_detailed_action_name(self.ptr, name);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_actionable_get_type());
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_button(self: Self) ?Button {
        return if (self.isa(Button)) Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        } else null;
    }

    pub fn to_check_button(self: Self) ?CheckButton {
        return if (self.isa(CheckButton)) CheckButton{
            .ptr = @ptrCast(*c.GtkCheckButton, self.ptr),
        } else null;
    }
};
