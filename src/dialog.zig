const c = @import("cimport.zig");
const ColorChooserDialog = @import("colorchooser.zig").ColorChooserDialog;
const Container = @import("container.zig").Container;
const FileChooserDialog = @import("filechooser.zig").FileChooserDialog;
const FontChooserDialog = @import("fontchooser.zig").FontChooserDialog;
const License = @import("enums.zig").License;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Dialog = struct {
    ptr: *c.GtkDialog,

    pub const Flags = enum(c_uint) {
        modal = c.GTK_DIALOG_FLAGS_MODAL,
        destroy_with_parent = c.GTK_DIALOG_FLAGS_DESTROY_WITH_PARENT,
        use_header_bar = c.GTK_DIALOG_FLAGS_USE_HEADER_BAR,
    };

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkDialog, c.gtk_dialog_new()),
        };
    }

    pub fn run(self: Self) c_int {
        return c.gtk_dialog_run(self.ptr);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn as_window(self: Self) Window {
        return Window{ .ptr = @ptrCast(*c.GtkWindow, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_dialog_get_type() or AboutDialog.is_instance(gtype) or ColorChooserDialog.is_instance(gtype) or FontChooserDialog.is_instance(gtype) or MessageDialog.is_instance(gtype));
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_about_dialog(self: Self) ?AboutDialog {
        return if (self.isa(AboutDialog)) AboutDialog{
            .ptr = @ptrCast(*c.GtkAboutDialog, self.ptr),
        } else null;
    }

    pub fn to_colorchooser_dialog(self: Self) ?ColorChooserDialog {
        return if (self.isa(ColorChooserDialog)) ColorChooserDialog{
            .ptr = @ptrCast(*c.GtkColorChooserDialog, self.ptr),
        } else null;
    }

    pub fn to_filechooser_dialog(self: Self) ?FileChooserDialog {
        return if (self.isa(FileChooserDialog)) FileChooserDialog{
            .ptr = @ptrCast(*c.GtkFileChooserDialog, self.ptr),
        } else null;
    }

    pub fn to_fontchooser_dialog(self: Self) ?FontChooserDialog {
        return if (self.isa(FontChooserDialog)) FontChooserDialog{
            .ptr = @ptrCast(*c.GtkFontChooserDialog, self.ptr),
        } else null;
    }

    pub fn to_message_dialog(self: Self) ?MessageDialog {
        return if (self.isa(MessageDialog)) MessageDialog{
            .ptr = @ptrCast(*c.GtkMessageDialog, self.ptr),
        } else null;
    }
};

pub const AboutDialog = struct {
    ptr: *c.GtkAboutDialog,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkAboutDialog, c.gtk_about_dialog_new()),
        };
    }

    pub fn get_program_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_program_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_program_name(self: AboutDialog, name: [:0]const u8) void {
        c.gtk_about_dialog_set_program_name(self.ptr, name);
    }

    pub fn get_version(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_version(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_version(self: AboutDialog, version: [:0]const u8) void {
        c.gtk_about_dialog_set_version(self.ptr, version);
    }

    pub fn get_copyright(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_copyright(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_copyright(self: AboutDialog, copyright: [:0]const u8) void {
        c.gtk_about_dialog_set_copyright(self.ptr, copyright);
    }

    pub fn get_comments(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_comments(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_comments(self: AboutDialog, comments: [:0]const u8) void {
        c.gtk_about_dialog_set_copyright(self.ptr, comments);
    }

    pub fn get_license(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_license(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_license(self: AboutDialog, license: [:0]const u8) void {
        c.gtk_about_dialog_set_license(self.ptr, license);
    }

    pub fn get_wrap_license(self: Self) bool {
        return (c.gtk_about_dialog_get_wrap_license(self.ptr) == 1);
    }

    pub fn set_wrap_license(self: Self, wrap: bool) void {
        c.gtk_about_dialog_set_wrap_license(self.ptr, if (wrap) 1 else 0);
    }

    pub fn get_license_type(self: Self) License {
        return c.gtk_about_dialog_get_license_type(self.ptr);
    }

    pub fn set_license_type(self: Self, license: License) void {
        c.gtk_about_dialog_set_license_type(self.ptr, @enumToInt(license));
    }

    pub fn get_website(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_website(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_website(self: Self, site: [:0]const u8) void {
        c.gtk_about_dialog_set_website(self.ptr, site);
    }

    pub fn get_website_label(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_website_label(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_website_label(self: Self, label: [:0]const u8) void {
        c.gtk_about_dialog_set_website_label(self.ptr, label);
    }

    pub fn get_authors(self: Self) [][:0]const u8 {
        return c.gtk_about_dialog_get_authors(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var authors = [_:0][*c]const u8{ "Your Name" };
    /// dlg.set_authors(&authors);
    pub fn set_authors(self: Self, authors: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_authors(self.ptr, authors);
    }

    pub fn get_artists(self: Self) [*c][*c]const u8 {
        return c.gtk_about_dialog_get_artists(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var artists = [_:0][*c]const u8{ "Some Artist" };
    /// dlg.set_authors(&artists);
    pub fn set_artists(self: Self, artists: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_artists(self.ptr, artists);
    }

    pub fn get_documentors(self: Self) [*c][*c]const u8 {
        return c.gtk_about_dialog_get_documentors(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var documentors = [_:0][*c]const u8{ "Some Person" };
    /// dlg.set_authors(&documentors);
    pub fn set_documentors(self: Self, artists: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_documentors(self.ptr, artists);
    }

    pub fn get_translator_credits(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_translator_credits(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_translator_credits(self: Self, site: [:0]const u8) void {
        c.gtk_about_dialog_set_translator_credits(self.ptr, site);
    }

    pub fn get_logo(self: Self) *c.GdkPixbuf {
        return c.gtk_about_dialog_get_logo(self.ptr);
    }

    pub fn set_logo(self: Self, logo: *c.GdkPixbuf) void {
        c.gtk_about_dialog_set_logo(self.ptr, logo);
    }

    pub fn get_logo_icon_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_logo_icon_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_logo_icon_name(self: Self, name: [:0]const u8) void {
        c.gtk_about_dialog_set_logo_icon_name(self.ptr, name);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var documentorss = [_:0][*c]const u8{ "Some Person" };
    /// dlg.set_authors(&documentors);
    pub fn add_credit_section(self: Self, section_name: [:0]const u8, people: [*c][*c]const u8) void {
        c.gtk_about_dialog_add_credit_section(self.ptr, section_name, people);
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn as_window(self: Self) Window {
        return Window{ .ptr = @ptrCast(*c.GtkWindow, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_about_dialog_get_type());
    }
};

pub const MessageDialog = struct {
    ptr: *c.GtkMessageDialog,

    const Self = @This();

    pub fn new(parent: Window, flags: Dialog.Flags, kind: Type, buttons: ButtonsType, msg: [:0]const u8) Self {
        return Self{
            .ptr = c.gtk_message_dialog_new(parent.ptr, flags, kind, buttons, msg),
        };
    }

    pub fn new_with_markup(parent: Window, flags: Dialog.Flags, kind: Type, buttons: ButtonsType, msg: [:0]const u8) Self {
        return Self{
            .ptr = c.gtk_message_dialog_new_with_markup(parent.ptr, flags, kind, buttons, msg),
        };
    }

    pub fn set_markup(self: Self, markup: [:0]const u8) void {
        c.gtk_message_dialog_set_markup(self.ptr, markup);
    }

    pub fn format_secondary_text(self: Self, text: [:0]const u8) void {
        c.gtk_message_dialog_format_secondary_text(self.ptr, text);
    }

    pub fn format_secondary_markup(self: Self, text: [:0]const u8) void {
        c.gtk_message_dialog_format_secondary_markup(self.ptr, text);
    }

    pub fn get_message_area(self: Self) Widget {
        return Widget{
            .ptr = c.gtk_message_dialog_get_message_area(self.ptr),
        };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn as_window(self: Self) Window {
        return Window{ .ptr = @ptrCast(*c.GtkWindow, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_message_dialog_get_type());
    }
};

pub const Type = enum(c_uint) {
    info = c.GTK_MESSAGE_INFO,
    warning = c.GTK_MESSAGE_WARNING,
    question = c.GTK_MESSAGE_QUESTION,
    err = c.GTK_MESSAGE_ERROR,
    other = c.GTK_MESSAGE_OTHER,
};

pub const ButtonsType = enum(c_uint) {
    none = c.GTK_BUTTONS_NONE,
    ok = c.GTK_BUTTONS_OK,
    close = c.GTK_BUTTONS_CLOSE,
    cancel = c.GTK_BUTTONS_CANCEL,
    yes_no = c.GTK_BUTTONS_YES_NO,
    ok_cancel = c.GTK_BUTTONS_OK_CANCEL,
};
