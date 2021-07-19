usingnamespace @import("cimport.zig");
usingnamespace @import("adjustment.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("widget.zig");

const std = @import("std");
const mem = std.mem;

const BuilderError = error{
    ParseStringError,
    ParseFileError,
};

pub const Builder = struct {
    ptr: *GtkBuilder,

    pub fn new() Builder {
        return Builder{
            .ptr = gtk_builder_new(),
        };
    }

    pub fn add_from_string(self: Builder, string: []const u8) BuilderError!void {
        const len = mem.len(string);
        var ret = gtk_builder_add_from_string(self.ptr, string.ptr, len, @intToPtr([*c][*c]_GError, 0));
        if (ret == 0) {
            //return .ParseStringError;
        }
    }

    pub fn get_widget(self: Builder, string: [:0]const u8) ?Widget {
        if (builder_get_widget(self.ptr, string.ptr)) |w| {
            return Widget{
                .ptr = w,
            };
        } else return null;
    }

    pub fn get_adjustment(self: Builder, string: [:0]const u8) ?Adjustment {
        if (builder_get_adjustment(self.ptr, string.ptr)) |a| {
            return Adjustment{
                .ptr = a,
            };
        } else return null;
    }

    pub fn set_application(self: Builder, app: *GtkApplication) void {
        gtk_builder_set_application(self.ptr, app);
    }
};
