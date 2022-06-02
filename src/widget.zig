const c = @import("cimport.zig");

const Bin = @import("bin.zig").Bin;

const Box = @import("box.zig").Box;

const button = @import("button.zig");
const Button = button.Button;
const ToggleButton = button.ToggleButton;
const CheckButton = button.CheckButton;

const ButtonBox = @import("button.zig").ButtonBox;

const color = @import("colorchooser.zig");
const ColorChooser = color.ColorChooser;
const ColorButton = color.ColorButton;
const ColorChooserWidget = color.ColorChooserWidget;
const ColorChooserDialog = color.ColorChooserDialog;

const combobox = @import("combobox.zig");
const ComboBox = combobox.ComboBox;
const ComboBoxText = combobox.ComboBoxText;

const common = @import("common.zig");
const bool_to_c_int = common.bool_to_c_int;
const signal_connect = common.signal_connect;

const Container = @import("container.zig").Container;

const dialog = @import("dialog.zig");
const Dialog = dialog.Dialog;
const AboutDialog = dialog.AboutDialog;
const MessageDialog = dialog.MessageDialog;

const entry = @import("entry.zig");
const Entry = entry.Entry;
const EntryBuffer = entry.EntryBuffer;
const EntryCompletion = entry.EntryCompletion;

const Expander = @import("expander.zig").Expander;

const filechooser = @import("filechooser.zig");
const FileChooser = filechooser.FileChooser;
const FileChooserButton = filechooser.FileChooserButton;
const FileChooserDialog = filechooser.FileChooserDialog;
const FileChooserWidget = filechooser.FileChooserWidget;

const Fixed = @import("fixed.zig").Fixed;

const flowbox = @import("flowbox.zig");
const FlowBox = flowbox.FlowBox;
const FlowBoxChild = flowbox.FlowBoxChild;

const fontchooser = @import("fontchooser.zig");
const FontChooser = fontchooser.FontChooser;
const FontButton = fontchooser.FontButton;
const FontChooserWidget = fontchooser.FontChooserWidget;
const FontChooserDialog = fontchooser.FontChooserDialog;

const frame = @import("frame.zig");
const AspectFrame = frame.AspectFrame;
const Frame = frame.Frame;

const grid = @import("grid.zig");
const Grid = grid.Grid;

const HeaderBar = @import("headerbar.zig").HeaderBar;

const Invisible = @import("invisible.zig").Invisible;

const Label = @import("label.zig").Label;

const Layout = @import("layout.zig").Layout;

const menu = @import("menu.zig");
const Menu = menu.Menu;
const MenuItem = menu.MenuItem;

const Notebook = @import("notebook.zig").Notebook;

const Paned = @import("paned.zig").Paned;

const Popover = @import("popover.zig").Popover;

const range = @import("range.zig");
const Range = range.Range;
const Scale = range.Scale;
const SpinButton = range.SpinButton;

const Revealer = @import("revealer.zig").Revealer;

const Separator = @import("separator.zig").Separator;

const stack = @import("stack.zig");
const Stack = stack.Stack;
const StackSwitcher = stack.StackSwitcher;
const StackSidebar = stack.StackSidebar;

const Switch = @import("switch.zig").Switch;

