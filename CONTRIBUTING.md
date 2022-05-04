# Contributing
Contents
========
* [Wrapping a Gtk+ class](#wrapping-a-gtk+-class)
  * [Naming](#naming)
  * [Required functions](#required-functions)
  * [Dealing with strings](#dealing-with-strings)
  * [Dealing with NULL](#dealing-with-null)
  * [Dealing with gboolean](#dealing-with-gboolean)
  * [Dealing with enums](#dealing-with-enums)
  * [Connecting signals](#connecting-signals)
* [Finishing up](#finishing-up)

## Wrapping a Gtk+ class
Each Gtk+ class, or widget, will have a corresponding Zig struct as a container
type. The only field in this struct will be `ptr`, which is as you probably
guessed the C style pointer to that object. This allows us to have proper
namespacing in our bindings and use method call syntax on the functions
associated with that class.

## Required functions
Assuming a hypothetical Gtk+ class `GtkMine`..
```Zig
    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_mine_get_type());
    }
```
The `is_instance` function just returns whether or not something is of this type.
For the curious, this function is called when attempting to cast from a `Widget`
base type to our class, using the highly generic function `isa` associated with
the `Widget` struct.
```Zig
    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }
```
The `as_widget` function allows casting our class to the `Widget` base class,
giving us access to all of the functions associated with that type. In addition
to the `Widget` class, our class will have one or more other parent classes that
it inherits from, such as `Box` or `Container`. For each parent class there should
be a corresponding `as_` function returning the parent type by returning it's
container struct with the `ptr` field being our `ptr` casted to the corresponding
Gtk+ pointer type.

> Note: `Self` here is usable because we've declared `const Self = @This()` inside
> our struct definition. You should follow suit.

## Dealing with strings
We're currently using a non-optimal approach to interacting with **C** strings
in that they get re-allocated into a **Zig**-freindly `[:0]const u8`, giving us
access to all of the awesome string manipulation and formatting features in
`std.mem` and `std.fmt`. This is actually quite common for a language binding to
a **C** library to re-allocate strings at the language barrier, and is done in
some other languages `Gtk+` bindings actually.

If a user wishes to squeeze every last drop of performance out of their application,
then this additional memory overhead might be undesireable. The beauty of
interacting with **C** libraries via **Zig** is that we always have the option of
falling back to using the **C** api directly. We can even do things like call
`strncat` or `strndup` from `libc`.

For the purposes of our bindings, however, any time we are translating a function
which returns a **C** string, we need to pass it an allocator and move it into
**Zig** properly. Here's an example from the `Headerbar` widget.
```Zig
    pub fn get_title(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_header_bar_get_title(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }
```
Passing strings into **C** functions is simpler, as the compiler can coerce the
array into the proper type for us.
```Zig
    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_header_bar_set_title(self.ptr, title);
    }
```
In either event, do *not* forget the null termination.

## Dealing with NULL
When reading the `gtk` api docs, you will often come across a function that might
return a value or `NULL`. A good example would be the `gtk_paned_get_child1`
function:
```C
GtkWidget *
gtk_paned_get_child1 (GtkPaned *paned);
```
If we look under the definition, to the **Returns** section, it reads:
**Returns**
first child, or NULL if it is not set.

Here's our wrapper function, using proper `null` ettiquette in **Zig**:
```Zig
    pub fn get_child1(self: Self) ?Widget {
        return if (c.gtk_paned_get_child1(self.ptr)) |child| Widget{
            .ptr = child,
        } else null;
    }
```
We're basically translating the concept of a pointer which might point to address
`0` in **C** to the concept of a **Zig** `optional`. Note that when going the
other way we have to do the same thing, if a **C** function takes a parameter *or*
`null`.
```Zig
// from widget.zig
    pub fn connect(self: Self, sig: [:0]const u8, callback: c.GCallback, data: ?c.gpointer) void {
        _ = signal_connect(self.ptr, sig, callback, if (data) |d| d else null);
    }
```

## Dealing with gboolean
A `gboolean` in Gtk+ is nothing more than a `c_int` having a value of `1`
corresponding to `true` and `0` corresponding to `false`. **Zig** has an actual
`bool` type, and we want to be able to pass that to our wrapped functions and
get a true `bool` as a return value. This is quite easy once you wrap your head
around it, but should be mostly hidden from the user of the library.
```Zig
// stack.zig
    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_stack_get_homeogeneous(self.ptr) == 1);
    }
```

## Dealing with enums

## Connecting signals

## Finishing up
