const std = @import("std");
const mem = std.mem;
const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig");
const Container = @import("container.zig").Container;
const SelectionMode = @import("enums.zig").SelectionMode;

const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

const FlowBox = struct {
    ptr: *c.GtkFlowBox,

    const Self = @This();

    pub fn new() Self {
        return Self{ .ptr = @ptrCast(*c.GtkFlowBox, c.gtk_flow_box_new()) };
    }

    pub fn insert(self: Self, child: Widget, pos: c_int) void {
        c.gtk_flow_box_insert(self.ptr, child.ptr, pos);
    }

    pub fn get_child_at_index(self: Self, idx: c_int) ?FlowBoxChild {
        return if (c.gtk_flow_box_get_child_at_index(self.ptr, idx)) |child|
            FlowBoxChild{ .ptr = child }
        else
            null;
    }

    pub fn get_child_at_pos(self: Self, x: c_int, y: c_int) ?FlowBoxChild {
        return if (c.gtk_flow_box_get_child_at_pos(self.ptr, x, y)) |child|
            FlowBoxChild{ .ptr = child }
        else
            null;
    }

    pub fn set_hadjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_flow_box_set_hadjustment(self.ptr, adjustment.ptr);
    }

    pub fn set_vadjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_flow_box_set_vadjustment(self.ptr, adjustment.ptr);
    }

    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_flow_box_set_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_flow_box_get_homogeneous(self.ptr) == 1);
    }

    pub fn set_row_spacing(self: Self, spacing: c_uint) void {
        c.gtk_flow_box_set_row_spacing(self.ptr, spacing);
    }

    pub fn get_row_spacing(self: Self) c_uint {
        return c.gtk_flow_box_get_row_spacing(self.ptr);
    }

    pub fn set_column_spacing(self: Self, spacing: c_uint) void {
        c.gtk_flow_box_set_column_spacing(self.ptr, spacing);
    }

    pub fn get_column_spacing(self: Self) c_uint {
        return c.gtk_flow_box_get_column_spacing(self.ptr);
    }

    pub fn set_min_children_per_line(self: Self, min: c_uint) void {
        c.gtk_flow_box_set_min_children_pre_line(self.ptr, min);
    }

    pub fn get_min_children_per_line(self: Self) c_uint {
        return c.gtk_flow_box_get_min_children_per_line(self.ptr);
    }

    pub fn set_max_children_per_line(self: Self, min: c_uint) void {
        c.gtk_flow_box_set_max_children_pre_line(self.ptr, min);
    }

    pub fn get_max_children_per_line(self: Self) c_uint {
        return c.gtk_flow_box_get_max_children_per_line(self.ptr);
    }

    pub fn set_activate_on_single_click(self: Self, single: bool) void {
        c.gtk_flow_box_set_activate_on_single_click(self.ptr, if (single) 1 else 0);
    }

    pub fn get_activate_on_single_click(self: Self) bool {
        return (c.gtk_flow_box_get_activate_on_single_click(self.ptr) == 1);
    }

    pub fn selected_foreach(self: Self, func: *c.GtkFlowBoxForeachFunc, data: ?c.gpointer) void {
        c.gtk_flow_box_selected_foreach(self.ptr, func, if (data) |d| d else null);
    }

    pub fn get_selected_children(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        var kids = c.gtk_flow_box_get_selected_children(self.ptr);
        defer c.g_list_free(kids);
        var list = std.ArrayList(Widget).init(allocator);
        while (kids) |ptr| {
            list.append(Widget{ .ptr = @ptrCast(*c.GtkWidget, @alignCast(8, ptr.*.data)) }) catch {
                list.deinit();
                return null;
            };
            kids = ptr.*.next;
        }
        return list;
    }

    pub fn select_child(self: Self, child: FlowBoxChild) void {
        c.gtk_flow_box_select_child(self.ptr, child.ptr);
    }

    pub fn unselect_child(self: Self, child: FlowBoxChild) void {
        c.gtk_flow_box_unselect_child(self.ptr, child.ptr);
    }

    pub fn select_all(self: Self) void {
        c.gtk_flow_box_select_all(self.ptr);
    }

    pub fn unselect_all(self: Self) void {
        c.gtk_flow_box_unselect_all(self.ptr);
    }

    pub fn set_selection_mode(self: Self, mode: SelectionMode) void {
        c.gtk_flow_box_swet_selection_mode(self.ptr, @enumToInt(mode));
    }

    pub fn get_selection_mode(self: Self) SelectionMode {
        return @intToEnum(SelectionMode, c.gtk_flow_box_get_selection_mode(self.ptr));
    }

    pub fn set_filter_func(
        self: Self,
        func: *c.GtkFlowBoxFilterFunc,
        data: ?c.gpointer,
        destroy: c.GDestroyNotify,
    ) void {
        c.gtk_flow_box_set_filter_func(self.ptr, func, if (data) |d| d else null, destroy);
    }

    pub fn invalidate_filter(self: Self) void {
        c.gtk_flow_box_invalidate_filter(self.ptr);
    }

    pub fn set_sort_func(
        self: Self,
        func: *c.GtkFlowBoxSortFunc,
        data: ?c.gpointer,
        destroy: c.GDestroyNotify,
    ) void {
        c.gtk_flow_box_set_sort_func(self.ptr, func, if (data) |d| d else null, destroy);
    }

    pub fn invalidate_sort(self: Self) void {
        c.gtk_flow_box_invalidate_sort(self.ptr);
    }

    pub fn bind_model(
        self: Self,
        model: *c.GListModel,
        func: *c.GtkFlowBoxCreateWidgetFunc,
        data: ?c.gpointer,
        free_func: c.GDestroyNotify,
    ) void {
        c.gtk_flow_box_bind_model(self.ptr, model, func, if (data) |d| d else null, free_func);
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
        return (gtype == c.gtk_flow_box_get_type());
    }
};

const FlowBoxChild = struct {
    ptr: *c.GtkFlowBoxChild,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkFlowBoxChild, c.gtk_flow_box_child_new()),
        };
    }

    pub fn get_index(self: Self) c_int {
        return c.gtk_flow_box_child_get_index(self.ptr);
    }

    pub fn is_selected(self: Self) bool {
        return (c.gtk_flow_box_child_is_selected(self.ptr) == 1);
    }

    pub fn changed(self: Self) void {
        c.gtk_flow_box_child_changed(self.ptr);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_flow_box_child_get_type());
    }
};
