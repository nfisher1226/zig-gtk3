const c = @import("cimport.zig");

const Bin = @import("bin.zig").Bin;

const Box = @import("box.zig").Box;

const button = @import("button.zig");
const Button = button.Button;
const ToggleButton = button.ToggleButton;
const CheckButton = button.CheckButton;

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

const entry = @import("entry.zig");
const Entry = entry.Entry;
const EntryBuffer = entry.EntryBuffer;
const EntryCompletion = entry.EntryCompletion;

const Expander = @import("expander.zig").Expander;

const flowbox = @import("flowbox.zig");
const FlowBox = flowbox.FlowBox;
const FlowBoxChild = flowbox.FlowBoxChild;

const fontchooser = @import("fontchooser.zig");
const FontChooser = fontchooser.FontChooser;
const FontButton = fontchooser.FontButton;
const FontChooserWidget = fontchooser.FontChooserWidget;
const FontChooserDialog = fontchooser.FontChooserDialog;

const grid = @import("grid.zig");
const Grid = grid.Grid;

const HeaderBar = @import("headerbar.zig").HeaderBar;

const Label = @import("label.zig").Label;

const menu = @import("menu.zig");
const Menu = menu.Menu;
const MenuItem = menu.MenuItem;

const Notebook = @import("notebook.zig").Notebook;

const Paned = @import("paned.zig").Paned;

const range = @import("range.zig");
const Range = range.Range;
const Scale = range.Scale;
const SpinButton = range.SpinButton;

const Revealer = @import("revealer.zig").Revealer;

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

    pub fn to_bin(self: Self) ?Bin {
        if (self.isa(Bin)) {
            return Bin{
                .ptr = @ptrCast(*c.GtkBin, self.ptr),
            };
        } else return null;
    }

    pub fn to_box(self: Self) ?Box {
        if (self.isa(Box)) {
            return Box{
                .ptr = @ptrCast(*c.GtkBox, self.ptr),
            };
        } else return null;
    }

    pub fn to_button(self: Self) ?Button {
        if (self.isa(Button)) {
            return Button{
                .ptr = @ptrCast(*c.GtkButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_check_button(self: Self) ?CheckButton {
        if (self.isa(CheckButton)) {
            return CheckButton{
                .ptr = @ptrCast(*c.GtkCheckButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser(self: Self) ?ColorChooser {
        if (self.isa(ColorChooser)) {
            return ColorChooser{
                .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_button(self: Self) ?ColorButton {
        if (self.isa(ColorButton)) {
            return ColorButton{
                .ptr = @ptrCast(*c.GtkColorButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_widget(self: Self) ?ColorChooserWidget {
        if (self.isa(ColorChooserWidget)) {
            return ColorChooserWidget{
                .ptr = @ptrCast(*c.GtkColorChooserdget, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_dialog(self: Self) ?ColorChooserDialog {
        if (self.isa(ColorChooserDialog)) {
            return ColorChooserDialog{
                .ptr = @ptrCast(*c.GtkColorChooserDialog, self.ptr),
            };
        } else return null;
    }

    pub fn to_combo_box(self: Self) ?ComboBox {
        if (self.isa(ComboBox)) {
            return ComboBox{
                .ptr = @ptrCast(*c.GtkComboBox, self.ptr),
            };
        } else return null;
    }

    pub fn to_combo_box_text(self: Self) ?ComboBoxText {
        if (self.isa(ComboBoxText)) {
            return ComboBoxText{
                .ptr = @ptrCast(*c.GtkComboBoxText, self.ptr),
            };
        } else return null;
    }

    pub fn to_container(self: Self) ?Container {
        if (self.isa(Container)) {
            return Container{
                .ptr = @ptrCast(*c.GtkContainer, self.ptr),
            };
        } else return null;
    }

    pub fn to_entry(self: Self) ?Entry {
        return if (self.isa(Entry)) Entry{
            .ptr = @ptrCast(*c.GtkEntry, self.ptr),
        } else null;
    }

    pub fn to_expander(self: Self) ?Entry {
        return if (self.isa(Expander)) Entry{
            .ptr = @ptrCast(*c.GtkExpander, self.ptr),
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

    pub fn to_grid(self: Self) ?Grid {
        return if (self.isa(Grid)) Grid{
            .ptr = @ptrCast(*c.GtkGrid, self.ptr),
        } else null;
    }

    pub fn to_header_bar(self: Self) ?Grid {
        return if (self.isa(HeaderBar)) HeaderBar{
            .ptr = @ptrCast(*c.GtkHeaderBar, self.ptr),
        } else null;
    }

    pub fn to_label(self: Self) ?Label {
        return if (self.isa(Label)) Label{
            .ptr = @ptrCast(*c.GtkLabel, self.ptr),
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

    pub fn to_spin_button(self: Self) ?SpinButton {
        return if (self.isa(SpinButton)) SpinButton{ .ptr = @ptrCast(*c.GtkSpinButton, self.ptr) } else null;
    }

    pub fn to_stack(self: Self) ?Stack {
        return if (self.isa(Stack)) Stack{ .ptr = @ptrCast(*c.GtkStack, self.ptr) } else null;
    }

    pub fn to_stack_switcher(self: Self) ?StackSwitcher {
        return if (self.isa(StackSwitcher)) Stack{ .ptr = @ptrCast(*c.GtkStackSwitcher, self.ptr) } else null;
    }

    pub fn to_stack_sidebar(self: Self) ?StackSidebar {
        return if (self.isa(StackSidebar)) Stack{ .ptr = @ptrCast(*c.GtkStackSidebar, self.ptr) } else null;
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
