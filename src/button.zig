const c = @import("cimport.zig");
const enums = @import("enums.zig");
const Actionable = @import("actionable.zig").Actionable;
const Buildable = @import("buildable.zig").Buildable;
const ColorButton = @import("colorchooser.zig").ColorButton;
const IconSize = enums.IconSize;
const PositionType = enums.PositionType;
const ReliefStyle = enums.ReliefStyle;
const Widget = @import("widget.zig").Widget;

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Button = struct {
    ptr: *c.GtkButton,

    const Self = @This();

    /// Creates a new Button
    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkButton, c.gtk_button_new()),
        };
    }

    /// Creates a Button with a GtkLabel containing the given text
    pub fn new_with_label(text: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkButton, c.gtk_button_new_with_label(text.ptr)),
        };
    }

    /// Creates a new Button containing a label. Underscores in label indicate the
    /// mnemonic for the button.
    pub fn new_with_mnemonic(text: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkButton, c.gtk_button_new_with_mnemonic(text.ptr)),
        };
    }

    /// Creates a new Button containing an icon from the current icon theme.
    pub fn new_from_icon_name(icon_name: [:0]const u8, size: IconSize) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkButton, c.gtk_button_new_from_icon_name(icon_name.ptr, @enumToInt(size))),
        };
    }

    /// Get the ReliefStyle of the Button
    pub fn get_relief(self: Self) ReliefStyle {
        return c.gtk_button_get_relief(self.ptr);
    }

    /// Set the ReliefStyle of the Button
    pub fn set_relief(self: Self, style: ReliefStyle) void {
        c.gtk_button_set_relief(self.ptr, @enumToInt(style));
    }

    /// Get the text from the label of the Button, or null if unset
    pub fn get_label(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_button_get_label(self.ptr)) |l| {
            const len = mem.len(l);
            const text = fmt.allocPrintZ(allocator, "{s}", .{l[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    /// Set the text for the Button label
    pub fn set_label(self: Self, text: [:0]const u8) void {
        c.gtk_button_set_label(self.ptr, text.ptr);
    }

    /// Returns whether an embedded underline in the button label indicates a mnemonic.
    pub fn get_use_underline(self: Self) bool {
        return (c.gtk_button_get_use_underline(self.ptr) == 1);
    }

    /// If true, an underline in the text of the button label indicates the next
    /// character should be used for the mnemonic accelerator key.
    pub fn set_use_underline(self: Self, use: bool) void {
        c.gtk_button_set_use_underline(self.ptr, if (use) 1 else 0);
    }

    /// Returns true if clicking the Button causes it to receive focus
    pub fn get_focus_on_click(self: Self) bool {
        return (c.gtk_button_get_focus_on_click(self.ptr) == 1);
    }

    /// Set whether clicking a button causes it to receive focus
    pub fn set_focus_on_click(self: Self, foc: bool) void {
        c.gtk_button_set_focus_on_click(self.ptr, if (foc) 1 else 0);
    }

    /// Returns an Widget struct representing the image which is currently set, or null
    pub fn get_image(self: Self) ?Widget {
        if (c.gtk_button_get_image(self.ptr)) |w| {
            return Widget{
                .ptr = w,
            };
        } else return null;
    }

    /// Set the image of the button to the given widget. If image is null, unset the image.
    pub fn set_image(self: Self, image: ?Widget) void {
        c.gtk_button_set_image(self.ptr, if (image) |i| i.ptr else null);
    }

    /// Gets the position of the image relative to the text inside the button.
    pub fn get_image_position(self: Self) PositionType {
        return c.gtk_button_get_image_position(self.ptr);
    }

    /// Sets the position of the image relative to the text inside the button.
    pub fn set_image_position(self: Self, pos: PositionType) void {
        c.gtk_button_set_image_position(self.ptr, @enumToInt(pos));
    }

    /// Returns whether the button will always show the image, if available.
    pub fn get_always_show_image(self: Self) bool {
        return (c.gtk_button_get_always_show_image(self.ptr) == 1);
    }

    /// Set whether the button will always show the image, if available.
    pub fn set_always_show_image(self: Self, show: bool) void {
        c.gtk_button_set_always_show_image(self.ptr, if (show) 1 else 0);
    }

    pub fn as_actionable(self: Self) Actionable {
        return Actionable{
            .ptr = @ptrCast(*c.GtkActionable, self.ptr),
        };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    /// Casts the internal pointer to a GtkWidget and returns a Widget struct
    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_color_button(self: Self) ?ColorButton {
        if (self.isa(ColorButton)) {
            return ColorButton{
                .ptr = @ptrCast(*c.GtkColorButton, self.ptr),
            };
        } else return null;
    }

    /// Connects a callback function to the "clicked" signal
    pub fn connect_clicked(self: Button, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("clicked", callback, if (data) |d| d else null);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_button_get_type() or ToggleButton.is_instance(gtype) or CheckButton.is_instance(gtype));
    }
};

pub const ToggleButton = struct {
    ptr: *c.GtkToggleButton,

    const Self = @This();

    /// Creates a new ToggleButton. A widget should be packed into the button, as in button_new().
    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkToggleButton, c.gtk_check_button_new()),
        };
    }

    /// Creates a new ToggleButton with a text label.
    pub fn new_with_label(text: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkToggleButton, c.gtk_toggle_button_new_with_label(text.ptr)),
        };
    }

    /// Creates a new ToggleButton containing a label. Underscores in label indicate the
    /// mnemonic for the button.
    pub fn new_with_mnemonic(text: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkToggleButton, c.gtk_toggle_button_new_with_mnemonic(text.ptr)),
        };
    }

    /// Retrieves whether the button is displayed as a separate indicator and label.
    pub fn get_mode(self: Self) bool {
        return (c.gtk_toggle_button_get_mode(self.ptr) == 1);
    }

    /// Sets whether the button is displayed as a separate indicator and label.
    pub fn set_mode(self: Self, mode: bool) void {
        c.gtk_toggle_button_set_mode(self.ptr, if (mode) 1 else 0);
    }

    /// Queries a GtkToggleButton and returns its current state.
    /// Returns true if the toggle button is pressed in and false if it is raised.
    pub fn get_active(self: Self) bool {
        return (c.gtk_toggle_button_get_active(self.ptr) == 1);
    }

    /// Sets the status of the toggle button.
    /// This action causes the “toggled” signal and the “clicked” signal to be emitted.
    pub fn set_active(self: Self, state: bool) void {
        c.gtk_toggle_button_set_active(self.ptr, if (state) 1 else 0);
    }

    pub fn as_actionable(self: Self) Actionable {
        return Actionable{
            .ptr = @ptrCast(*c.GtkActionable, self.ptr),
        };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    /// Casts the internal pointer to a GtkButton and returns a Button struct
    pub fn as_button(self: Self) Button {
        return Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        };
    }

    /// Casts the internal pointer to a GtkWidget and returns a Widget struct
    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_check_button(self: Self) ?CheckButton {
        if (self.isa(CheckButton)) {
            return CheckButton{
                .ptr = @ptrCast(*c.GtkCheckButton, self.ptr),
            };
        } else return null;
    }

    /// Connects a callback function when the "toggled" signal is emitted
    pub fn connect_toggled(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("toggled", callback, if (data) |d| d else null);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_toggle_button_get_type());
    }
};

pub const CheckButton = struct {
    ptr: *c.GtkCheckButton,

    const Self = @This();

    // Creates a new CheckButton
    pub fn new() Self {
        return Self{
            .ptr = c.gtk_check_button_new(),
        };
    }

    // Creates a new CheckButton with a GtkLabel to the right of it.
    pub fn new_with_label(text: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkCheckButton, c.gtk_check_button_new_with_label(text.ptr)),
        };
    }

    // Creates a new CheckButton with a GtkLabel to the right of it.
    // Underscores in label indicate the mnemonic for the check button.
    pub fn new_with_mnemonic(text: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkCheckButton, c.gtk_check_button_new_with_mnemonic(text.ptr)),
        };
    }

    pub fn as_actionable(self: Self) Actionable {
        return Actionable{
            .ptr = @ptrCast(*c.GtkActionable, self.ptr),
        };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @ptrCast(*c.GtkBuildable, self.ptr),
        };
    }

    pub fn as_button(self: Self) Button {
        return Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        };
    }

    pub fn as_toggle_button(self: Self) ToggleButton {
        return ToggleButton{
            .ptr = @ptrCast(*c.GtkToggleButton, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_check_button_get_type());
    }
};
