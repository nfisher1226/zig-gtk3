const c = @import("cimport.zig");
const Justification = @import("enums.zig").Justification;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// A widget that displays a small to medium amount of text
pub const Label = struct {
    ptr: *c.GtkLabel,

    const Self = @This();

    /// EllipsizeMode describes what sort of ellipsization should be applied
    /// to text.
    ///
    /// In the ellipsization process characters are removed from the text
    /// in order to make it fit to a given width and replaced with an ellipsis.
    pub const EllipsizeMode = enum(c_uint) {
        none = c.PANGO_ELLIPSIZE_NONE,
        start = c.PANGO_ELLIPSIZE_START,
        middle = c.PANGO_ELLIPSIZE_MIDDLE,
        end = c.PANGO_ELLIPSIZE_END,
    };

    /// WrapMode describes how to wrap the lines of a PangoLayout to the desired width.
    ///
    /// For `WrapMode.word`, Pango uses break opportunities that are determined
    /// by the Unicode line breaking algorithm. For `WrapMode.char`, Pango allows
    /// breaking at grapheme boundaries that are determined by the Unicode text
    /// segmentation algorithm.
    pub const WrapMode = enum(c_uint) { word = c.PANGO_WRAP_WORD, char = c.PANGO_WRAP_CHAR, word_char = c.PANGO_WRAP_WORD_CHAR };

    pub const LayoutOffsets = struct {
        x: c_int,
        y: c_int,
    };

    pub const SelectionBounds = struct {
        start: c_int,
        end: c_int,
    };

    /// Creates a new label with the given text inside it. You can pass `null` to get
    /// an empty label widget.
    pub fn new(text: ?[:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkLabel, c.gtk_label_new(if (text) |t| t.ptr else null)),
        };
    }

    /// Sets the text within the GtkLabel widget. It overwrites any text that was
    /// there before.
    ///
    /// This function will clear any previously set mnemonic accelerators, and set
    /// the “use-underline” property to `false` as a side effect.
    ///
    /// This function will set the “use-markup” property to `false` as a side effect.
    pub fn set_text(self: Self, text: [:0]const u8) void {
        c.gtk_label_set_text(self.ptr, text.ptr);
    }

    /// Sets a PangoAttrList; the attributes in the list are applied to the label text.
    ///
    /// The attributes set with this function will be applied and merged with any other
    /// attributes previously effected by way of the “use-underline” or “use-markup”
    /// properties. While it is not recommended to mix markup strings with manually set
    /// attributes, if you must; know that the attributes will be applied to the label
    /// after the markup string is parsed.
    pub fn set_attributes(self: Self, attr: *c.PangoAttrList) void {
        c.gtk_label_set_attributes(self.ptr, attr);
    }

    /// Parses str which is marked up with the Pango text markup language, setting the
    /// label’s text and attribute list based on the parse results.
    ///
    /// If the str is external data, you may need to escape it with g_markup_escape_text()
    /// or g_markup_printf_escaped():
    /// ```Zig
    /// const label = Label.new(null);
    /// const str: [:0]const u8 = "some text";
    /// const format: [:0]const u8 = "<span style=\"italic\">\%s</span>";
    /// var markup: [:0]const u8 = undefined;
    ///
    /// markup = c.g_markup_printf_escaped(format, str);
    /// label.set_markup(label, markup);
    /// c.g_free(markup);
    /// ```
    /// This function will set the “use-markup” property to TRUE as a side effect.
    ///
    /// If you set the label contents using the “label” property you should also ensure
    /// that you set the “use-markup” property accordingly.
    pub fn set_markup(self: Self, text: [:0]const u8) void {
        c.gtk_label_set_markup(self.ptr, text.ptr);
    }

    /// Parses str which is marked up with the Pango text markup language, setting the
    /// label’s text and attribute list based on the parse results. If characters in str
    /// are preceded by an underscore, they are underlined indicating that they represent
    /// a keyboard accelerator called a mnemonic.
    ///
    /// The mnemonic key can be used to activate another widget, chosen automatically,
    /// or explicitly using set_mnemonic_widget().
    pub fn set_markup_with_mnemonic(self: Self, markup: [:0]const u8) void {
        c.gtk_label_set_markup_with_mnemonic(self.ptr, markup.ptr);
    }

    /// The pattern of underlines you want under the existing text within the GtkLabel
    /// widget. For example if the current text of the label says “FooBarBaz” passing a
    /// pattern of “___ ___” will underline “Foo” and “Baz” but not “Bar”.
    pub fn set_pattern(self: Self, pattern: [:0]const u8) void {
        c.gtk_label_set_pattern(self.ptr, pattern.ptr);
    }

    /// Sets the alignment of the lines in the text of the label relative to each other.
    /// `Justify.left` is the default value when the widget is first created with Label.new().
    /// If you instead want to set the alignment of the label as a whole, use Widget.set_halign()
    /// instead. Label.set_justify() has no effect on labels containing only a single line.
    pub fn set_justify(self: Self, justify: Justification) void {
        c.gtk_label_set_justify(self.ptr, @enumToInt(justify));
    }

    /// Sets the “xalign” property for label.
    pub fn set_xalign(self: Self, xalign: f32) void {
        c.gtk_label_set_xalign(self.ptr, xalign);
    }

    /// Sets the “yalign” property for label.
    pub fn set_yalign(self: Self, yalign: f32) void {
        c.gtk_label_set_yalign(self.ptr, yalign);
    }

    /// Sets the mode used to ellipsize (add an ellipsis: "...") to the text
    /// if there is not enough space to render the entire string.
    pub fn set_ellipsize(self: Self, ellipsize: EllipsizeMode) void {
        c.gtk_label_set_ellipsize(self.ptr, @enumToInt(ellipsize));
    }

    /// Sets the desired width in characters of label to n_chars.
    pub fn set_width_chars(self: Self, width: c_int) void {
        c.gtk_label_set_width_chars(self.ptr, width);
    }

    /// Sets the desired maximum width in characters of label to n_chars.
    pub fn set_max_width_chars(self: Self, max: c_int) void {
        c.gtk_label_set_max_width_chars(self.ptr, max);
    }

    /// Toggles line wrapping within the GtkLabel widget. TRUE makes it break
    /// lines if text exceeds the widget’s size. FALSE lets the text get cut off
    /// by the edge of the widget if it exceeds the widget size.
    ///
    /// Note that setting line wrapping to TRUE does not make the label wrap at
    /// its parent container’s width, because GTK+ widgets conceptually can’t make
    /// their requisition depend on the parent container’s size. For a label that
    /// wraps at a specific position, set the label’s width using Widget.set_size_request().
    pub fn set_line_wrap(self: Self, wrap: bool) void {
        c.gtk_label_set_line_wrap(self.ptr, if (wrap) 1 else 0);
    }

    /// If line wrapping is on (see Label.et_line_wrap()) this controls how the line
    /// wrapping is done. The default is `WrapMode.word` which means wrap on word boundaries.
    pub fn set_line_wrap_mode(self: Self, mode: WrapMode) void {
        c.gtk_label_set_line_wrap_mode(self.ptr, @enumToInt(mode));
    }

    /// Sets the number of lines to which an ellipsized, wrapping label should be
    /// limited. This has no effect if the label is not wrapping or ellipsized.
    /// Set this to -1 if you don’t want to limit the number of lines.
    pub fn set_lines(self: Self, lines: c_int) void {
        c.gtk_label_set_lines(self.ptr, lines);
    }

    /// Obtains the coordinates where the label will draw the PangoLayout representing
    /// the text in the label; useful to convert mouse events into coordinates inside
    /// the PangoLayout, e.g. to take some action if some part of the label is clicked.
    /// Of course you will need to create a GtkEventBox to receive the events, and pack
    /// the label inside it, since labels are windowless (they return `false` from
    /// Widget.get_has_window()). Remember when using the PangoLayout functions you need
    /// to convert to and from pixels using PANGO_PIXELS() or PANGO_SCALE.
    pub fn get_layout_offsets(self: Self) LayoutOffsets {
        var x: c_int = undefined;
        var y: c_int = undefined;
        c.gtk_label_get_layout_offsets(self.ptr, x, y);
        return LayoutOffsets{ .x = x, .y = y };
    }

    /// If the label has been set so that it has an mnemonic key this function returns the
    /// keyval used for the mnemonic accelerator. If there is no mnemonic set up it returns
    /// GDK_KEY_VoidSymbol.
    pub fn get_mnemonic_keyval(self: Self) c_uint {
        return c.gtk_label_get_mnemonic_keyval(self.ptr);
    }

    /// Gets the value set by Label.set_selectable().
    pub fn get_selectable(self: Self) bool {
        return (c.gtk_label_get_selectable(self.ptr) == 1);
    }

    /// Fetches the text from a label widget, as displayed on the screen. This does not include
    /// any embedded underlines indicating mnemonics or Pango markup. (See Label.get_label())
    pub fn get_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_label_get_text(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    /// Creates a new GtkLabel, containing the text in str.
    ///
    /// If characters in str are preceded by an underscore, they are underlined. If you need a
    /// literal underscore character in a label, use '__' (two underscores). The first underlined
    /// character represents a keyboard accelerator called a mnemonic. The mnemonic key can be
    /// used to activate another widget, chosen automatically, or explicitly using
    /// Label.set_mnemonic_widget().
    ///
    /// If Label.set_mnemonic_widget() is not called, then the first activatable ancestor of the
    // Label will be chosen as the mnemonic widget. For instance, if the label is inside a button
    /// or menu item, the button or menu item will automatically become the mnemonic widget and be
    /// activated by the mnemonic.
    pub fn new_with_mnemonic(str: [:0]const u8) Self {
        return Self{ .ptr = @ptrCast(*c.GtkLabel, c.gtk_label_new_with_mnemonic(str.ptr)) };
    }

    /// Selects a range of characters in the label, if the label is selectable. See
    /// Label.set_selectable(). If the label is not selectable, this function has no effect. If
    /// start_offset or end_offset are -1, then the end of the label will be substituted.
    pub fn select_region(self: Self, start: c_int, end: c_int) void {
        c.gtk_label_select_region(self.ptr, start, end);
    }

    /// If the label has been set so that it has an mnemonic key (using i.e.
    /// Label.set_markup_with_mnemonic(), Label.set_text_with_mnemonic(), Label.new_with_mnemonic()
    /// or the “use_underline” property) the label can be associated with a widget that is the target
    /// of the mnemonic. When the label is inside a widget (like a GtkButton or a GtkNotebook tab) it
    /// is automatically associated with the correct widget, but sometimes (i.e. when the target is an
    /// Entry next to the label) you need to set it explicitly using this function.
    ///
    /// The target widget will be accelerated by emitting the GtkWidget::mnemonic-activate signal on it.
    /// The default handler for this signal will activate the widget if there are no mnemonic collisions
    /// and toggle focus between the colliding widgets otherwise.
    pub fn set_mnemonic_widget(self: Self, widget: Widget) void {
        c.gtk_label_set_mnemonic_widget(self.ptr, widget.ptr);
    }

    /// Selectable labels allow the user to select text from the label, for copy-and-paste.
    pub fn set_selectable(self: Self, set: bool) void {
        c.gtk_label_set_selectable(self.ptr, if (set) 1 else 0);
    }

    /// Sets the label’s text from the string str . If characters in str are preceded by an underscore,
    /// they are underlined indicating that they represent a keyboard accelerator called a mnemonic.
    /// The mnemonic key can be used to activate another widget, chosen automatically, or explicitly
    /// using Label.set_mnemonic_widget().
    pub fn set_text_with_mnemonic(self: Self, str: [:0]const u8) void {
        c.gtk_label_set_text_with_mnemonic(self.ptr, str.ptr);
    }

    /// Gets the attribute list that was set on the label using Label.set_attributes(), if any. This
    /// function does not reflect attributes that come from the labels markup (see Label.set_markup()).
    /// If you want to get the effective attributes for the label, use pango_layout_get_attribute
    /// (Label.get_layout(label)).
    pub fn get_attributes(self: Self) *c.PangoAttrList {
        return c.gtk_label_get_attributes(self.ptr);
    }

    /// Returns the justification of the label. See Lable.set_justify().
    pub fn get_justify(self: Self) Justification {
        return @intToEnum(Justification, c.gtk_label_get_justify(self.ptr));
    }

    /// Gets the “xalign” property for label.
    pub fn get_xalign(self: Self) f32 {
        return c.gtk_label_get_xalign(self.ptr);
    }

    /// Gets the “yalign” property for label.
    pub fn get_yalign(self: Self) f32 {
        return c.gtk_label_get_yalign(self.ptr);
    }

    /// Returns the ellipsizing position of the label. See Label.set_ellipsize().
    pub fn get_ellipsize(self: Self) EllipsizeMode {
        return @intToEnum(EllipsizeMode, c.gtk_label_get_ellipsize(self.ptr));
    }

    /// Retrieves the desired width of label, in characters. See Label.set_width_chars().
    pub fn get_width_chars(self: Self) c_int {
        return c.gtk_label_get_width_chars(self.ptr);
    }

    /// Retrieves the desired maximum width of label, in characters. See Label.set_width_chars().
    pub fn get_max_width_chars(self: Self) c_int {
        return c.gtk_label_get_max_width_chars(self.ptr);
    }

    /// Fetches the text from a label widget including any embedded underlines indicating
    /// mnemonics and Pango markup. (See Label.get_text()).
    pub fn get_label(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_label_get_label(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    /// Gets the PangoLayout used to display the label. The layout is useful to e.g. convert
    /// text positions to pixel positions, in combination with Label.get_layout_offsets(). The
    /// returned layout is owned by the label so need not be freed by the caller. The label is
    /// free to recreate its layout at any time, so it should be considered read-only.
    pub fn get_layout(self: Self) *c.PangoLayout {
        return c.gtk_label_get_layout(self.ptr);
    }

    /// Returns whether lines in the label are automatically wrapped. See Label.set_line_wrap().
    pub fn get_line_wrap(self: Self) bool {
        return (c.gtk_label_get_line_wrap(self.ptr) == 1);
    }

    /// Returns line wrap mode used by the label. See Label.set_line_wrap_mode().
    pub fn get_line_wrap_mode(self: Self) WrapMode {
        return @intToEnum(WrapMode, c.gtk_label_get_line_wrap_mode(self.ptr));
    }

    /// Gets the number of lines to which an ellipsized, wrapping label should be limited.
    /// See Label.set_lines().
    pub fn get_lines(self: Self) c_int {
        return c.gtk_label_get_lines(self.ptr);
    }

    /// Retrieves the target of the mnemonic (keyboard shortcut) of this label. See
    /// Label.set_mnemonic_widget().
    pub fn get_mnemonic_widget(self: Self) ?Widget {
        return if (c.gtk_label_get_mnemonic_widget(self.ptr)) |w| Widget{ .ptr = w } else null;
    }

    /// Gets the selected range of characters in the label, returning `SelectionBounds`
    /// if any text is selected or else `null`.
    pub fn get_selection_bounds(self: Self) ?SelectionBounds {
        var start: c_int = undefined;
        var end: c_int = undefined;
        return if (c.gtk_label_get_selection_bounds(self.ptr, start, end) == 1) SelectionBounds{
            .start = start,
            .end = end,
        } else null;
    }

    /// Returns whether the label’s text is interpreted as marked up with the Pango text markup
    /// language. See Label.set_use_markup().
    pub fn get_use_markup(self: Self) bool {
        return (c.gtk_label_get_use_markup(self.ptr) == 1);
    }

    /// Returns whether an embedded underline in the label indicates a mnemonic. See
    /// Label.set_use_underline().
    pub fn get_use_underline(self: Self) bool {
        return (c.gtk_label_get_use_underline(self.ptr) == 1);
    }

    /// Returns whether the label is in single line mode.
    pub fn get_single_line_mode(self: Self) bool {
        return (c.gtk_label_get_single_line_mode(self.ptr) == 1);
    }

    /// Gets the angle of rotation for the label. See Label.set_angle().
    pub fn get_angle(self: Self) c.gdouble {
        return c.gtk_label_get_angle(self.ptr);
    }

    /// Sets the text of the label. The label is interpreted as including embedded underlines
    /// and/or Pango markup depending on the values of the “use-underline” and “use-markup” properties.
    pub fn set_label(self: Self, label: [:0]const u8) void {
        c.gtk_label_set_label(self.ptr, label.ptr);
    }

    /// Sets whether the text of the label contains markup in Pango’s text markup language.
    /// See Label.set_markup().
    pub fn set_use_markup(self: Self, use: bool) void {
        c.gtk_label_set_use_markup(self.ptr, if (use) 1 else 0);
    }

    /// If true, an underline in the text indicates the next character should be used for
    /// the mnemonic accelerator key.
    pub fn set_use_underline(self: Self, use: bool) void {
        c.gtk_label_set_use_underline(self.ptr, if (use) 1 else 0);
    }

    /// Sets whether the label is in single line mode.
    pub fn set_single_line_mode(self: Self, set: bool) void {
        c.gtk_label_set_single_line_mode(self.ptr, if (set) 1 else 0);
    }

    /// Sets the angle of rotation for the label. An angle of 90 reads from from bottom to top, an angle of
    /// 270, from top to bottom. The angle setting for the label is ignored if the label is selectable,
    /// wrapped, or ellipsized.
    pub fn set_angle(self: Self, angle: c.gdouble) void {
        c.gtk_label_set_angle(self.ptr, angle);
    }

    /// Returns the URI for the currently active link in the label. The active link is the one under the mouse
    /// pointer or, in a selectable label, the link in which the text cursor is currently positioned.
    ///
    /// This function is intended for use in a “activate-link” handler or for use in a “query-tooltip” handler.
    pub fn get_current_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_label_get_current_uri(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    /// Sets whether the label should keep track of clicked links (and use a different color for them).
    pub fn set_track_visited_links(self: Self, track: bool) void {
        c.gtk_label_set_track_visited_links(self.ptr, if (track) 1 else 0);
    }

    /// Returns whether the label is currently keeping track of clicked links.
    pub fn get_track_visited_links(self: Self) bool {
        return (c.gtk_label_get_track_visited_links(self.ptr) == 1);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_label_get_type() or gtype == c.gtk_accel_label_get_type());
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_accel_label(self: Self) ?AccelLabel {
        if (self.isa(AccelLabel)) {
            return AccelLabel{
                .ptr = @ptrCast(*c.GtkAccelLabel, self.ptr),
            };
        } else return null;
    }
};

/// The AccelLabel widget is a subclass of Label that also displays an accelerator
/// key on the right of the label text, e.g. “Ctrl+S”. It is commonly used in menus to
/// show the keyboard short-cuts for commands.
///
/// The accelerator key to display is typically not set explicitly (although it can be,
/// with AccelLabel.set_accel()). Instead, the GtkAccelLabel displays the accelerators
/// which have been added to a particular widget. This widget is set by calling
/// AccelLabel.set_accel_widget().
///
/// For example, a GtkMenuItem widget may have an accelerator added to emit the “activate”
/// signal when the “Ctrl+S” key combination is pressed. A GtkAccelLabel is created and
/// added to the GtkMenuItem, and gtk_accel_label_set_accel_widget() is called with the
/// MenuItem as the second argument. The AccelLabel will now display “Ctrl+S” after its label.
///
///Note that creating a MenuItem with MenuItem.new_with_label() (or one of the similar functions
/// for CheckMenuItem and RadioMenuItem) automatically adds an AccelLabel to the MenuItem and
/// calls gtk_accel_label_set_accel_widget() to set it up for you.
///
/// An AccelLabel will only display accelerators which have `AccelFlags.visible` set (see AccelFlags).
/// An AccelLabel can display multiple accelerators and even signal names, though it is almost always
/// used to display just one accelerator key.
/// ### Creating a simple menu item with an accelerator key.
/// ```C
/// GtkWidget *window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
/// GtkWidget *menu = gtk_menu_new ();
/// GtkWidget *save_item;
/// GtkAccelGroup *accel_group;
///
// Create a GtkAccelGroup and add it to the window.
/// accel_group = gtk_accel_group_new ();
/// gtk_window_add_accel_group (GTK_WINDOW (window), accel_group);
///
/// // Create the menu item using the convenience function.
/// save_item = gtk_menu_item_new_with_label ("Save");
/// gtk_widget_show (save_item);
/// gtk_container_add (GTK_CONTAINER (menu), save_item);
///
/// // Now add the accelerator to the GtkMenuItem. Note that since we
/// // called gtk_menu_item_new_with_label() to create the GtkMenuItem
/// // the GtkAccelLabel is automatically set up to display the
/// // GtkMenuItem accelerators. We just need to make sure we use
/// // GTK_ACCEL_VISIBLE here.
///gtk_widget_add_accelerator (save_item, "activate", accel_group,
///                            GDK_KEY_s, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);
/// ```
/// ### CSS
/// Like GtkLabel, GtkAccelLabel has a main CSS node with the name label. It adds a
/// subnode with name accelerator.
pub const AccelLabel = struct {
    ptr: *c.GtkAccelLabel,

    const Self = @This();

    pub const Accel = struct {
        key: c_uint,
        mask: c.GdkModifierType,
    };

    /// Creates a new GtkAccelLabel.
    pub fn new(label: [:0]const u8) Self {
        return Self{ .ptr = @ptrCast(*c.GtkAccelLabel, c.gtk_accel_label_new(label.ptr)) };
    }

    /// Sets the closure to be monitored by this accelerator label. The closure must be
    /// connected to an accelerator group; see gtk_accel_group_connect(). Passing NULL
    /// for accel_closure will dissociate accel_label from its current closure, if any.
    pub fn set_accel_closure(self: Self, closure: c.GClosure) void {
        c.gtk_accel_label_set_accel_closure(self.ptr, closure);
    }

    /// Fetches the widget monitored by this accelerator label. See AccelLabel.set_accel_widget().
    pub fn get_accel_widget(self: Self) ?Widget {
        return if (c.gtk_accel_label_get_accel_widget(self.ptr)) |w| Widget{ .ptr = w } else null;
    }

    /// Sets the widget to be monitored by this accelerator label. Passing `null`
    // for accel_widget will dissociate accel_label from its current widget, if any.
    pub fn set_accel_label(self: Self, widget: ?Widget) void {
        c.gtk_accel_label_set_accel_widget(self.ptr, if (widget) |w| w else null);
    }

    /// Manually sets a keyval and modifier mask as the accelerator rendered by accel_label.
    ///
    /// If a keyval and modifier are explicitly set then these values are used regardless of
    /// any associated accel closure or widget.
    ///
    /// Providing an accelerator_key of 0 removes the manual setting.
    pub fn set_accel(self: Self, key: c_uint, mods: c.GdkModifierType) void {
        c.gtk_accel_label_set_accel(self.ptr, key, mods);
    }

    /// Gets the keyval and modifier mask set with gtk_accel_label_set_accel().
    pub fn get_accel(self: Self) Accel {
        var key: c_uint = undefined;
        var mask: c.GdkModifierType = undefined;
        c.gtk_accel_label_get_accel(self.ptr, key, mask);
        return Accel{
            .key = key,
            .mask = mask,
        };
    }

    /// Recreates the string representing the accelerator keys. This should not be needed
    /// since the string is automatically updated whenever accelerators are added or removed
    /// from the associated widget.
    pub fn refetch(self: Self) void {
        _ = c.gtk_accel_label_refetch(self.ptr);
    }

    pub fn as_label(self: Self) Label {
        return Label{ .ptr = @ptrCast(*c.GtkLabel, self.ptr) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_accel_label_get_type());
    }
};