const window = @import("window.zig");
const ApplicationWindow = window.ApplicationWindow;
const Window = window.Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Widget = struct {
    ptr: *c.GtkWidget,

    const Self = @This();

    pub const Align = enum(c_uint) {
        fill = c.GTK_ALIGN_FILL,
        start = c.GTK_ALIGN_START,
        end = c.GTK_ALIGN_END,
        center = c.GTK_ALIGN_CENTER,
        baseline = c.GTK_ALIGN_BASELINE,
    };

    pub fn show(self: Self) void {
        c.gtk_widget_show(self.ptr);
    }

    pub fn show_now(self: Self) void {
        c.gtk_widget_show_now(self.ptr);
    }

    pub fn hide(self: Self) void {
        c.gtk_widget_hide(self.ptr);
    }

    pub fn show_all(self: Self) void {
        c.gtk_widget_show_all(self.ptr);
    }

    pub fn is_focus(self: Self) bool {
        return (c.gtk_widget_is_focus(self.ptr) == 1);
    }

    pub fn has_focus(self: Self) bool {
        return (c.gtk_widget_has_focus(self.ptr) == 1);
    }

    pub fn grab_focus(self: Self) void {
        c.gtk_widget_grab_focus(self.ptr);
    }

    pub fn grab_default(self: Self) void {
        c.gtk_widget_grab_default(self.ptr);
    }

    pub fn set_name(self: Self, name: [:0]const u8) void {
        c.gtk_widget_set_name(self.ptr, name);
    }

    pub fn get_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_widget_get_name(self.ptr)) |n| {
            const len = mem.len(n);
            return fmt.allocPrintZ(allocator, "{s}", .{n[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn set_sensitive(self: Self, visible: bool) void {
        c.gtk_widget_set_sensitive(self.ptr, common.bool_to_c_int(visible));
    }

    pub fn get_toplevel(self: Self) Self {
        return Self{
            .ptr = c.gtk_widget_get_toplevel(self.ptr),
        };
    }

    pub fn get_parent(self: Self) ?Self {
        return if (c.gtk_widget_get_parent(self.ptr)) |w| Self{ .ptr = w } else null;
    }

    pub fn get_has_tooltip(self: Self) bool {
        return (c.gtk_widget_get_has_tooltip(self.ptr) == 1);
    }

    pub fn set_has_tooltip(self: Self, tooltip: bool) void {
        c.gtk_widget_set_has_tooltip(self.ptr, bool_to_c_int(tooltip));
    }

    pub fn get_tooltip_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        return if (c.gtk_widget_get_tooltip_text(self.ptr)) |t|
            fmt.allocPrintZ(allocator, "{s}", .{t}) catch return null
        else
            null;
    }

    pub fn set_tooltip_text(self: Self, text: [:0]const u8) void {
        c.gtk_widget_set_tooltip_text(self.ptr, text);
    }

    pub fn get_screen(self: Self) ?*c.GdkScreen {
        return c.gtk_widget_get_screen(self.ptr);
    }

    pub fn set_visual(self: Self, visual: *c.GdkVisual) void {
        c.gtk_widget_set_visual(self.ptr, visual);
    }

    pub fn set_opacity(self: Self, opacity: f64) void {
        c.gtk_widget_set_opacity(self.ptr, opacity);
    }

    pub fn set_visible(self: Self, vis: bool) void {
        c.gtk_widget_set_visible(self.ptr, bool_to_c_int(vis));
    }

    pub fn get_halign(self: Self) Align {
        return c.gtk_widget_get_halign(self.ptr);
    }

    pub fn set_halign(self: Self, halign: Align) void {
        c.gtk_widget_set_halign(self.ptr, halign);
    }

    pub fn get_valign(self: Self) Align {
        return c.gtk_widget_get_valign(self.ptr);
    }

    pub fn set_valign(self: Self, valign: Align) void {
        c.gtk_widget_set_valign(self.ptr, valign);
    }

    pub fn get_hexpand(self: Self) bool {
        return (c.gtk_widget_get_hexpand(self.ptr) == 1);
    }

    pub fn set_hexpand(self: Self, expand: bool) void {
        c.gtk_widget_set_hexpand(self.ptr, if (expand) 1 else 0);
    }

    pub fn get_vexpand(self: Self) bool {
        return (c.gtk_widget_get_vexpand(self.ptr) == 1);
    }

    pub fn set_vexpand(self: Self, expand: bool) void {
        c.gtk_widget_set_vexpand(self.ptr, if (expand) 1 else 0);
    }

    pub fn destroy(self: Self) void {
        c.gtk_widget_destroy(self.ptr);
    }

    pub fn connect(self: Self, sig: [:0]const u8, callback: c.GCallback, data: ?c.gpointer) void {
        _ = signal_connect(self.ptr, sig, callback, if (data) |d| d else null);
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

    pub fn to_aspect_frame(self: Self) ?AspectFrame {
        return if (self.isa(AspectFrame)) AspectFrame{
            .ptr = @ptrCast(*c.GtkAspectFrame, self.ptr),
        } else null;
    }

    pub fn to_bin(self: Self) ?Bin {
        return if (self.isa(Bin)) Bin{
            .ptr = @ptrCast(*c.GtkBin, self.ptr),
        } else null;
    }

    pub fn to_box(self: Self) ?Box {
        return if (self.isa(Box)) Box{
            .ptr = @ptrCast(*c.GtkBox, self.ptr),
        } else null;
    }

    pub fn to_button(self: Self) ?Button {
        return if (self.isa(Button)) Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        } else null;
    }

    pub fn to_button_box(self: Self) ?ButtonBox {
        return if (self.isa(ButtonBox)) ButtonBox{
            .ptr = @ptrCast(*c.GtkButtonBox, self.ptr),
        } else null;
    }

    pub fn to_check_button(self: Self) ?CheckButton {
        return if (self.isa(CheckButton)) CheckButton{
            .ptr = @ptrCast(*c.GtkCheckButton, self.ptr),
        } else null;
    }

    pub fn to_color_chooser(self: Self) ?ColorChooser {
        return if (self.isa(ColorChooser)) ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        } else null;
    }

    pub fn to_color_button(self: Self) ?ColorButton {
        return if (self.isa(ColorButton)) ColorButton{
            .ptr = @ptrCast(*c.GtkColorButton, self.ptr),
        } else null;
    }

    pub fn to_color_chooser_widget(self: Self) ?ColorChooserWidget {
        return if (self.isa(ColorChooserWidget)) ColorChooserWidget{
            .ptr = @ptrCast(*c.GtkColorChooserdget, self.ptr),
        } else null;
    }

    pub fn to_colorchooser_dialog(self: Self) ?ColorChooserDialog {
        return if (self.isa(ColorChooserDialog)) ColorChooserDialog{
            .ptr = @ptrCast(*c.GtkColorChooserDialog, self.ptr),
        } else null;
    }

    pub fn to_combo_box(self: Self) ?ComboBox {
        return if (self.isa(ComboBox)) ComboBox{
            .ptr = @ptrCast(*c.GtkComboBox, self.ptr),
        } else null;
    }

    pub fn to_combo_box_text(self: Self) ?ComboBoxText {
        return if (self.isa(ComboBoxText)) ComboBoxText{
            .ptr = @ptrCast(*c.GtkComboBoxText, self.ptr),
        } else null;
    }

    pub fn to_container(self: Self) ?Container {
        return if (self.isa(Container)) Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        } else null;
    }

    pub fn to_dialog(self: Self) ?Dialog {
        return if (self.isa(Dialog)) Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        } else null;
    }

    pub fn to_entry(self: Self) ?Entry {
        return if (self.isa(Entry)) Entry{
            .ptr = @ptrCast(*c.GtkEntry, self.ptr),
        } else null;
    }

    pub fn to_expander(self: Self) ?Expander {
        return if (self.isa(Expander)) Expander{
            .ptr = @ptrCast(*c.GtkExpander, self.ptr),
        } else null;
    }

    pub fn to_filechooser(self: Self) ?FileChooser {
        return if (self.isa(FileChooser)) FileChooser{
            .ptr = @ptrCast(*c.GtkFileChooser, self.ptr),
        } else null;
    }

    pub fn to_filechooser_button(self: Self) ?FileChooserButton {
        return if (self.isa(FileChooserButton)) FileChooserButton{
            .ptr = @ptrCast(*c.GtkFileChooserButton, self.ptr),
        } else null;
    }

    pub fn to_filechooser_dialog(self: Self) ?FileChooserDialog {
        return if (self.isa(FileChooserDialog)) FileChooserDialog{
            .ptr = @ptrCast(*c.GtkFileChooserDialog, self.ptr),
        } else null;
    }

    pub fn to_filechooser_widget(self: Self) ?FileChooserWidget {
        return if (self.isa(FileChooserWidget)) FileChooserWidget{
            .ptr = @ptrCast(*c.GtkFileChooserWidget, self.ptr),
        } else null;
    }

    pub fn to_fixed(self: Self) ?Fixed {
        return if (self.isa(Fixed)) Fixed{
            .ptr = @ptrCast(*c.GtkFixed, self.ptr),
        } else null;
    }

    pub fn to_flow_box(self: Self) ?FlowBox {
        return if (self.isa(FlowBox)) FlowBox{
            .ptr = @ptrCast(*c.GtkFlowBox, self.ptr),
        } else null;
    }

    pub fn to_flow_box_child(self: Self) ?FlowBoxChild {
        return if (self.isa(FlowBoxChild)) FlowBoxChild{
            .ptr = @ptrCast(*c.GtkFlowBoxChild, self.ptr),
        } else null;
    }

    pub fn to_font_chooser(self: Self) ?FontChooser {
        return if (self.isa(FontChooser)) FontChooser{
            .ptr = @ptrCast(*c.GtkFontChooser, self.ptr),
        } else null;
    }

    pub fn to_font_button(self: Self) ?FontButton {
        return if (self.isa(FontButton)) FontButton{
            .ptr = @ptrCast(*c.GtkFontButton, self.ptr),
        } else null;
    }

    pub fn to_font_chooser_widget(self: Self) ?FontChooserWidget {
        return if (self.isa(FontChooserWidget)) FontChooserWidget{
            .ptr = @ptrCast(*c.GtkFontChooserWidget, self.ptr),
        } else null;
    }

    pub fn to_font_chooser_dialog(self: Self) ?FontChooserDialog {
        return if (self.isa(FontChooserDialog)) FontChooserDialog{
            .ptr = @ptrCast(*c.GtkFontChooserDialog, self.ptr),
        } else null;
    }

    pub fn to_frame(self: Self) ?Frame {
        return if (self.isa(Frame)) Frame{
            .ptr = @ptrCast(*c.GtkFrame, self.ptr),
        } else null;
    }

    pub fn to_grid(self: Self) ?Grid {
        return if (self.isa(Grid)) Grid{
            .ptr = @ptrCast(*c.GtkGrid, self.ptr),
        } else null;
    }

    pub fn to_header_bar(self: Self) ?HeaderBar {
        return if (self.isa(HeaderBar)) HeaderBar{
            .ptr = @ptrCast(*c.GtkHeaderBar, self.ptr),
        } else null;
    }

    pub fn to_invisible(self: Self) ?Invisible {
        return if (self.isa(Invisible)) Invisible{ .ptr = @ptrCast(*c.GtkInvisible, self.ptr) };
    }

    pub fn to_label(self: Self) ?Label {
        return if (self.isa(Label)) Label{
            .ptr = @ptrCast(*c.GtkLabel, self.ptr),
        } else null;
    }

    pub fn to_layout(self: Self) ?Layout {
        return if (self.isa(Layout)) Layout{
            .ptr = @ptrCast(*c.GtkLayout, self.ptr),
        } else null;
    }

    pub fn to_menu(self: Self) ?Menu {
        return if (self.isa(Menu)) Menu{
            .ptr = @ptrCast(*c.GtkMenu, self.ptr),
        } else null;
    }

    pub fn to_menu_item(self: Self) ?MenuItem {
        return if (self.isa(MenuItem)) MenuItem{
            .ptr = @ptrCast(*c.GtkMenuItem, self.ptr),
        } else null;
    }

    pub fn to_message_dialog(self: Self) ?MessageDialog {
        return if (self.isa(MessageDialog)) MessageDialog{
            .ptr = @ptrCast(*c.GtkMessageDialog, self.ptr),
        } else null;
    }

    pub fn to_notebook(self: Self) ?Notebook {
        return if (self.isa(Notebook)) Notebook{
            .ptr = @ptrCast(*c.GtkNotebook, self.ptr),
        } else null;
    }

    pub fn to_paned(self: Self) ?Paned {
        return if (self.isa(Paned)) Paned{
            .ptr = @ptrCast(*c.GtkPaned, self.ptr),
        } else null;
    }

    pub fn to_popover(self: Self) ?Popover {
        return if (self.isa(Popover)) Popover{
            .ptr = @ptrCast(*c.GtkPopover, self.ptr),
        } else null;
    }

    pub fn to_range(self: Self) ?Range {
        return if (self.isa(Range)) Range{
            .ptr = @ptrCast(*c.GtkRange, self.ptr),
        } else null;
    }

    pub fn to_revealer(self: Self) ?Revealer {
        return if (self.isa(Revealer)) Revealer{
            .ptr = @ptrCast(*c.GtkRevealer, self.ptr),
        } else null;
    }

    pub fn to_scale(self: Self) ?Scale {
        return if (self.isa(Scale)) Scale{ .ptr = @ptrCast(*c.GtkScale, self.ptr) } else null;
    }

    pub fn to_separator(self: Self) ?Separator {
        return if (self.isa(Separator)) Separator{
            .ptr = @ptrCast(*c.GtkSeparator, self.ptr),
        } else null;
    }

    pub fn to_spin_button(self: Self) ?SpinButton {
        return if (self.isa(SpinButton)) SpinButton{ .ptr = @ptrCast(*c.GtkSpinButton, self.ptr) } else null;
    }

    pub fn to_stack(self: Self) ?Stack {
        return if (self.isa(Stack)) Stack{ .ptr = @ptrCast(*c.GtkStack, self.ptr) } else null;
    }

    pub fn to_stack_switcher(self: Self) ?StackSwitcher {
        return if (self.isa(StackSwitcher)) StackSwitcher{ .ptr = @ptrCast(*c.GtkStackSwitcher, self.ptr) } else null;
    }

    pub fn to_stack_sidebar(self: Self) ?StackSidebar {
        return if (self.isa(StackSidebar)) StackSidebar{ .ptr = @ptrCast(*c.GtkStackSidebar, self.ptr) } else null;
    }

    pub fn to_switch(self: Self) ?Switch {
        return if (self.isa(Switch)) Switch{
            .ptr = @ptrCast(*c.GtkSwitch, self.ptr),
        } else null;
    }

    pub fn to_toggle_button(self: Self) ?ToggleButton {
        return if (self.isa(ToggleButton)) ToggleButton{
            .ptr = @ptrCast(*c.GtkToggleButton, self.ptr),
        } else null;
    }

    pub fn to_window(self: Self) ?Window {
        return if (self.isa(Window)) Window{
            .ptr = @ptrCast(*c.GtkWindow, self.ptr),
        } else null;
    }
};
