usingnamespace @import("cimport.zig");
usingnamespace @import("widget.zig");

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Label = struct {
    ptr: *GtkLabel,

    pub fn new(text: ?[:0]const u8) Label {
        return Label {
            .ptr = if (text) |t| @ptrCast(*GtkLabel, gtk_label_new(t)) else @ptrCast(*GtkLabel, gtk_label_new(null)),
        };
    }

    pub fn get_text(self: Label, allocator: *mem.Allocator) ?[:0]const u8 {
        const val = gtk_label_get_text(self.ptr);
        const len = mem.len(val);
        const text = fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch {
            return null;
        };
        return text;
    }

    pub fn set_text(self: Label, text: [:0]const u8) void {
        gtk_label_set_text(self.ptr, text);
    }

    pub fn as_widget(self: Label) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }
};

