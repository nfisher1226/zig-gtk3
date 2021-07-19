usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("container.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");
usingnamespace @import("window.zig");

pub const Dialog = struct {
    ptr: *GtkDialog,

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_dialog_get_type());
    }
};
