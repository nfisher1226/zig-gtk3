const c = @import("cimport.zig");

const Button = @import("button.zig").Button;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Entry = struct {
    ptr: *c.GtkEntry,

    pub fn new() Entry {
        return Entry{
            .ptr = c.gtk_entry_new(),
        };
    }

    pub fn new_with_buffer(buffer: EntryBuffer) Entry {
        return Entry{
            .ptr = c.gtk_entry_new_with_buffer(buffer.ptr),
        };
    }

    pub fn get_buffer(self: Entry) EntryBuffer {
        return EntryBuffer{
            .ptr = c.gtk_entry_get_buffer(self.ptr),
        };
    }

    pub fn set_buffer(self: Entry, buffer: EntryBuffer) void {
        c.gtk_entry_set_buffer(self.ptr, buffer.ptr);
    }

    pub fn set_text(self: Entry, text: [:0]const u8) void {
        c.gtk_entry_set_text(self.ptr, text.ptr);
    }

    pub fn get_text(self: Entry, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_entry_get_text(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_text_length(self: Entry) u16 {
        return @as(u16, c.gtk_entry_get_text_length(self.ptr));
    }

    // not implemented get_text_area()

    pub fn set_visibility(self: Entry, visible: bool) void {
        c.gtk_entry_set_visibility(self.ptr, if (visible) 1 else 0);
    }

    // not implemented set_invisible_char()
    // not implemented unset_invisible_char()

    pub fn set_max_length(self: Entry, max: c_int) void {
        c.gtk_entry_set_max_length(self.ptr, max);
    }

    pub fn as_widget(self: Entry) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_entry_get_type());
    }
};

pub const EntryBuffer = struct {
    ptr: *c.GtkEntryBuffer,

    pub fn set_text(self: EntryBuffer, text: [:0]const u8, len: c_int) void {
        c.gtk_entry_buffer_set_text(self.ptr, text.ptr, len);
    }
};

pub const EntryCompletion = struct {
    ptr: *c.GtkEntryCompletion,
};
