const c = @import("cimport.zig");

/// Accelerator flags used with gtk_accel_group_connect().
pub const AccelFlags = enum(c_uint) {
    visible = c.GTK_ACCEL_VISIBLE,
    locked = c.GTK_ACCEL_LOCKED,
    mask = c.GTK_ACCEL_LOCKED,
};

/// A GtkAccelGroup represents a group of keyboard accelerators, typically
/// attached to a toplevel GtkWindow (with gtk_window_add_accel_group()).
/// Usually you won’t need to create a GtkAccelGroup directly; instead, when
/// using GtkUIManager, GTK+ automatically sets up the accelerators for your
/// menus in the ui manager’s GtkAccelGroup.
///
/// Note that “accelerators” are different from “mnemonics”. Accelerators are
/// shortcuts for activating a menu item; they appear alongside the menu item
/// they’re a shortcut for. For example “Ctrl+Q” might appear alongside the
/// “Quit” menu item. Mnemonics are shortcuts for GUI elements such as text
/// entries or buttons; they appear as underlined characters. See
/// gtk_label_new_with_mnemonic(). Menu items can have both accelerators and
/// mnemonics, of course.
pub const AccelGroup = struct {
    ptr: *c.GtkAccelGroup,

    const Self = @This();

    /// Creates a new GtkAccelGroup.
    pub fn new() Self {
        return Self{ .ptr = c.gtk_accel_group_new() };
    }

    /// Installs an accelerator in this group. When accel_group is being
    /// activated in response to a call to gtk_accel_groups_activate(), closure
    /// will be invoked if the accel_key and accel_mods from
    /// gtk_accel_groups_activate() match those of this connection.
    ///
    /// The signature used for the closure is that of GtkAccelGroupActivate.
    ///
    /// Note that, due to implementation details, a single closure can only be
    /// connected to one accelerator group.
    pub fn connect(
        self: Self,
        /// key value of the accelerator
        accel_key: c_uint,
        /// modifier combination of the accelerator
        accel_mods: c.GdkModifierType,
        /// a flag mask to configure this accelerator
        accel_flags: AccelFlags,
        /// closure to be executed upon accelerator activation
        closure: *c.GClosure,
    ) void {
        c.gtk_accel_group_connect(self.ptr, accel_key, accel_mods, @enumToInt(accel_flags), closure);
    }
};
