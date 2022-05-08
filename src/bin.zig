const c = @import("cimport.zig");
const Button = @import("button.zig").Button;
const Expander = @import("expander.zig").Expander;
const Widget = @import("widget.zig").Widget;

const std = @import("std");

pub const Bin = struct {
    ptr: *c.GtkBin,

    const Self = @This();

    pub fn get_child(self: Self) ?Widget {
        return if (c.gtk_bin_get_child(self.ptr)) |ch| Widget{
            .ptr = ch,
        } else null;
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_bin_get_type());
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_button(self: Self) ?Button {
        return if (self.isa(Button)) Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        } else null;
    }

    pub fn to_expander(self: Self) ?Expander {
        return if (self.isa(Expander)) Expander{
            .ptr = @ptrCast(*c.GtkExpander, self.ptr),
        } else null;
    }
};
