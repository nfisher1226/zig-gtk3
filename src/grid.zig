usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Grid = struct {
    ptr: *GtkGrid,

    pub fn new() Grid {
        return Grid{
            .ptr = gtk_grid_new(),
        };
    }

    pub fn attach(self: Grid, child: Widget, left: c_int, top: c_int, width: c_int, height: c_int) void {
        gtk_grid_attach(self.ptr, child.ptr, left, top, width, height);
    }

    pub fn attach_next_to(
        self: Grid,
        child: Widget,
        sibling: Widget,
        side: PositionType,
        width: c_int,
        height: c_int) void {
        gtk_grid_attach_next_to(self.ptr, child.ptr, sibling.ptr, side.parse(), width, height);
    }

    pub fn get_child_at(self: Grid, left: c_int, top: c_int) ?Widget {
        const val = gtk_grid_get_child_at(self.ptr, left, top);
        return if (val) |v| Widget{ .ptr = v, } else null;
    }

    pub fn insert_row(self: Grid, position: c_int) void {
        gtk_grid_insert_row(self.ptr, position);
    }

    pub fn insert_column(self: Grid, position: c_int) void {
        gtk_grid_insert_column(self.ptr, position);
    }

    pub fn remove_row(self: Grid, position: c_int) void {
        gtk_grid_remove_row(self.ptr, position);
    }

    pub fn remove_column(self: Grid, position: c_int) void {
        gtk_grid_remove_column(self.ptr, position);
    }
};
