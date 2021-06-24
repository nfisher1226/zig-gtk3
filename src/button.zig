usingnamespace @import("cimport.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Button = struct {
    ptr: *GtkButton,

    /// Creates a new Button
    pub fn new() Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, gtk_button_new()),
        };
    }

    /// Creates a Button with a GtkLabel containing the given text
    pub fn new_with_label(text: [:0]const u8) Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, gtk_button_new_with_label(text)),
        };
    }

    /// Creates a new Button containing a label. Underscores in label indicate the
    /// mnemonic for the button.
    pub fn new_with_mnemonic(text: [:0]const u8) Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, gtk_button_new_with_mnemonic(text)),
        };
    }

    /// Creates a new Button containing an icon from the current icon theme.
    pub fn new_from_icon_name(icon_name: [:0]const u8, size: IconSize) Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, gtk_button_new_from_icon_name(icon_name, size.parse())),
        };
    }

    /// Get the ReliefStyle of the Button
    pub fn get_relief(self: Button) ReliefStyle {
        const rel = gtk_button_get_relief(self.ptr);
        return switch (rel) {
            GTK_RELIEF_NORMAL => .normal,
            GTK_RELIEF_NONE => .none,
            else => unreachable,
        };
    }

    /// Set the ReliefStyle of the Button
    pub fn set_relief(self: Button, style: ReliefStyle) void {
        gtk_button_set_relief(self.ptr, style.parse());
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
        return (gtk_button_get_use_underline(self.ptr) == 1);
    }

    /// If true, an underline in the text of the button label indicates the next
    /// character should be used for the mnemonic accelerator key.
    pub fn set_use_underline(self: Button, use: bool) void {
        gtk_button_set_use_underline(self.ptr, bool_to_c_int(use));
    }

    /// Returns true if clicking the Button causes it to receive focus
    pub fn get_focus_on_click(self: Button) bool {
        return (gtk_button_get_focus_on_click(self.ptr) == 1);
    }

    /// Set whether clicking a button causes it to receive focus
    pub fn set_focus_on_click(self: Button, foc: bool) void {
        gtk_button_set_focus_on_click(self.ptr, bool_to_c_int(foc));
    }

    /// Returns an Widget struct representing the image which is currently set, or null
    pub fn get_image(self: Button) ?Widget {
        if (gtk_button_get_image(self.ptr)) |widget| {
            return Widget{
                .ptr = w,
            };
        } else return null;
    }

    /// Set the image of the button to the given widget. If image is null, unset the image.
    pub fn set_image(self: Button, image: ?Widget) void {
        gtk_button_set_image(self.ptr, if (image) |i| i.ptr else null);
    }

    /// Gets the position of the image relative to the text inside the button.
    pub fn get_image_position(self: Button) PositionType {
        return gtk_button_get_image_position(self.ptr).parse();
    }

    /// Sets the position of the image relative to the text inside the button.
    pub fn set_image_position(self: Button, pos: PositionType) void {
        gtk_button_set_image_position(self.ptr, pos.parse());
    }

    /// Returns whether the button will always show the image, if available.
    pub fn get_always_show_image(self: Button) bool {
        return (gtk_button_get_always_show_image(self.ptr) == 1);
    }

    /// Set whether the button will always show the image, if available.
    pub fn set_always_show_image(self: Button, show: bool) void {
        gtk_button_set_always_show_image(self.ptr, bool_to_c_int(show));
    }

    /// Casts the internal pointer to a GtkWidget and returns a Widget struct
    pub fn as_widget(self: Button) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    /// Connects a callback function to the "clicked" signal
    pub fn connect_clicked(self: Button, callback: GCallback, data: ?gpointer) void {
        self.as_widget().connect("clicked", callback, if (data) |d| d else null);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_button_get_type() or ToggleButton.is_instance(gtype) or CheckButton.is_instance(gtype));
    }
};

pub const ToggleButton = struct {
    ptr: *GtkToggleButton,

    /// Creates a new ToggleButton. A widget should be packed into the button, as in button_new().
    pub fn new() ToggleButton {
        return ToggleButton{
            .ptr = @ptrCast(*GtkToggleButton, gtk_check_button_new()),
        };
    }

    /// Creates a new ToggleButton with a text label.
    pub fn new_with_label(text: [:0]const u8) ToggleButton {
        return ToggleButton{
            .ptr = @ptrCast(*GtkToggleButton, gtk_toggle_button_new_with_label(text)),
        };
    }

    /// Creates a new ToggleButton containing a label. Underscores in label indicate the
    /// mnemonic for the button.
    pub fn new_with_mnemonic(text: [:0]const u8) ToggleButton {
        return ToggleButton{
            .ptr = @ptrCast(*GtkToggleButton, gtk_toggle_button_new_with_mnemonic(text)),
        };
    }

    /// Retrieves whether the button is displayed as a separate indicator and label.
    pub fn get_mode(self: ToggleButton) bool {
        return (gtk_toggle_button_get_mode(self.ptr) == 1);
    }

    /// Sets whether the button is displayed as a separate indicator and label.
    pub fn set_mode(self: ToggleButton, mode: bool) void {
        gtk_toggle_button_set_mode(self.ptr, bool_to_c_int(mode));
    }

    /// Casts the internal pointer to a GtkButton and returns a Button struct
    pub fn as_button(self: ToggleButton) Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, self.ptr),
        };
    }

    /// Queries a GtkToggleButton and returns its current state.
    /// Returns true if the toggle button is pressed in and false if it is raised.
    pub fn get_active(self: ToggleButton) bool {
        return (gtk_toggle_button_get_active(self.ptr) == 1);
    }

    /// Sets the status of the toggle button.
    /// This action causes the “toggled” signal and the “clicked” signal to be emitted.
    pub fn set_active(self: ToggleButton, state: bool) void {
        toggle_button_set_active(self.ptr, bool_to_c_int(state));
    }

    /// Casts the internal pointer to a GtkWidget and returns a Widget struct
    pub fn as_widget(self: ToggleButton) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn to_check_button(self: ToggleButton) ?CheckButton {
        return CheckButton{
            .ptr = @ptrCast(*GtkCheckButton, self.ptr),
        };
    }

    /// Connects a callback function when the "toggled" signal is emitted
    pub fn connect_toggled(self: ToggleButton, callback: GCallback, data: ?gpointer) void {
        self.as_widget().connect("toggled", callback, if (data) |d| d else null);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_toggle_button_get_type());
    }
};

pub const CheckButton = struct {
    ptr: *GtkCheckButton,

    // Creates a new CheckButton
    pub fn new() CheckButton {
        return CheckButton{
            .ptr = gtk_check_button_new(),
        };
    }

    // Creates a new CheckButton with a GtkLabel to the right of it.
    pub fn new_with_label(text: [:0]const u8) CheckButton {
        return CheckButton{
            .ptr = gtk_check_button_new_with_label(text),
        };
    }

    // Creates a new CheckButton with a GtkLabel to the right of it.
    // Underscores in label indicate the mnemonic for the check button.
    pub fn new_with_mnemonic(text: [:0]const u8) CheckButton {
        return CheckButton{
            .ptr = gtk_check_button_new_with_mnemonic(text),
        };
    }

    pub fn as_toggle_button(self: CheckButton) ToggleButton {
        return ToggleButton{
            .ptr = @ptrCast(*GtkToggleButton, self.ptr),
        };
    }

    pub fn as_button(self: CheckButton) Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, self.ptr),
        };
    }

    pub fn as_widget(self: CheckButton) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_check_button_get_type());
    }
};
