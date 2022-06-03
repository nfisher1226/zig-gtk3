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

    /// Kinds of widget-specific help. Used by the ::show-help signal.
    pub const HelpType = enum(c_uint) {
        /// Tooltip
        tooltip = c.GTK_WIDGET_HELP_TOOLTIP,
        /// What's this.
        whats_this = c.GTK_WIDGET_HELP_WHATS_THIS,
    };

    /// Reading directions for text.
    pub const TextDirection = enum(c_uint) {
        /// No direction.
        none = c.GTK_TEXT_DIR_NONE,
        /// Left to right text direction.
        ltr = c.GTK_TEXT_DIR_LTR,
        /// Right to left text direction.
        rtl = c.GTK_TEXT_DIR_RTL,
    };

    /// Specifies a preference for height-for-width or width-for-height geometry
    /// management.
    pub const SizeRequestMode = enum(c_uint) {
        /// Prefer height-for-width geometry management
        height_for_width = c.GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH,
        /// Prefer width-for-height geometry management
        width_for_height = c.GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT,
        /// Don’t trade height-for-width or width-for-height
        constant_size = c.GTK_SIZE_REQUEST_CONSTANT_SIZE,
    };

    /// Controls how a widget deals with extra space in a single (x or y) dimension.
    ///
    /// Alignment only matters if the widget receives a “too large” allocation,
    /// for example if you packed the widget with the “expand” flag inside a Box,
    /// then the widget might get extra space. If you have for example a 16x16
    /// icon inside a 32x32 space, the icon could be scaled and stretched, it
    /// could be centered, or it could be positioned to one side of the space.
    ///
    /// Note that in horizontal context .start and .end are interpreted relative
    /// to text direction.
    ///
    /// Align.baseline support for it is optional for containers and widgets,
    /// and it is only supported for vertical alignment. When its not supported
    /// by a child or a container it is treated as Align.fill.
    pub const Align = enum(c_uint) {
        /// stretch to fill all space if possible, center if no meaningful way
        /// to stretch
        fill = c.GTK_ALIGN_FILL,
        /// snap to left or top side, leaving space on right or bottom
        start = c.GTK_ALIGN_START,
        /// snap to right or bottom side, leaving space on left or top
        end = c.GTK_ALIGN_END,
        /// center natural width of widget inside the allocation
        center = c.GTK_ALIGN_CENTER,
        /// align the widget according to the baseline. Since 3.10.
        baseline = c.GTK_ALIGN_BASELINE,
    };

    /// Destroys a widget.
    ///
    /// When a widget is destroyed all references it holds on other objects will
    /// be released:
    /// * if the widget is inside a container, it will be removed from its parent
    /// * if the widget is a container, all its children will be destroyed,
    /// recursively
    /// * if the widget is a top level, it will be removed from the list of top
    /// level widgets that GTK+ maintains internally
    ///
    /// It's expected that all references held on the widget will also be
    /// released; you should connect to the “destroy” signal if you hold a
    /// reference to widget and you wish to remove it when this function is
    /// called. It is not necessary to do so if you are implementing a Container,
    /// as you'll be able to use the GtkContainerClass.remove() virtual function
    /// for that.
    ///
    /// It's important to notice that gtk_widget_destroy() will only cause the
    /// widget to be finalized if no additional references, acquired using
    /// g_object_ref(), are held on it. In case additional references are in
    /// place, the widget will be in an "inert" state after calling this function;
    /// widget will still point to valid memory, allowing you to release the
    /// references you hold, but you may not query the widget's own state.
    ///
    /// You should typically call this function on top level widgets, and rarely
    /// on child widgets.
    pub fn destroy(self: Widget) void {
        c.gtk_widget_destroy(self.ptr);
    }

    /// Flags a widget to be displayed. Any widget that isn’t shown will not
    /// appear on the screen. If you want to show all the widgets in a container,
    /// it’s easier to call gtk_widget_show_all() on the container, instead of
    /// individually showing the widgets.
    ///
    /// Remember that you have to show the containers containing a widget, in
    /// addition to the widget itself, before it will appear onscreen.
    ///
    /// When a toplevel container is shown, it is immediately realized and
    /// mapped; other shown widgets are realized and mapped when their toplevel
    /// container is realized and mapped.
    pub fn show(self: Self) void {
        c.gtk_widget_show(self.ptr);
    }

    /// Shows a widget. If the widget is an unmapped toplevel widget (i.e. a
    /// GtkWindow that has not yet been shown), enter the main loop and wait for
    /// the window to actually be mapped. Be careful; because the main loop is
    /// running, anything can happen during this function.
    pub fn show_now(self: Self) void {
        c.gtk_widget_show_now(self.ptr);
    }

    /// Reverses the effects of gtk_widget_show(), causing the widget to be
    /// hidden (invisible to the user).
    pub fn hide(self: Self) void {
        c.gtk_widget_hide(self.ptr);
    }

    /// Recursively shows a widget, and any child widgets (if the widget is a
    /// container).
    pub fn show_all(self: Self) void {
        c.gtk_widget_show_all(self.ptr);
    }

    /// Obtains the frame clock for a widget. The frame clock is a global “ticker”
    /// that can be used to drive animations and repaints. The most common reason
    /// to get the frame clock is to call gdk_frame_clock_get_frame_time(), in
    /// order to get a time to use for animating. For example you might record
    /// the start of the animation with an initial value from
    /// gdk_frame_clock_get_frame_time(), and then update the animation by calling
    /// gdk_frame_clock_get_frame_time() again during each repaint.
    ///
    /// gdk_frame_clock_request_phase() will result in a new frame on the clock,
    /// but won’t necessarily repaint any widgets. To repaint a widget, you have
    /// to use gtk_widget_queue_draw() which invalidates the widget (thus
    /// scheduling it to receive a draw on the next frame). gtk_widget_queue_draw()
    /// will also end up requesting a frame on the appropriate frame clock.
    ///
    /// A widget’s frame clock will not change while the widget is mapped. 
    /// Reparenting a widget (which implies a temporary unmap) can change the
    /// widget’s frame clock.
    ///
    /// Unrealized widgets do not have a frame clock.
    pub fn get_frame_clock(self: Self) *c.GdkFrameClock {
        return c.gtk_widget_get_frame_clock(self.ptr);
    }

    /// Retrieves the internal scale factor that maps from window coordinates to
    /// the actual device pixels. On traditional systems this is 1, on high
    /// density outputs, it can be a higher value (typically 2).
    pub fn get_scale_factor(self: Self) c_int {
        return c.gtk_widget_get_scale_factor(self.ptr);
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
        return @intToEnum(Align, c.gtk_widget_get_halign(self.ptr));
    }

    pub fn set_halign(self: Self, halign: Align) void {
        c.gtk_widget_set_halign(self.ptr, @enumToInt(halign));
    }

    pub fn get_valign(self: Self) Align {
        return @intToEnum(Align, c.gtk_widget_get_valign(self.ptr));
    }

    pub fn set_valign(self: Self, valign: Align) void {
        c.gtk_widget_set_valign(self.ptr, @enumToInt(valign));
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
