const c = @import("cimport.zig");

const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const BaselinePosition = enums.BaselinePosition;
const Orientable = @import("orientable.zig").Orientable;
const StackSwitcher = @import("stack.zig").StackSwitcher;
const Widget = @import("widget.zig").Widget;

const enums = @import("enums.zig");
const Orientation = enums.Orientation;
const PackType = enums.PackType;

/// The GtkBox widget arranges child widgets into a single row or column,
/// depending upon the value of its “orientation” property. Within the other
/// dimension, all children are allocated the same size. Of course, the “halign”
/// and “valign” properties can be used on the children to influence their
/// allocation.
///
/// GtkBox uses a notion of packing. Packing refers to adding widgets with
/// reference to a particular position in a GtkContainer. For a GtkBox, there
/// are two reference positions: the start and the end of the box. For a
/// vertical GtkBox, the start is defined as the top of the box and the end is
/// defined as the bottom. For a horizontal GtkBox the start is defined as the
/// left side and the end is defined as the right side.
///
/// Use repeated calls to gtk_box_pack_start() to pack widgets into a GtkBox
/// from start to end. Use gtk_box_pack_end() to add widgets from end to start.
/// You may intersperse these calls and add widgets from both ends of the same
/// GtkBox.
///
/// Because GtkBox is a GtkContainer, you may also use gtk_container_add() to
/// insert widgets into the box, and they will be packed with the default values
/// for expand and fill child properties. Use gtk_container_remove() to remove
/// widgets from the GtkBox.
///
/// Use gtk_box_set_homogeneous() to specify whether or not all children of the
/// GtkBox are forced to get the same amount of space.
///
/// Use gtk_box_set_spacing() to determine how much space will be minimally
/// placed between all children in the GtkBox. Note that spacing is added
/// between the children, while padding added by gtk_box_pack_start() or
/// gtk_box_pack_end() is added on either side of the widget it belongs to.
///
/// Use gtk_box_reorder_child() to move a GtkBox child to a different place in
/// the box.
///
/// Use gtk_box_set_child_packing() to reset the expand, fill and padding child
/// properties. Use gtk_box_query_child_packing() to query these fields.
/// ### CSS
/// GtkBox uses a single CSS node with name box.
///
/// In horizontal orientation, the nodes of the children are always arranged
/// from left to right. So :first-child will always select the leftmost child,
/// regardless of text direction.
pub const Box = struct {
    ptr: *c.GtkBox,

    const Self = @This();

    pub const Packing = struct {
        expand: bool,
        fill: bool,
        padding: c_uint,
        pack_type: PackType,
    };

    /// Creates a new GtkBox.
    pub fn new(orientation: Orientation, spacing: c_int) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkBox, c.gtk_box_new(@enumToInt(orientation), spacing)),
        };
    }

    /// Adds child to box , packed with reference to the start of box . The
    /// child is packed after any other child packed with reference to the start
    /// of box.
    pub fn pack_start(self: Self, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_start(self.ptr, widget.ptr, if (expand) 1 else 0, if (fill) 1 else 0, padding);
    }

    /// Adds child to box , packed with reference to the end of box. The child
    /// is packed after (away from end of) any other child packed with reference
    /// to the end of box.
    pub fn pack_end(self: Self, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_end(self.ptr, widget.ptr, if (expand) 1 else 0, if (fill) 1 else 0, padding);
    }

    /// Returns whether the box is homogeneous (all children are the same size).
    /// See gtk_box_set_homogeneous().
    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_box_get_homogeneous(self.ptr) == 1);
    }

    /// Sets the “homogeneous” property of box , controlling whether or not all
    /// children of box are given equal space in the box.
    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_box_set_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    /// Gets the value set by gtk_box_set_spacing().
    pub fn get_spacing(self: Self) c_int {
        return c.gtk_box_get_spacing(self.ptr);
    }

    /// Sets the “spacing” property of box , which is the number of pixels to
    /// place between children of box.
    pub fn set_spacing(self: Self, spacing: c_int) void {
        c.gtk_box_set_spacing(self.ptr, spacing);
    }

    /// Moves child to a new position in the list of box children. The list
    /// contains widgets packed GTK_PACK_START as well as widgets packed
    /// GTK_PACK_END, in the order that these widgets were added to box.
    ///
    /// A widget’s position in the box children list determines where the widget
    /// is packed into box . A child widget at some position in the list will be
    /// packed just after all other widgets of the same packing type that appear
    /// earlier in the list.
    pub fn reorder_child(self: Self, child: Widget, position: c_int) void {
        c.gtk_box_reorder_child(self.ptr, child.ptr, position);
    }

    /// Obtains information about how child is packed into box.
    pub fn query_child_packing(self: Self, child: Widget) Packing {
        var expand: c_int = undefined;
        var fill: c_int = undefined;
        var padding: c_uint = undefined;
        var pack_type: c.GtkPackType = undefined;
        c.gtk_box_query_packing(self.ptr, child.ptr, expand, fill, padding, pack_type);
        return Packing{
            .expand = (expand == 1),
            .fill = (fill == 1),
            .padding = padding,
            .pack_type = pack_type,
        };
    }

    /// Sets the way child is packed into box.
    pub fn set_child_packing(
        self: Self,
        child: Widget,
        expand: bool,
        fill: bool,
        padding: c_uint,
        pack_type: PackType,
    ) void {
        c.gtk_box_set_child_packing(
            self.ptr,
            child.ptr,
            if (expand) 1 else 0,
            if (fill) 1 else 0,
            padding,
            @enumToInt(pack_type),
        );
    }

    /// Gets the value set by gtk_box_set_baseline_position().
    pub fn get_baseline_position(self: Self) BaselinePosition {
        return @intToEnum(BaselinePosition, c.gtk_box_get_baseline_position(self.ptr));
    }

    /// Sets the baseline position of a box. This affects only horizontal boxes
    /// with at least one baseline aligned child. If there is more vertical
    /// space available than requested, and the baseline is not allocated by the
    /// parent then position is used to allocate the baseline wrt the extra
    /// space available.
    pub fn set_baseline_position(self: Self, pos: BaselinePosition) void {
        c.gtk_box_set_baseline_position(self.ptr, @enumToInt(pos));
    }

    pub fn get_center_widget(self: Self) Widget {
        return Widget{
            .ptr = c.gtk_box_get_center_widget(self.ptr),
        };
    }

    pub fn set_center_widget(self: Self, child: Widget) void {
        c.gtk_box_set_center_widget(self.ptr, child.ptr);
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
        return (gtype == c.gtk_box_get_type());
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_stack_switcher(self: Self) ?StackSwitcher {
        return if (self.isa(StackSwitcher)) StackSwitcher{ .ptr = @ptrCast(*c.GtkStackSwitcher, self.ptr) } else null;
    }
};
