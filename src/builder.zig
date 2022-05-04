const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig").Adjustment;
const common = @import("common.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const mem = std.mem;

const BuilderError = error{
    ParseStringError,
    ParseFileError,
};

pub const Builder = struct {
    ptr: *c.GtkBuilder,

    pub fn new() Builder {
        return Builder{
            .ptr = c.gtk_builder_new(),
        };
    }

    pub fn add_from_string(self: Builder, string: []const u8) BuilderError!void {
        const len = mem.len(string);
        var ret = c.gtk_builder_add_from_string(self.ptr, string.ptr, len, @intToPtr([*c][*c]c._GError, 0));
        if (ret == 0) {
            //return .ParseStringError;
        }
    }

    pub fn get_widget(self: Builder, string: [:0]const u8) ?Widget {
        if (common.builder_get_widget(self.ptr, string.ptr)) |w| {
            return Widget{
                .ptr = w,
            };
        } else return null;
    }

    pub fn get_adjustment(self: Builder, string: [:0]const u8) ?Adjustment {
        if (common.builder_get_adjustment(self.ptr, string.ptr)) |a| {
            return Adjustment{
                .ptr = a,
            };
        } else return null;
    }

    pub fn set_application(self: Builder, app: *c.GtkApplication) void {
        c.gtk_builder_set_application(self.ptr, app);
    }
};
