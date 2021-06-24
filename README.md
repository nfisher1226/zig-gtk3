# zig-gtk3
Originally part of Zterm, this has been forked off and expanded to add more
convenience in using Gtk+ from [Zig](https://ziglang.org).

## Basic syntax
```Zig
usingnamespace @import("path_to_package/lib.zig");

pub fn init_gui() void {
    const label = gtk.Label.new("Hello, World!");
    const vbox = gtk.Box.new(.horizontal, 3);
    vbox.pack_start(label.as_widget(), true true, 2); 
    const window = gtk.Window.new();
    window.as_container().add(vbox.as_widget());
    window.as_widget().show_all();
}
```
## Conventions
For the parts of Gtk+ that are currently implemented, each widget type
is mapped to a Zig struct which includes the widget pointer as it's sole
item. Gtk functions which act upon the widget will be mapped to methods
upon this struct. For instance, `gtk_box_new()` maps to `gtk.Box.new()`
going from C to Zig.

We try to map C boolean types to actual Zig booleans wherever possible
in both function parameters and return types.

Gtk+ often uses optional parameters, where a value can be given as null
or a return value might be null. These are mapped to Zig's optional
types, ie `?value`.

For many Gtk enum types, we provide equivalent Zig enums which will be
mapped to the original Gtk enums for you. In the example above, when we
create the `vbox` widget, `.horizontal` is a member of the Zig enum
`Orientation`, and will be converted to
`GtkOrientation.GTK_ORIENTATION_HORIZONTAL`.

Each widget type that is implemented will have the following functions:
 * `as_widget()` - casts the pointer to a GtkWidget and returns a Widget struct
 * `is_instance()` - returns whether the given Widget is a valid instance of this type
 * `as_[some_other_type]` - intermediate classes between this type and the base Widget type
