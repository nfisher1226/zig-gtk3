usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("container.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");
usingnamespace @import("window.zig");

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Dialog = struct {
    ptr: *GtkDialog,

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_dialog_get_type());
    }
};

pub const AboutDialog = struct {
    ptr: *GtkAboutDialog,

    pub fn new() AboutDialog {
        return AboutDialog{
            .ptr = gtk_about_dialog_new(),
        };
    }

    pub fn get_program_name(self: AboutDialog, allocator: *mem.Allocator) ?[]const u8 {
        const val = gtk_about_dialog_get_program_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_program_name(self: AboutDialog, name: []const u8) void {
        gtk_about_dialog_set_program_name(self.ptr, name);
    }

    pub fn get_version(self: AboutDialog, allocator: *mem.Allocator) ?[]const u8 {
        const val = gtk_about_dialog_get_version(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_version(self: AboutDialog, version: []const u8) void {
        gtk_about_dialog_set_version(self.ptr, version);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_about_dialog_get_type());
    }
};
