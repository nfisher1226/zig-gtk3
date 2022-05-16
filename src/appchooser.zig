const c = @import("cimport.zig");

const Bin = @import("bin.zig").Bin;
const Box = @import("box.zig").Box;
const Button = @import("button.zig").Button;
const ComboBox = @import("combobox.zig").ComboBox;
const Container = @import("container.zig").Container;
const Dialog = @import("dialog.zig").Dialog;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// GtkAppChooser is an interface that can be implemented by widgets which allow
/// the user to choose an application (typically for the purpose of opening a
/// file). The main objects that implement this interface are GtkAppChooserWidget,
/// GtkAppChooserDialog and GtkAppChooserButton.
///
/// Applications are represented by GIO GAppInfo objects here. GIO has a concept
/// of recommended and fallback applications for a given content type.
/// Recommended applications are those that claim to handle the content type
/// itself, while fallback also includes applications that handle a more generic
/// content type. GIO also knows the default and last-used application for a
/// given content type. The GtkAppChooserWidget provides detailed control over
/// whether the shown list of applications should include default, recommended
/// or fallback applications.
///
/// To obtain the application that has been selected in a GtkAppChooser, use
/// gtk_app_chooser_get_app_info().
pub const AppChooser = struct {
    ptr: *c.GtkAppChooser,

    const Self = @This();

    /// a GAppInfo for the currently selected application, or NULL if none is
    /// selected. Free with g_object_unref().
    pub fn get_app_info(self: Self) ?*c.GAppInfo {
        return if (c.gtk_app_chooser_get_app_info(self.ptr)) |app| app else null;
    }

    /// Returns the current value of the “content-type” property.
    pub fn get_content_type(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_app_chooser_get_content_type(self.ptr);
        defer c.g_free(val);
        const len = mem.len(val);
        const ctype = fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        return ctype;
    }

    /// Reloads the list of applications.
    pub fn refresh(self: Self) void {
        c.gtk_app_chooser_refresh(self.ptr);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_app_chooser_get_type() or gtype == c.gtk_app_chooser_button_get_type() or gtype == c.gtk_app_chooser_widget_get_type() or gtype == c.gtk_app_chooser_dialog_get_type());
    }
};

