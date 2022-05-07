const c = @import("cimport.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const FileFilter = struct {
    ptr: *c.GtkFileFilter,

    const Self = @This();

    pub const Flags = enum(c_uint) {
        filename = c.GTK_FILE_FILTER_FILENAME,
        uri = c.GTK_FILE_FILTER_URI,
        display_name = c.GTK_FILE_FILTER_DISPLAY_NAME,
        mime_type = c.GTK_FILE_FILTER_MIME_TYPE,
    };

    pub fn new() Self {
        return Self{ .ptr = c.gtk_file_filter_new() };
    }

    pub fn set_name(self: Self, name: [:0]const u8) void {
        c.gtk_file_filter_set_name(self.ptr, name);
    }

    pub fn get_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_filter_get_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn add_mime_type(self: Self, mime: [:0]const u8) void {
        c.gtk_file_filter_add_mime_type(self.ptr, mime);
    }

    pub fn add_pattern(self: Self, pattern: [:0]const u8) void {
        c.gtk_file_filter_add_pattern(self.ptr, pattern);
    }

    pub fn add_pixbuf_formats(self: Self) void {
        c.gtk_file_filter_add_pixbuf_formats(self.ptr);
    }

    pub fn add_custom(self: Self, needed: Flags, func: c.GtkFileFilterFunc, data: c.gpointer, notify: c.GDestroyNotify) void {
        c.gtk_file_filter_add_custom(self.ptr, @enumToInt(needed), func, data, notify);
    }

    pub fn get_needed(self: Self) Flags {
        return c.gtk_file_filter_get_needed(self.ptr);
    }
};
