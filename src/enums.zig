usingnamespace @import("cimport.zig");

/// enum ConnectFlags
pub const ConnectFlags = enum {
    after,
    swapped,

    pub fn parse(self: ConnectFlags) GConnectFlags {
        return switch (self) {
            .after => G_CONNECT_AFTER,
            .swapped => G_CONNECT_SWAPPED,
        };
    }
};

/// enum IconSize
pub const IconSize = enum {
    invalid,
    menu,
    small_toolbar,
    large_toolbar,
    button,
    dnd,
    dialog,

    /// Parses an IconSize into a GtkIconSize
    pub fn parse(self: IconSize) GtkIconSize {
        return switch (self) {
            .invalid => GTK_ICON_SIZE_INVALID,
            .menu => GTK_ICON_SIZE_MENU,
            .small_toolbar => GTK_ICON_SIZE_SMALL_TOOLBAR,
            .large_toolbar => GTK_ICON_SIZE_LARGE_TOOLBAR,
            .button => GTK_ICON_SIZE_BUTTON,
            .dnd => GTK_ICON_SIZE_DND,
            .dialog => GTK_ICON_SIZE_DIALOG,
        };
    }
};

/// enum BaselinePosition
pub const BaselinePosition = enum {
    top,
    center,
    bottom,

    pub fn parse(self: BaselinePosition) GtkBaselinePosition {
        return switch (self) {
            .top => GTK_BASELINE_POSITION_TOP,
            .center => GTK_BASELINE_POSITION_CENTER,
            .bottom => GTK_BASELINE_POSITION_BOTTOM,
        };
    }
};

/// enum DeleteType
pub const DeleteType = enum {
    chars,
    word_ends,
    words,
    line_ends,
    lines,
    paragraph_ends,
    paragraphs,
    whitespace,

    pub fn parse(self: DeleteType) GtkDeleteType {
        return switch (self) {
            .chars => GTK_DELETE_CHARS,
            .word_ends => GTK_DELETE_WORD_ENDS,
            .words => GTK_DELETE_WORDS,
            .line_ends => GTK_DELETE_LINE_ENDS,
            .lines => GTK_DELETE_LINES,
            .paragraph_ends => GTK_DELETE_PARAGRAPH_ENDS,
            .paragraphs => GTK_DELETE_PARAGRAPHS,
            .whitespace => GTK_DELETE_WHITESPACE,
        };
    }
};

/// enum DirectionType
pub const DirectionType = enum {
    tab_forward,
    tab_backward,
    up,
    down,
    left,
    right,

    pub fn parse(self: DirectionType) GtkDirectionType {
        return switch (self) {
            .forward => GTK_DIR_TAB_FORWARD,
            .backward => GTK_DIR_TAB_BACKWARD,
            .up => GTK_DIR_UP,
            .down => GTK_DIR_DOWN,
            .left => GTK_DIR_LEFT,
            .right => GTK_DIR_RIGHT,
        };
    }
};

/// enum Orientation
pub const Orientation = enum {
    horizontal,
    vertical,

    pub fn parse(self: Orientation) GtkOrientation {
        return switch (self) {
            .horizontal => GTK_ORIENTATION_HORIZONTAL,
            .vertical => GTK_ORIENTATION_VERTICAL,
        };
    }

};

/// enum WindowType
pub const WindowType = enum {
    toplevel,
    popup,

    pub fn parse(self: WindowType) GtkWindowType {
        return switch (self) {
            .toplevel => GTK_WINDOW_TOPLEVEL,
            .popup => GTK_WINDOW_POPUP,
        };
    }
};

/// Enum PackType
pub const PackType = enum {
    start,
    end,

    pub fn parse(self: PackType) GtkPackType {
        return switch (self) {
            .end => GTK_PACK_END,
            .start => GTK_PACK_START,
        };
    }
};

/// Enum PositionType
pub const PositionType = enum {
    left,
    right,
    top,
    bottom,

    pub fn parse(self: PositionType) GtkPositionType {
        return switch (self) {
            .left => GTK_POS_LEFT,
            .right => GTK_POS_RIGHT,
            .top => GTK_POS_TOP,
            .bottom => GTK_POS_BOTTOM,
        };
    }
};

/// Enum ReliefStyle
pub const ReliefStyle = enum {
    normal,
    none,

    pub fn parse(self: ReliefStyle) GtkReliefStyle {
        return switch (self) {
            .normal => GTK_RELIEF_NORMAL,
            .none => GTK_RELIEF_NONE,
        };
    }
};

/// Enum ModifierType
pub const ModifierType = enum {
    shift_mask,
    mod1_mask,
    control_mask,

    pub fn parse(self: ModifierType) GdkModifierType {
        return switch (self) {
            .shift_mask => GDK_SHIFT_MASK,
            .mod1_mask => GDK_MOD1_MASK,
            .control_mask => GDK_CONTROL_MASK,
        };
    }
};

/// Enum AccelFlags
pub const AccelFlags = enum {
    visible,
    locked,
    mask,

    pub fn parse(self: AccelFlags) GtkAccelFlags {
        return switch (self) {
            .visible => GTK_ACCEL_VISIBLE,
            .locked => GTK_ACCEL_LOCKED,
            .mask => GTK_ACCEL_MASK,
        };
    }
};

/// enum SpawnFlags
pub const SpawnFlags = enum {
    default,
    leave_descriptors_open,
    do_not_reap_child,
    search_path,
    stdout_to_dev_null,
    stderr_to_dev_null,
    child_inherits_stdin,
    file_and_argv_zero,
    search_path_from_envp,
    cloexec_pipes,

    pub fn parse(self: SpawnFlags) GSpawnFlags {
        return switch (self) {
            .default => G_SPAWN_DEFAULT,
            .leave_descriptors_open => G_SPAWN_LEAVE_DESCRIPTORS_OPEN,
            .do_not_reap_child => G_SPAWN_DO_NOT_REAP_CHILD,
            .search_path => G_SPAWN_SEARCH_PATH,
            .stdout_to_dev_null => G_SPAWN_STDOUT_TO_DEV_NULL,
            .stderr_to_dev_null => G_SPAWN_STDERR_TO_DEV_NULL,
            .child_inherits_stdin => G_SPAWN_CHILD_INHERITS_STDIN,
            .file_and_argv_zero => G_SPAWN_FILE_AND_ARGV_ZERO,
            .search_path_from_envp => G_SPAWN_SEARCH_PATH_FROM_ENVP,
            .cloexec_pipes => G_SPAWN_CLOEXEC_PIPES,
        };
    }
};