/// The AppChooserButton is a widget that lets the user select an application.
/// It implements the GtkAppChooser interface.
///
/// Initially, a GtkAppChooserButton selects the first application in its list,
/// which will either be the most-recently used application or, if
/// “show-default-item” is TRUE, the default application.
///
/// The list of applications shown in a GtkAppChooserButton includes the
/// recommended applications for the given content type. When “show-default-item”
/// is set, the default application is also included. To let the user chooser
/// other applications, you can set the “show-dialog-item” property, which allows
/// to open a full GtkAppChooserDialog.
///
/// It is possible to add custom items to the list, using append_custom_item().
/// These items cause the “custom-item-activated” signal to be emitted when they
/// are selected.
///
/// To track changes in the selected application, use the “changed” signal.
pub const AppChooserButton = struct {
    ptr: *c.GtkAppChooserButton,

    const Self = @This();

    /// Creates a new GtkAppChooserButton for applications that can handle
    /// content of the given type.
    pub fn new(content_type: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkAppChooserButton, c.gtk_app_chooser_button_new(content_type)),
        };
    }

    /// Appends a custom item to the list of applications that is shown in the
    /// popup; the item name must be unique per-widget. Clients can use the
    /// provided name as a detail for the “custom-item-activated” signal, to add
    /// a callback for the activation of a particular custom item in the list.
    /// See also append_separator().
    pub fn append_custom_item(
        self: Self,
        /// the name of the custom item
        name: [:0]const u8,
        /// the label for the custom item
        label: [:0]const u8,
        /// the icon for the custom item
        icon: c.GIcon,
    ) void {
        c.gtk_app_chooser_button_append_custom_item(self.ptr, name, label, icon);
    }

    /// Appends a separator to the list of applications that is shown in the popup.
    pub fn append_separator(self: Self) void {
        c.gtk_app_chooser_button_append_separator(self.ptr);
    }

    /// Selects a custom item previously added with append_custom_item().
    pub fn set_active_custom_item(self: Self, name: [:0]const u8) void {
        c.gtk_app_chooser_button_set_active_custom_item(self.ptr, name);
    }

    /// Returns the current value of the “show-default-item” property.
    pub fn get_show_default_item(self: Self) bool {
        return (c.gtk_app_chooser_button_get_show_default_item(self.ptr) == 1);
    }

    /// Sets whether the dropdown menu of this button should show the default
    /// application for the given content type at top.
    pub fn set_show_default_item(self: Self, show: bool) void {
        c.gtk_app_chooser_button_set_show_default_item(self.ptr, if (show) 1 else 0);
    }

    /// Returns the current value of the “show-dialog-item” property.
    pub fn get_show_dialog_item(self: Self) bool {
        return (c.gtk_app_chooser_button_get_show_dialog_item(self.ptr) == 1);
    }

    /// Sets whether the dropdown menu of this button should show an entry to
    /// trigger a GtkAppChooserDialog.
    pub fn set_show_dialog_item(self: Self, show: bool) void {
        c.gtk_app_chooser_button_set_show_dialog_item(self.ptr, if (show) 1 else 0);
    }

    /// Returns the text to display at the top of the dialog.
    pub fn get_heading(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_app_chooser_button_get_heading(self.ptr)) |h| {
            const len = mem.len(h);
            return fmt.allocPrintZ(allocator, "{s}", .{h[0..len]}) catch return null;
        } else return null;
    }

    /// Sets the text to display at the top of the dialog. If the heading is not
    /// set, the dialog displays a default text.
    pub fn set_heading(self: Self, text: [:0]const u8) void {
        c.gtk_app_chooser_button_set_heading(self.ptr, text);
    }

    pub fn as_bin(self: Self) Bin {
        return Bin{
            .ptr = @ptrCast(*c.GtkBin, self.ptr),
        };
    }

    pub fn as_button(self: Self) Button {
        return Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        };
    }

    pub fn as_combobox(self: Self) ComboBox {
        return ComboBox{
            .ptr = @ptrCast(*c.GtkComboBox, self.ptr),
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
        return (gtype == c.gtk_app_chooser_button_get_type());
    }
};

