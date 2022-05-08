const c = @import("cimport.zig").c;

const Bin = @import("bin.zig").Bin;
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const PositionType = @import("enums.zig").PositionType;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// GtkPopover is a bubble-like context window, primarily meant to provide
/// context-dependent information or options. Popovers are attached to a widget,
/// passed at construction time on Popover.new(), or updated afterwards through
/// Popover.set_relative_to(), by default they will point to the whole widget
/// area, although this behavior can be changed through Popover.set_pointing_to().
///
/// The position of a popover relative to the widget it is attached to can also
/// be changed through Popover.set_position().
///
/// By default, GtkPopover performs a GTK+ grab, in order to ensure input events
/// get redirected to it while it is shown, and also so the popover is dismissed
/// in the expected situations (clicks outside the popover, or the Esc key being
/// pressed). If no such modal behavior is desired on a popover,
/// Popover.set_modal() may be called on it to tweak its behavior.
/// ### GtkPopover as menu replacement
/// GtkPopover is often used to replace menus. To facilitate this, it supports
/// being populated from a GMenuModel, using gtk_popover_new_from_model(). In
/// addition to all the regular menu model features, this function supports
/// rendering sections in the model in a more compact form, as a row of icon
/// buttons instead of menu items.
///
/// To use this rendering, set the ”display-hint” attribute of the section to
/// ”horizontal-buttons” and set the icons of your items with the ”verb-icon”
/// attribute.
/// ```XML
/// <section>
///   <attribute name="display-hint">horizontal-buttons</attribute>
///   <item>
///     <attribute name="label">Cut</attribute>
///     <attribute name="action">app.cut</attribute>
///     <attribute name="verb-icon">edit-cut-symbolic</attribute>
///   </item>
///   <item>
///     <attribute name="label">Copy</attribute>
///     <attribute name="action">app.copy</attribute>
///     <attribute name="verb-icon">edit-copy-symbolic</attribute>
///   </item>
///   <item>
///     <attribute name="label">Paste</attribute>
///     <attribute name="action">app.paste</attribute>
///     <attribute name="verb-icon">edit-paste-symbolic</attribute>
///   </item>
/// </section>
/// ```
/// ### CSS
/// GtkPopover has a single css node called popover. It always gets the
/// .background style class and it gets the .menu style class if it is menu-like
/// (e.g. GtkPopoverMenu or created using Popover.new_from_model().
///
/// Particular uses of GtkPopover, such as touch selection popups or magnifiers
/// in GtkEntry or GtkTextView get style classes like .touch-selection or
/// .magnifier to differentiate from plain popovers.
pub const Popover = struct {
    ptr: *c.GtkPopover,

    const Self = @This();

    /// Describes constraints to positioning of popovers. More values may be
    /// added to this enumeration in the future.
    pub const Constraint = enum(c_uint) {
        none = c.GTK_POPOVER_CONSTRAINT_NONE,
        window = c.GTK_POPOVER_CONSTRAINT_WINDOW,
    };

    /// Creates a new popover to point to `parent`
    pub fn new(parent: Widget) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkPopover, c.gtk_popover_new(parent.ptr)),
        };
    }

    /// Creates a GtkPopover and populates it according to model . The popover
    /// is pointed to the relative_to widget.
    ///
    /// The created buttons are connected to actions found in the
    /// GtkApplicationWindow to which the popover belongs - typically by means
    /// of being attached to a widget that is contained within the
    /// GtkApplicationWindows widget hierarchy.
    ///
    /// Actions can also be added using gtk_widget_insert_action_group() on the
    /// menus attach widget or on any of its parent widgets.
    pub fn new_from_model(model: *c.GMenuModel) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkPopover, c.gtk_popover_new_from_model(model)),
        };
    }

    /// Establishes a binding between a GtkPopover and a GMenuModel.
    ///
    /// The contents of popover are removed and then refilled with menu items
    /// according to model . When model changes, popover is updated. Calling
    /// this function twice on popover with different model will cause the first
    /// binding to be replaced with a binding to the new model. If model is NULL
    /// then any previous binding is undone and all children are removed.
    ///
    ///If action_namespace is non-NULL then the effect is as if all actions
    ///mentioned in the model have their names prefixed with the namespace, plus
    ///a dot. For example, if the action “quit” is mentioned and action_namespace
    ///is “app” then the effective action name is “app.quit”.
    ///
    /// This function uses GtkActionable to define the action name and target
    /// values on the created menu items. If you want to use an action group
    /// other than “app” and “win”, or if you want to use a GtkMenuShell outside
    /// of a GtkApplicationWindow, then you will need to attach your own action
    /// group to the widget hierarchy using gtk_widget_insert_action_group(). As
    /// an example, if you created a group with a “quit” action and inserted it
    /// with the name “mygroup” then you would use the action name
    /// “mygroup.quit” in your GMenuModel.
    pub fn bind_model(self: Self, model: ?*c.GMenuModel, action_namespace: ?[:0]const u8) void {
        c.gtk_popover_bind_model(self.ptr, if (model) |m| m else null, if (action_namespace) |a| a else null);
    }

    /// Pops popover up. This is different than a gtk_widget_show() call in that
    /// it shows the popover with a transition. If you want to show the popover
    /// without a transition, use gtk_widget_show().
    pub fn popup(self: Self) void {
        c.gtk_popover_popup(self.ptr);
    }

    /// Pops popover down.This is different than a gtk_widget_hide() call in
    /// that it shows the popover with a transition. If you want to hide the
    /// popover without a transition, use gtk_widget_hide().
    pub fn podown(self: Self) void {
        c.gtk_popover_popdown(self.ptr);
    }

    /// Sets a new widget to be attached to popover . If popover is visible, the position will be updated.
    ///
    /// > Note: the ownership of popovers is always given to their relative_to
    /// > widget, so if relative_to is set to NULL on an attached popover , it
    /// > will be detached from its previous widget, and consequently destroyed
    /// > unless extra references are kept.
    pub fn set_relative_to(self: Self, parent: Widget) void {
        c.gtk_popover_set_relative_to(self.ptr, parent.ptr);
    }

    /// Returns the widget popover is currently attached to
    pub fn get_relative_to(self: Self) Widget {
        return Widget{
            .ptr = c.gtk_popover_get_relative_to(self.ptr),
        };
    }

    /// Sets the rectangle that popover will point to, in the coordinate space
    /// of the widget popover is attached to, see gtk_popover_set_relative_to().
    pub fn set_pointing_to(self: Self, rect: *c.GdkRectangle) void {
        c.gtk_popover_set_pointing_to(self.ptr, rect);
    }

    pub fn get_pointing_to(self: Self) ?*c.GdkRectangle {
        var rect: *c.GdkRectangle = undefined;
        return if (c.gtk_popover_get_pointing_to(self.ptr, rect)) rect else null;
    }

    /// Sets the preferred position for popover to appear. If the popover is
    /// currently visible, it will be immediately updated.
    ///
    /// This preference will be respected where possible, although on lack of
    /// space (eg. if close to the window edges), the GtkPopover may choose to
    /// appear on the opposite side
    pub fn set_position(self: Self, position: PositionType) void {
        c.gtk_popover_set_position(self.ptr, position);
    }

    /// Returns the preferred position of self.
    pub fn get_position(self: Self) PositionType {
        return c.gtk_popover_get_position(self.ptr);
    }

    /// Sets a constraint for positioning this popover.
    ///
    /// Note that not all platforms support placing popovers freely, and may
    /// already impose constraints.
    pub fn set_constrain_to(self: Self, constraint: Constraint) void {
        c.gtk_popover_set_constraint_to(self.ptr, constraint);
    }

    /// Returns the constraint for placing this popover. See set_constrain_to().
    pub fn get_constrain_to(self: Self) Constraint {
        return c.gtk_popover_get_constrain_to(self.ptr);
    }

    /// Sets whether popover is modal, a modal popover will grab all input
    /// within the toplevel and grab the keyboard focus on it when being
    /// displayed. Clicking outside the popover area or pressing Esc will
    /// dismiss the popover and ungrab input.
    pub fn set_modal(self: Self, modal: bool) void {
        c.gtk_popover_set_modal(self.ptr, if (modal) 1 else 0);
    }

    /// Returns whether the popover is modal, see gtk_popover_set_modal to see
    /// the implications of this.
    pub fn get_modal(self: Self) bool {
        return (c.gtk_popover_get_modal(self.ptr) == 1);
    }

    /// Sets the widget that should be set as default widget while the popover
    /// is shown (see gtk_window_set_default()). GtkPopover remembers the
    /// previous default widget and reestablishes it when the popover is
    /// dismissed.
    pub fn set_default_widget(self: Self, widget: Widget) void {
        c.gtk_popover_set_default_widget(self.ptr, widget.ptr);
    }

    /// Gets the widget that should be set as the default while the popover is
    /// shown.
    pub fn get_default_widget(self: Self) ?Widget {
        return if (c.gtk_popover_get_default_widget(self.ptr)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn as_bin(self: Self) Bin {
        return Bin{
            .ptr = @ptrCast(*c.GtkBin, self.ptr),
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

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_popover_get_type() or gtype == c.gtk_popover_menu_get_type());
    }

    pub fn to_popover_menu(self: Self) ?PopoverMenu {
        return if (self.as_widget().isa(PopoverMenu)) PopoverMenu{
            .ptr = @ptrCast(*c.GtkPopoverMenu, self.ptr),
        } else null;
    }
};

/// GtkPopoverMenu is a subclass of GtkPopover that treats its children like
/// menus and allows switching between them. It is meant to be used primarily
/// together with GtkModelButton, but any widget can be used, such as
/// GtkSpinButton or GtkScale. In this respect, GtkPopoverMenu is more flexible
/// than popovers that are created from a GMenuModel with Popover.new_from_model().
///
/// To add a child as a submenu, set the “submenu” child property to the name of
/// the submenu. To let the user open this submenu, add a GtkModelButton whose
/// “menu-name” property is set to the name you've given to the submenu.
///
/// By convention, the first child of a submenu should be a GtkModelButton to
/// switch back to the parent menu. Such a button should use the “inverted” and
/// “centered” properties to achieve a title-like appearance and place the
/// submenu indicator at the opposite side. To switch back to the main menu, use
/// "main" as the menu name.
/// ```XML
/// <object class="GtkPopoverMenu">
///   <child>
///     <object class="GtkBox">
///       <property name="visible">True</property>
///       <property name="margin">10</property>
///       <child>
///         <object class="GtkModelButton">
///           <property name="visible">True</property>
///           <property name="action-name">win.frob</property>
///           <property name="text" translatable="yes">Frob</property>
///         </object>
///       </child>
///       <child>
///         <object class="GtkModelButton">
///           <property name="visible">True</property>
///           <property name="menu-name">more</property>
///           <property name="text" translatable="yes">More</property>
///         </object>
///       </child>
///     </object>
///   </child>
///   <child>
///     <object class="GtkBox">
///       <property name="visible">True</property>
///       <property name="margin">10</property>
///       <child>
///         <object class="GtkModelButton">
///           <property name="visible">True</property>
///           <property name="action-name">win.foo</property>
///           <property name="text" translatable="yes">Foo</property>
///         </object>
///       </child>
///       <child>
///         <object class="GtkModelButton">
///           <property name="visible">True</property>
///           <property name="action-name">win.bar</property>
///           <property name="text" translatable="yes">Bar</property>
///         </object>
///       </child>
///     </object>
///     <packing>
///       <property name="submenu">more</property>
///     </packing>
///   </child>
/// </object>
/// ```
/// Just like normal popovers created using gtk_popover_new_from_model,
/// GtkPopoverMenu instances have a single css node called "popover" and
/// get the .menu style class.
pub const PopoverMenu = struct {
    ptr: *c.GtkPopoverMenu,

    const Self = @This();

    /// Creates a new popover menu.
    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkPopoverMenu, c.gtk_popover_menu_new()),
        };
    }

    /// Opens a submenu of the popover . The name must be one of the names given
    /// to the submenus of popover with “submenu”, or "main" to switch back to
    /// the main menu.
    ///
    /// GtkModelButton will open submenus automatically when the “menu-name”
    /// property is set, so this function is only needed when you are using
    /// other kinds of widgets to initiate menu changes.
    pub fn open_submenu(self: Self, name: [:0]const u8) void {
        c.gtk_popover_menu_open_submenu(self.ptr, name);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    pub fn as_popover(self: Self) Popover {
        return Popover{
            .ptr = @ptrCast(*c.GtkPopover, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_popover_menu_get_type());
    }
};
