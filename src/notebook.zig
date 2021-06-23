usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Notebook = struct {
    ptr: *GtkNotebook,

    pub fn new() Notebook {
        return Notebook{
            .ptr = gtk_notebook_new(),
        };
    }

    pub fn append_page(self: Notebook, child: Widget, label: Widget) void {
        gtk_notebook_append_page(self.ptr, child.ptr, label.ptr);
    }

    pub fn append_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        gtk_notebook_append_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn prepend_page(self: Notebook, child: Widget, label: Widget) void {
        gtk_notebook_prepend_page(self.ptr, child.ptr, label.ptr);
    }

    pub fn prepend_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        gtk_notebook_prepend_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn insert_page(self: Notebook, child: Widget, label: Widget, pos: c_int) void {
        gtk_notebook_insert_page(self.ptr, child.ptr, label.ptr, pos);
    }

    pub fn inset_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        gtk_notebook_insert_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn remove_page(self: Notebook, pnum: c_int) void {
        gtk_notebook_remove_page(self.ptr, pnum);
    }

    pub fn detach_tab(self: Notebook, child: Widget) void {
        gtk_notebook_detach_tab(self.ptr, child.ptr);
    }

    pub fn page_num(self: Notebook, child: Widget) ?c_int {
        const val = gtk_notebook_page_num(self.ptr, child.ptr);
        return if (val == -1) null else val;
    }

    pub fn next_page(self: Notebook) void {
        gtk_notebook_next_page(self.ptr);
    }

    pub fn prev_page(self: Notebook) void {
        gtk_notebook_prev_page(self.ptr);
    }

    pub fn reorder_child(self.notebook, child: Widget, pos: c_int) void {
        gtk_notebook_reorder_child(self.ptr, child.ptr, pos);
    }

    pub fn set_tab_pos(self: Notebook, pos: PositionType) void {
        gtk_notebook_set_tab_pos(self.ptr, pos.parse());
    }

    pub fn set_show_tabs(self: Notebook, show: bool) void {
        gtk_notebook_set_show_tabs(self.ptr, bool_to_c_int(show));
    }

    pub fn set_show_border(self: Notebook, show: bool) void {
        gtk_notebook_set_show_border(self.ptr, bool_to_c_int(show));
    }

    pub fn set_scrollable(self: Notebook, scrollable: bool) void {
        gtk_notebook_set_scrollable(self.ptr, bool_to_c_int(scrollable));
    }

    pub fn popup_enable(self: Notebook) void {
        gtk_notebook_popup_enable(self.ptr);
    }

    pub fn popup_disable(self: Notebook) void {
        gtk_notebook_popup_disable(self.ptr);
    }

    pub fn get_current_page(self: Notebook) c_int {
        return gtk_notebook_get_current_page(self.ptr);
    }

    pub fn get_menu_label(self: Notebook, child: Widget) ?Widget {
        const child_ptr = gtk_notebook_get_menu_label(self.ptr, child.ptr);
        return if (child_ptr) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn get_nth_page(self: Notebook, num: c_int) ?Widget {
        const val = gtk_notebook_get_nth_page(self.ptr, num);
        return if (val) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn get_n_pages(self: Notebook) c_int {
        return gtk_notebook_get_n_pages(self.ptr);
    }

    pub fn get_tab_label(self: Notebook, child: Widget) ?Widget {
        const val = gtk_notebook_get_tab_label(self.ptr, child.ptr);
        return if (val) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn set_menu_label(self: Notebook, child: Widget, label: ?Widget) void {
        gtk_notebook_set_menu_label(self.ptr, child.ptr, if (label) |l| l.ptr else null);
    }

    pub fn set_menu_label_text(self: Notebook, child: Widget, text: [:0]const u8) void {
        gtk_notebook_set_menu_label_text(self.ptr, child.ptr, text);
    }

    pub fn set_tab_label(self: Notebook, child: Widget, label: ?Widget) void {
        gtk_notebook_set_tab_label(self.ptr, child.ptr, if (label) |l| l.ptr else null);
    }

    pub fn set_tab_label_text(self: Notebook, child: Widget, text: [:0]const u8) void {
        gtk_notebook_set_tab_label_text(self.ptr, child.ptr, text);
    }

    pub fn set_tab_reorderable(self: Notebook, child: Widget, reorderable: bool) void {
        gtk_notebook_set_tab_reorderable(self.ptr, child.ptr, bool_to_c_int(reorderable));
    }

    pub fn set_tab_detachable(self: Notebook, child: Widget, detachable: bool) void {
        gtk_notebook_set_tab_detachable(self.ptr, child.ptr, bool_to_c_int(detachable));
    }

    pub fn get_menu_label_text(self: Notebook, allocator: *mem.Allocator, child: Widget) ?[:0]const u8 {
        const val = gtk_notebook_get_menu_label_text(self.ptr, child.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_scrollable(self: Notebook) bool {
        return if (gtk_notebook_get_scrollable(self.ptr) == 1) true else false;
    }

    pub fn get_show_border(self: Notebook) bool {
        return if (gtk_notebook_get_show_border(self.ptr) == 1) true else false;
    }

    pub fn get_show_tabs(self: Notebook) bool {
        return if (gtk_notebook_get_show_tabs(self.ptr) == 1) true else false;
    }

    pub fn get_tab_label_text(self, Notebook, allocator: *mem.Allocator, child: Widget) ?[:0]const u8 {
        const val = gtk_notebook_get_tab_label_text(self.ptr, child.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_tab_pos(self: Notebook) PositionType {
        const pos = gtk_notebook_get_tab_pos(self.ptr);
        switch (pos) {
            pos_left => return .left,
            pos_right => return .right,
            pos_top => return .top,
            pos_bottom => return .bottom,
        }
    }

    pub fn get_tab_reorderable(self: Notebook, child: Widget) bool {
        return if (gtk_notebook_get_tab_reorderable(self.ptr, child.ptr) == 1) true else false;
    }

    pub fn get_tab_detachable(self: Notebook, child: Widget) bool {
        return if (gtk_notebook_get_tab_detachable(self.ptr, child.ptr) == 1) true else false;
    }

    pub fn set_current_page(self: Notebook, num: c_int) void {
        gtk_notebook_set_current_page(self.ptr, num);
    }

    pub fn set_group_name(self: Notebook, name: [:0]const u8) void {
        gtk_notebook_set_group_name(self.ptr, name);
    }

    pub fn get_group_name(self: Notebook, allocator: *mem.Allocator) ?[:0]const u8 {
        const val = gtk_notebook_get_group_name(self.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn set_action_widget(self: Notebook, widget: Widget, packtype: PackType) void {
        gtk_notebook_set_action_widget(self.ptr, widget.ptr, packtype.parse());
    }

    pub fn get_action_widget(self: Notebook, packtype: PackType) ?Widget {
        const val = gtk_notebook_get_action_widget(self.ptr, widget.ptr, packtype.parse());
        return if (val) |v| Widget{ .ptr = v } else null;
    }

    pub fn as_container(self: Notebook) Container {
        return Container{
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Notebook) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};
usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Notebook = struct {
    ptr: *GtkNotebook,

    pub fn new() Notebook {
        return Notebook{
            .ptr = gtk_notebook_new(),
        };
    }

    pub fn append_page(self: Notebook, child: Widget, label: Widget) void {
        gtk_notebook_append_page(self.ptr, child.ptr, label.ptr);
    }

    pub fn append_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        gtk_notebook_append_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn prepend_page(self: Notebook, child: Widget, label: Widget) void {
        gtk_notebook_prepend_page(self.ptr, child.ptr, label.ptr);
    }

    pub fn prepend_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        gtk_notebook_prepend_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn insert_page(self: Notebook, child: Widget, label: Widget, pos: c_int) void {
        gtk_notebook_insert_page(self.ptr, child.ptr, label.ptr, pos);
    }

    pub fn inset_page_menu(self: Notebook, child: Widget, tab_label: Widget, menu_label: Widget) void {
        gtk_notebook_insert_page_menu(self.ptr, child.ptr, tab_label.ptr, menu_label.ptr);
    }

    pub fn remove_page(self: Notebook, pnum: c_int) void {
        gtk_notebook_remove_page(self.ptr, pnum);
    }

    pub fn detach_tab(self: Notebook, child: Widget) void {
        gtk_notebook_detach_tab(self.ptr, child.ptr);
    }

    pub fn page_num(self: Notebook, child: Widget) ?c_int {
        const val = gtk_notebook_page_num(self.ptr, child.ptr);
        return if (val == -1) null else val;
    }

    pub fn next_page(self: Notebook) void {
        gtk_notebook_next_page(self.ptr);
    }

    pub fn prev_page(self: Notebook) void {
        gtk_notebook_prev_page(self.ptr);
    }

    pub fn reorder_child(self.notebook, child: Widget, pos: c_int) void {
        gtk_notebook_reorder_child(self.ptr, child.ptr, pos);
    }

    pub fn set_tab_pos(self: Notebook, pos: PositionType) void {
        gtk_notebook_set_tab_pos(self.ptr, pos.parse());
    }

    pub fn set_show_tabs(self: Notebook, show: bool) void {
        gtk_notebook_set_show_tabs(self.ptr, bool_to_c_int(show));
    }

    pub fn set_show_border(self: Notebook, show: bool) void {
        gtk_notebook_set_show_border(self.ptr, bool_to_c_int(show));
    }

    pub fn set_scrollable(self: Notebook, scrollable: bool) void {
        gtk_notebook_set_scrollable(self.ptr, bool_to_c_int(scrollable));
    }

    pub fn popup_enable(self: Notebook) void {
        gtk_notebook_popup_enable(self.ptr);
    }

    pub fn popup_disable(self: Notebook) void {
        gtk_notebook_popup_disable(self.ptr);
    }

    pub fn get_current_page(self: Notebook) c_int {
        return gtk_notebook_get_current_page(self.ptr);
    }

    pub fn get_menu_label(self: Notebook, child: Widget) ?Widget {
        const child_ptr = gtk_notebook_get_menu_label(self.ptr, child.ptr);
        return if (child_ptr) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn get_nth_page(self: Notebook, num: c_int) ?Widget {
        const val = gtk_notebook_get_nth_page(self.ptr, num);
        return if (val) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn get_n_pages(self: Notebook) c_int {
        return gtk_notebook_get_n_pages(self.ptr);
    }

    pub fn get_tab_label(self: Notebook, child: Widget) ?Widget {
        const val = gtk_notebook_get_tab_label(self.ptr, child.ptr);
        return if (val) |p| Widget{
            .ptr = p,
        } else null;
    }

    pub fn set_menu_label(self: Notebook, child: Widget, label: ?Widget) void {
        gtk_notebook_set_menu_label(self.ptr, child.ptr, if (label) |l| l.ptr else null);
    }

    pub fn set_menu_label_text(self: Notebook, child: Widget, text: [:0]const u8) void {
        gtk_notebook_set_menu_label_text(self.ptr, child.ptr, text);
    }

    pub fn set_tab_label(self: Notebook, child: Widget, label: ?Widget) void {
        gtk_notebook_set_tab_label(self.ptr, child.ptr, if (label) |l| l.ptr else null);
    }

    pub fn set_tab_label_text(self: Notebook, child: Widget, text: [:0]const u8) void {
        gtk_notebook_set_tab_label_text(self.ptr, child.ptr, text);
    }

    pub fn set_tab_reorderable(self: Notebook, child: Widget, reorderable: bool) void {
        gtk_notebook_set_tab_reorderable(self.ptr, child.ptr, bool_to_c_int(reorderable));
    }

    pub fn set_tab_detachable(self: Notebook, child: Widget, detachable: bool) void {
        gtk_notebook_set_tab_detachable(self.ptr, child.ptr, bool_to_c_int(detachable));
    }

    pub fn get_menu_label_text(self: Notebook, allocator: *mem.Allocator, child: Widget) ?[:0]const u8 {
        const val = gtk_notebook_get_menu_label_text(self.ptr, child.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_scrollable(self: Notebook) bool {
        return if (gtk_notebook_get_scrollable(self.ptr) == 1) true else false;
    }

    pub fn get_show_border(self: Notebook) bool {
        return if (gtk_notebook_get_show_border(self.ptr) == 1) true else false;
    }

    pub fn get_show_tabs(self: Notebook) bool {
        return if (gtk_notebook_get_show_tabs(self.ptr) == 1) true else false;
    }

    pub fn get_tab_label_text(self, Notebook, allocator: *mem.Allocator, child: Widget) ?[:0]const u8 {
        const val = gtk_notebook_get_tab_label_text(self.ptr, child.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_tab_pos(self: Notebook) PositionType {
        const pos = gtk_notebook_get_tab_pos(self.ptr);
        switch (pos) {
            pos_left => return .left,
            pos_right => return .right,
            pos_top => return .top,
            pos_bottom => return .bottom,
        }
    }

    pub fn get_tab_reorderable(self: Notebook, child: Widget) bool {
        return if (gtk_notebook_get_tab_reorderable(self.ptr, child.ptr) == 1) true else false;
    }

    pub fn get_tab_detachable(self: Notebook, child: Widget) bool {
        return if (gtk_notebook_get_tab_detachable(self.ptr, child.ptr) == 1) true else false;
    }

    pub fn set_current_page(self: Notebook, num: c_int) void {
        gtk_notebook_set_current_page(self.ptr, num);
    }

    pub fn set_group_name(self: Notebook, name: [:0]const u8) void {
        gtk_notebook_set_group_name(self.ptr, name);
    }

    pub fn get_group_name(self: Notebook, allocator: *mem.Allocator) ?[:0]const u8 {
        const val = gtk_notebook_get_group_name(self.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn set_action_widget(self: Notebook, widget: Widget, packtype: PackType) void {
        gtk_notebook_set_action_widget(self.ptr, widget.ptr, packtype.parse());
    }

    pub fn get_action_widget(self: Notebook, packtype: PackType) ?Widget {
        const ptr = gtk_notebook_get_action_widget(self.ptr, widget.ptr, packtype.parse());
        return if (ptr) |p| Widget{ .ptr = p } else null;
    }

    pub fn as_container(self: Notebook) Container {
        return Container{
            .ptr = @ptrCast(*GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Notebook) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};
