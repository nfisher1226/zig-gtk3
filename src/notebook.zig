const c = @import("cimport.zig");
const Container = @import("container.zig").Container;
const enums = @import("enums.zig");
const PackType = enums.PackType;
const PositionType = enums.PositionType;
const Widget = @import("widget.zig").Widget;

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Notebook = struct {
    ptr: *c.GtkNotebook,

    pub fn new() Notebook {
        return Notebook{
            .ptr = c.gtk_notebook_new(),
        };
    }

    pub fn append_page(self: Notebook, child: Widget, label: Widget) void {
        _ = c.gtk_notebook_append_page(self.ptr, child.ptr, label.ptr);
    }

    pub fn append_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        _ = c.gtk_notebook_append_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn prepend_page(self: Notebook, child: Widget, label: Widget) void {
        _ = c.gtk_notebook_prepend_page(self.ptr, child.ptr, label.ptr);
    }

    pub fn prepend_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        _ = c.gtk_notebook_prepend_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn insert_page(self: Notebook, child: Widget, label: Widget, pos: c_int) void {
        _ = c.gtk_notebook_insert_page(self.ptr, child.ptr, label.ptr, pos);
    }

    pub fn inset_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        _ = c.gtk_notebook_insert_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn remove_page(self: Notebook, pnum: c_int) void {
        _ = c.gtk_notebook_remove_page(self.ptr, pnum);
    }

    pub fn detach_tab(self: Notebook, child: Widget) void {
        _ = c.gtk_notebook_detach_tab(self.ptr, child.ptr);
    }

    pub fn page_num(self: Notebook, child: Widget) ?c_int {
        const val = c.gtk_notebook_page_num(self.ptr, child.ptr);
        return if (val == -1) null else val;
    }

    pub fn next_page(self: Notebook) void {
        c.gtk_notebook_next_page(self.ptr);
    }

    pub fn prev_page(self: Notebook) void {
        c.gtk_notebook_prev_page(self.ptr);
    }

    pub fn reorder_child(self: Notebook, child: Widget, pos: c_int) void {
        c.gtk_notebook_reorder_child(self.ptr, child.ptr, pos);
    }

    pub fn set_tab_pos(self: Notebook, pos: PositionType) void {
        c.gtk_notebook_set_tab_pos(self.ptr, @enumToInt(pos));
    }

    pub fn set_show_tabs(self: Notebook, show: bool) void {
        c.gtk_notebook_set_show_tabs(self.ptr, if (show) 1 else 0);
    }

    pub fn set_show_border(self: Notebook, show: bool) void {
        c.gtk_notebook_set_show_border(self.ptr, if (show) 1 else 0);
    }

    pub fn set_scrollable(self: Notebook, scrollable: bool) void {
        c.gtk_notebook_set_scrollable(self.ptr, if (scrollable) 1 else 0);
    }

    pub fn popup_enable(self: Notebook) void {
        c.gtk_notebook_popup_enable(self.ptr);
    }

    pub fn popup_disable(self: Notebook) void {
        c.gtk_notebook_popup_disable(self.ptr);
    }

    pub fn get_current_page(self: Notebook) c_int {
        return c.gtk_notebook_get_current_page(self.ptr);
    }

    pub fn get_menu_label(self: Notebook, child: Widget) ?Widget {
        return if (c.gtk_notebook_get_menu_label(self.ptr, child.ptr)) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn get_nth_page(self: Notebook, num: c_int) ?Widget {
        return if (c.gtk_notebook_get_nth_page(self.ptr, num)) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn get_n_pages(self: Notebook) c_int {
        return c.gtk_notebook_get_n_pages(self.ptr);
    }

    pub fn get_tab_label(self: Notebook, child: Widget) ?Widget {
        return if (c.gtk_notebook_get_tab_label(self.ptr, child.ptr)) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn set_menu_label(self: Notebook, child: Widget, label: ?Widget) void {
        c.gtk_notebook_set_menu_label(self.ptr, child.ptr, if (label) |l| l.ptr else null);
    }

    pub fn set_menu_label_text(self: Notebook, child: Widget, text: [:0]const u8) void {
        c.gtk_notebook_set_menu_label_text(self.ptr, child.ptr, text);
    }

    pub fn set_tab_label(self: Notebook, child: Widget, label: ?Widget) void {
        c.gtk_notebook_set_tab_label(self.ptr, child.ptr, if (label) |l| l.ptr else null);
    }

    pub fn set_tab_label_text(self: Notebook, child: Widget, text: [:0]const u8) void {
        c.gtk_notebook_set_tab_label_text(self.ptr, child.ptr, text);
    }

    pub fn set_tab_reorderable(self: Notebook, child: Widget, reorderable: bool) void {
        c.gtk_notebook_set_tab_reorderable(self.ptr, child.ptr, if (reorderable) 1 else 0);
    }

    pub fn set_tab_detachable(self: Notebook, child: Widget, detachable: bool) void {
        c.gtk_notebook_set_tab_detachable(self.ptr, child.ptr, if (detachable) 1 else 0);
    }

    pub fn get_menu_label_text(self: Notebook, allocator: mem.Allocator, child: Widget) ?[:0]const u8 {
        if (c.gtk_notebook_get_menu_label_text(self.ptr, child.ptr)) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_scrollable(self: Notebook) bool {
        return (c.gtk_notebook_get_scrollable(self.ptr) == 1);
    }

    pub fn get_show_border(self: Notebook) bool {
        return (c.gtk_notebook_get_show_border(self.ptr) == 1);
    }

    pub fn get_show_tabs(self: Notebook) bool {
        return (c.gtk_notebook_get_show_tabs(self.ptr) == 1);
    }

    pub fn get_tab_label_text(self: Notebook, allocator: mem.Allocator, child: Widget) ?[:0]const u8 {
        if (c.gtk_notebook_get_tab_label_text(self.ptr, child.ptr)) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_tab_pos(self: Notebook) PositionType {
        return switch (c.gtk_notebook_get_tab_pos(self.ptr)) {
            c.GTK_POS_LEFT => .left,
            c.GTK_POS_RIGHT => .right,
            c.GTK_POS_TOP => .top,
            c.GTK_POS_BOTTOM => .bottom,
            else => unreachable,
        };
    }

    pub fn get_tab_reorderable(self: Notebook, child: Widget) bool {
        return (c.gtk_notebook_get_tab_reorderable(self.ptr, child.ptr) == 1);
    }

    pub fn get_tab_detachable(self: Notebook, child: Widget) bool {
        return (c.gtk_notebook_get_tab_detachable(self.ptr, child.ptr) == 1);
    }

    pub fn set_current_page(self: Notebook, num: c_int) void {
        c.gtk_notebook_set_current_page(self.ptr, num);
    }

    pub fn set_group_name(self: Notebook, name: [:0]const u8) void {
        c.gtk_notebook_set_group_name(self.ptr, name);
    }

    pub fn get_group_name(self: Notebook, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_notebook_get_group_name(self.ptr)) |v| {
            const len = mem.len(v);
            return fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn set_action_widget(self: Notebook, widget: Widget, packtype: PackType) void {
        c.gtk_notebook_set_action_widget(self.ptr, widget.ptr, @enumToInt(packtype));
    }

    pub fn get_action_widget(self: Notebook, packtype: PackType) ?Widget {
        return if (c.gtk_notebook_get_action_widget(self.ptr, @enumToInt(packtype))) |v| Widget{ .ptr = v } else null;
    }

    pub fn connect_page_added(self: Notebook, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("page-added", callback, if (data) |d| d else null);
    }

    pub fn connect_page_removed(self: Notebook, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("page-removed", callback, if (data) |d| d else null);
    }

    pub fn connect_select_page(self: Notebook, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("select-page", callback, if (data) |d| d else null);
    }

    pub fn as_container(self: Notebook) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Notebook) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_notebook_get_type());
    }
};
