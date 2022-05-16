const c = @import("cimport.zig");
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;

/// The GtkFixed widget is a container which can place child widgets at fixed
/// positions and with fixed sizes, given in pixels. GtkFixed performs no
/// automatic layout management.
///
/// For most applications, you should not use this container! It keeps you from
/// having to learn about the other GTK+ containers, but it results in broken
/// applications. With GtkFixed, the following things will result in truncated
/// text, overlapping widgets, and other display bugs:
/// * Themes, which may change widget sizes.
/// * Fonts other than the one you used to write the app will of course change the size of widgets containing text; keep in mind that users may use a larger font because of difficulty reading the default, or they may be using a different OS that provides different fonts.
/// * Translation of text into other languages changes its size. Also, display of non-English text will use a different font in many cases.
/// In addition, GtkFixed does not pay attention to text direction and thus may
/// produce unwanted results if your app is run under right-to-left languages
/// such as Hebrew or Arabic. That is: normally GTK+ will order containers
/// appropriately for the text direction, e.g. to put labels to the right of the
/// thing they label when using an RTL language, but it can’t do that with
/// GtkFixed. So if you need to reorder widgets depending on the text direction,
/// you would need to manually detect it and adjust child positions accordingly.
///
/// Finally, fixed positioning makes it kind of annoying to add/remove GUI
/// elements, since you have to reposition all the other elements. This is a
/// long-term maintenance problem for your application.
///
/// If you know none of these things are an issue for your application, and
/// prefer the simplicity of GtkFixed, by all means use the widget. But you
/// should be aware of the tradeoffs.
///
/// See also GtkLayout, which shares the ability to perform fixed positioning
/// of child widgets and additionally adds custom drawing and scrollability.
pub const Fixed = struct {
    ptr: *c.GtkFixed,

    const Self = @This();

    /// Creates a new GtkFixed.
    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkFixed, c.gtk_fixed_new()),
        };
    }

    /// Adds a widget to a GtkFixed container at the given position.
    pub fn put(self: Self, child: Widget, x: c_int, y: c_int) void {
        c.gtk_fixed_put(self.ptr, child.ptr, x, y);
    }

    /// Moves a child of a GtkFixed container to the given position.
    pub fn move(self: Self, child: Widget, x: c_int, y: c_int) void {
        c.gtk_fixed_move(self.ptr, child.ptr, x, y);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_fixed_get_type());
    }
};