/// GtkAppChooserWidget is a widget for selecting applications. It is the main
/// building block for GtkAppChooserDialog. Most applications only need to use
/// the latter; but you can use this widget as part of a larger widget if you
/// have special needs.
///
/// AppChooserWidget offers detailed control over what applications are shown,
/// using the “show-default”, “show-recommended”, “show-fallback”, “show-other”
/// and “show-all” properties. See the GtkAppChooser documentation for more
/// information about these groups of applications.
///
/// To keep track of the selected application, use the “application-selected”
/// and “application-activated” signals.
/// ### CSS
/// GtkAppChooserWidget has a single CSS node with name appchooser.
pub const AppChooserWidget = struct {
    ptr: *c.GtkAppChooserWidget,

    const Self = @This();

    /// Creates a new GtkAppChooserWidget for applications that can handle
    /// content of the given type.
    pub fn new(content_type: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkAppChooserWidget, c.gtk_app_chooser_widget_new(content_type)),
        };
    }

    /// Sets whether the app chooser should show the default handler for the
    /// content type in a separate section.
    pub fn set_show_default(self: Self, show: bool) void {
        c.gtk_app_chooser_widget_set_show_default(self.ptr, if (show) 1 else 0);
    }

    /// Returns the current value of the “show-default” property.
    pub fn get_show_default(self: Self) bool {
        return (c.gtk_app_chooser_widget_get_show_default(self.ptr) == 1);
    }

    /// Sets whether the app chooser should show recommended applications for
    /// the content type in a separate section.
    pub fn set_show_recommended(self: Self, show: bool) void {
        c.gtk_app_chooser_widget_set_show_recommended(self.ptr, if (show) 1 else 0);
    }

    /// Returns the current value of the “show-recommended” property.
    pub fn get_show_recommended(self: Self) bool {
        return (c.gtk_app_chooser_widget_get_show_recommended(self.ptr) == 1);
    }

    /// Sets whether the app chooser should show related applications for the
    /// content type in a separate section.
    pub fn set_show_fallback(self: Self, show: bool) void {
        c.gtk_app_chooser_widget_set_show_fallback(self.ptr, if (show) 1 else 0);
    }

    /// Returns the current value of the “show-fallback” property.
    pub fn get_show_fallback(self: Self) bool {
        return (c.gtk_app_chooser_widget_get_show_fallback(self.ptr) == 1);
    }

    /// Sets whether the app chooser should show applications which are
    /// unrelated to the content type.
    pub fn set_show_other(self: Self, show: bool) void {
        c.gtk_app_chooser_widget_set_show_other(self.ptr, if (show) 1 else 0);
    }

    /// Returns the current value of the “show-other” property.
    pub fn get_show_other(self: Self) bool {
        return (c.gtk_app_chooser_widget_get_show_other(self.ptr) == 1);
    }

    /// Sets whether the app chooser should show all applications in a flat list.
    pub fn set_show_all(self: Self, show: bool) void {
        c.gtk_app_chooser_widget_set_show_all(self.ptr, if (show) 1 else 0);
    }

    /// Returns the current value of the “show-all” property.
    pub fn get_show_all(self: Self) bool {
        return (c.gtk_app_chooser_widget_get_show_all(self.ptr) == 1);
    }

    /// Sets the text that is shown if there are not applications that can
    /// handle the content type.
    pub fn set_default_text(self: Self, text: [:0]const u8) void {
        c.gtk_app_chooser_widget_set_default_text(self.ptr, text);
    }

    /// Returns the text that is shown if there are not applications that can
    /// handle the content type.
    pub fn get_default_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_app_chooser_widget_get_default_text(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn as_box(self: Self) Box {
        return Box{
            .ptr = @ptrCast(*c.GtkBox, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_app_chooser_widget_get_type());
    }
};

/// GtkAppChooserDialog shows a GtkAppChooserWidget inside a GtkDialog.
///
/// Note that GtkAppChooserDialog does not have any interesting methods of its
/// own. Instead, you should get the embedded GtkAppChooserWidget using
/// gtk_app_chooser_dialog_get_widget() and call its methods if the generic
/// GtkAppChooser interface is not sufficient for your needs.
///
/// To set the heading that is shown above the GtkAppChooserWidget, use
/// gtk_app_chooser_dialog_set_heading().
pub const AppChooserDialog = struct {
    ptr: *c.GtkAppChooserDialog,

    const Self = @This();

    /// Creates a new GtkAppChooserDialog for the provided GFile, to allow the
    /// user to select an application for it.
    pub fn new(parent: ?Window, flags: Dialog.Flags, file: c.GFile) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkAppChooserDialog, c.gtk_app_chooser_dialog_new(if (parent) |p| p else null, flags, file)),
        };
    }

    /// Creates a new GtkAppChooserDialog for the provided content type, to
    /// allow the user to select an application for it.
    pub fn new_for_content_type(parent: ?Window, flags: Dialog.Flags, content: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkFileChooserDialog, c.gtk_file_chooser_dialog_new_for_content_type(if (parent) |p| p else null, flags, content)),
        };
    }

    /// Returns the GtkAppChooserWidget of this dialog.
    pub fn get_widget(self: Self) AppChooserWidget {
        return AppChooserWidget{
            .ptr = @ptrCast(*c.GtkAppChooserWidget, c.gtk_app_chooser_dialog_get_widget(self.ptr)),
        };
    }

    /// Sets the text to display at the top of the dialog. If the heading is not
    /// set, the dialog displays a default text.
    pub fn set_heading(self: Self, text: [:0]const u8) void {
        c.gtk_app_chooser_dialog_set_heading(self.ptr, text);
    }

    /// Returns the text to display at the top of the dialog.
    pub fn get_heading(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_app_chooser_dialog_get_heading(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn as_bin(self: Self) Bin {
        return Bin{
            .ptr = @ptrCast(*c.GtkBin, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn as_window(self: Self) Window {
        return Window{
            .ptr = @ptrCast(*c.GtkWindow, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_app_chooser_dialog_get_type());
    }
};
