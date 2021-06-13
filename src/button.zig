usingnamespace @import("cimport.zig");
usingnamespace @cImport("enums.zig");
usingnamespace @import("widget.zig");

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Button = struct {
    ptr: *GtkButton,

    /// Creates a new Button
    pub fn new() Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, gtk_button_new()),
        };
    }

    /// Creates a Button with a GtkLabel containing the given text
    pub fn new_with_label(text: [:0]const u8) Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, gtk_button_new_with_label(text)),
        };
    }

    /// Creates a new Button containing a label. Underscores in label indicate the
    /// mnemonic for the button.
    pub fn new_with_mnemonic(text: [:0]const u8) Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, gtk_button_new_with_mnemonic(text)),
        };
    }

    /// Creates a new Button containing an icon from the current icon theme.
    pub fn new_from_icon_name(icon_name: [:0]const u8, size: IconSize) Button {
        const gsize = size.parse();
        return Button {
            .ptr = @ptrCast(*GtkButton, gtk_button_new_from_icon_name(icon_name, gsize),
        };
    }

    /// Get the ReliefStyle of the Button
    pub fn get_relief(self: Button) ReliefStyle {
        const rel = gtk_button_get_relief(self.ptr);
        return rel.parse();
    }

    /// Set the ReliefStyle of the Button
    pub fn set_relief(self: Button, style: ReliefStyle) void {
        const gstyle = style.parse();
        gtk_button_set_relief(self.ptr, gstyle);
    }

    /// Get the text from the label of the Button, or null if unset
    pub fn get_label(self: Button, allocator: *mem.Allocator) ?[:0]const u8 {
        if (gtk_button_get_label(self.ptr)) |l| {
            const len = mem.len(l);
            const text = fmt.allocPrintZ(allocator, "{s}", .{l[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    /// Set the text for the Button label
    pub fn set_label(self: Button, text: [:0]const u8) void {
        gtk_button_set_label(self.ptr, text);
    }

    /// Returns whether an embedded underline in the button label indicates a mnemonic.
    pub fn get_use_underline(self: Button) bool {
        const val = gtk_button_get_use_underline(self.ptr);
        ret: bool = if (val == 1) true else false;
        return ret;
    }

    /// If true, an underline in the text of the button label indicates the next
    /// character should be used for the mnemonic accelerator key.
    pub fn set_use_underline(self: Button, use: bool) void {
        gtk_button_set_use_underline(self.ptr, bool_to_c_int(use));
    }

    /// Returns true if clicking the Button causes it to receive focus
    pub fn get_focus_on_click(self: Button) bool {
        const gval = gtk_button_get_focus_on_click(self.ptr);
        const val = if (gval = 1) true else false;
        return val;
    }

    /// Set whether clicking a button causes it to receive focus
    pub fn set_focus_on_click(self: Button, foc: bool) void {
        const gfoc: c_int = if (foc) 1 else 0;
        gtk_button_set_focus_on_click(self.ptr, gfoc);
    }

    /// Returns an Widget struct representing the image which is currently set, or null
    pub fn get_image(self: Button) Widget {
        if (gtk_button_get_image(self.ptr);) |widget| {
            return Widget {
                .ptr = w,
            };
        } else return null;
    }

    /// Set the image of the button to the given widget. If image is null, unset the image.
    pub fn set_image(self: Button, image: ?Widget) void {
        if (image) |img| {
            gtk_button_set_image(self.ptr, img.ptr);
        } else {
            gtk_button_set_image(self.ptr, null);
        }
    }

    /// Casts the internal pointer to a GtkWidget and returns a Widget struct
    pub fn as_widget(self: Button) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    /// C
    pub fn connect_clicked(self: Button, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            self.as_widget().connect("clicked", callback, d);
        } else {
            self.as_widget().connect("clicked", callback, null);
        }
    }
};

pub const ToggleButton = struct {
    ptr: *GtkToggleButton,

    /// Creates a new ToggleButton. A widget should be packed into the button, as in button_new().
    pub fn new() ToggleButton {
        return ToggleButton {
            .ptr = @ptrCast(*GtkToggleButton, gtk_check_button_new()),
        };
    }

    /// Creates a new ToggleButton with a text label.
    pub fn new_with_label(text: [:0]const u8) ToggleButton {
        return ToggleButton {
            .ptr = @ptrCast(*GtkToggleButton, gtk_toggle_button_new_with_label(text)),
        };
    }

    /// Creates a new ToggleButton containing a label. Underscores in label indicate the
    /// mnemonic for the button.
    pub fn new_with_mnemonic(text: [:0]const u8) ToggleButton {
        return ToggleButton {
            .ptr = @ptrCast(*GtkToggleButton, gtk_toggle_button_new_with_mnemonic(text)),
        };
    }

    /// Retrieves whether the button is displayed as a separate indicator and label.
    pub fn get_mode(self: ToggleButton) bool {
        const val = if (gtk_toggle_button_get_mode(self.ptr) == 1) true else false;
        return val;
    }

    /// Sets whether the button is displayed as a separate indicator and label.
    pub fn set_mode(self: ToggleButton, mode: bool) void {
        gtk_toggle_button_set_mode(self.ptr, bool_to_c_int(mode));
    }

    /// Casts the internal pointer to a GtkButton and returns a Button struct
    pub fn as_button(self: ToggleButton) Button {
        return Button {
            .ptr = @ptrCast(*GtkButton, self.ptr),
        };
    }

    /// Queries a GtkToggleButton and returns its current state.
    /// Returns true if the toggle button is pressed in and false if it is raised.
    pub fn get_active(self: ToggleButton) bool {
        const val = if (gtk_toggle_button_get_active(self.ptr) == 1) true else false;
        return val;
    }

    /// Sets the status of the toggle button.
    /// This action causes the “toggled” signal and the “clicked” signal to be emitted.
    pub fn set_active(self: ToggleButton, state: bool) void {
        toggle_button_set_active(self.ptr, bool_to_c_int(state));
    }

    /// Casts the internal pointer to a GtkWidget and returns a Widget struct
    pub fn as_widget(self: ToggleButton) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    /// Connects a callback function when the "toggled" signal is emitted
    pub fn connect_toggled(self: ToggleButton, callback: GCallback, data: ?gpointer) void {
        if (data) |d| {
            self.as_widget().connect("toggled", callback, d);
        } else {
            self.as_widget().connect("toggled", callback, null);
        }
    }
};
