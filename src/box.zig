const c = @import("cimport.zig");
const Container = @import("container.zig").Container;
const enums = @import("enums.zig");
const BaselinePosition = enums.BaselinePosition;
const Orientation = enums.Orientation;
const PackType = enums.PackType;
const StackSwitcher = @import("stack.zig").StackSwitcher;

const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

pub const Box = struct {
    ptr: *c.GtkBox,

    const Self = @This();

    pub const Packing = struct {
        expand: bool,
        fill: bool,
        padding: c_uint,
        pack_type: PackType,
    };

    pub fn new(orientation: Orientation, spacing: c_int) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkBox, c.gtk_box_new(@enumToInt(orientation), spacing)),
        };
    }

    pub fn pack_start(self: Self, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_start(self.ptr, widget.ptr, if (expand) 1 else 0, if (fill) 1 else 0, padding);
    }

    pub fn pack_end(self: Self, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_end(self.ptr, widget.ptr, if (expand) 1 else 0, if (fill) 1 else 0, padding);
    }

    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_box_get_homogeneous(self.ptr) == 1);
    }

    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_box_set_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_spacing(self: Self) c_int {
        return c.gtk_box_get_spacing(self.ptr);
    }

    pub fn set_spacing(self: Self, spacing: c_int) void {
        c.gtk_box_set_spacing(self.ptr, spacing);
    }

    pub fn reorder_child(self: Self, child: Widget, position: c_int) void {
        c.gtk_box_reorder_child(self.ptr, child.ptr, position);
    }

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

    pub fn get_baseline_position(self: Self) BaselinePosition {
        return c.gtk_box_get_baseline_position(self.ptr);
    }

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

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
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
        return (gtype == c.gtk_box_get_type());
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_stack_switcher(self: Self) ?StackSwitcher {
        return if (self.isa(StackSwitcher)) StackSwitcher{ .ptr = @ptrCast(*c.GtkStackSwitcher, self.ptr) } else null;
    }
};
