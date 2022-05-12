const c = @import("cimport.zig");

/// Enum AccelFlags
pub const AccelFlags = enum(c_uint) {
    visible = c.GTK_ACCEL_VISIBLE,
    locked = c.GTK_ACCEL_LOCKED,
    mask = c.GTK_ACCEL_MASK,
};

/// enum ConnectFlags
pub const ConnectFlags = enum(c_uint) {
    after = c.G_CONNECT_AFTER,
    swapped = c.G_CONNECT_SWAPPED,
};

/// enum BaselinePosition
pub const BaselinePosition = enum(c_uint) {
    top = c.GTK_BASELINE_POSITION_TOP,
    center = c.GTK_BASELINE_POSITION_CENTER,
    bottom = c.GTK_BASELINE_POSITION_BOTTOM,
};

/// enum DeleteType
pub const DeleteType = enum(c_uint) {
    chars = c.GTK_DELETE_CHARS,
    word_ends = c.GTK_DELETE_WORD_ENDS,
    words = c.GTK_DELETE_WORDS,
    line_ends = c.GTK_DELETE_LINE_ENDS,
    lines = c.GTK_DELETE_LINES,
    paragraph_ends = c.GTK_DELETE_PARAGRAPH_ENDS,
    paragraphs = c.GTK_DELETE_PARAGRAPHS,
    whitespace = c.GTK_DELETE_WHITESPACE,
};

/// enum DirectionType
pub const DirectionType = enum(c_uint) {
    forward = c.GTK_DIR_TAB_FORWARD,
    backward = c.GTK_DIR_TAB_BACKWARD,
    up = c.GTK_DIR_UP,
    down = c.GTK_DIR_DOWN,
    left = c.GTK_DIR_LEFT,
    right = c.GTK_DIR_RIGHT,
};

/// enum IconSize
pub const IconSize = enum(c_uint) {
    invalid = c.GTK_ICON_SIZE_INVALID,
    menu = c.GTK_ICON_SIZE_MENU,
    small_toolbar = c.GTK_ICON_SIZE_SMALL_TOOLBAR,
    large_toolbar = c.GTK_ICON_SIZE_LARGE_TOOLBAR,
    button = c.GTK_ICON_SIZE_BUTTON,
    dnd = c.GTK_ICON_SIZE_DND,
    dialog = c.GTK_ICON_SIZE_DIALOG,
};

/// enum Justification
pub const Justification = enum(c_uint) {
    left = c.GTK_JUSTIFY_LEFT,
    right = c.GTK_JUSTIFY_RIGHT,
    center = c.GTK_JUSTIFY_CENTER,
    fill = c.GTK_JUSTIFY_FILL,
};

/// Enum License
pub const License = enum(c_uint) {
    unknown = c.GTK_LICENSE_UNKNOWN,
    custon = c.GTK_LICENSE_CUSTOM,
    gpl2 = c.GTK_LICENSE_GPL_2_0,
    gtpl3 = c.GTK_LICENSE_GPL_3_0,
    lgpl2_1 = c.GTK_LICENSE_LGPL_2_1,
    lgpl3 = c.GTK_LICENSE_LGPL_3_0,
    bsd = c.GTK_LICENSE_BSD,
    mit_x11 = c.GTK_LICENSE_MIT_X11,
    artistic = c.GTK_LICENSE_ARTISTIC,
    gpl2_only = c.GTK_LICENSE_GPL_2_0_ONLY,
    gpl3_only = c.GTK_LICENSE_GPL_3_0_ONLY,
    lgpl2_1_only = c.GTK_LICENSE_LGPL_2_1_ONLY,
    lgpl3_only = c.GTK_LICENSE_LGPL_3_0_ONLY,
    agpl3 = c.GTK_LICENSE_AGPL_3_0,
    agpl3_only = c.GTK_LICENSE_AGPL_3_0_ONLY,
    bsd3 = c.GTK_LICENSE_BSD_3,
    apache2 = c.GTK_LICENSE_APACHE_2_0,
    mpl2 = c.GTK_LICENSE_MPL_2_0,
};

/// Enum ModifierType
pub const ModifierType = enum(c_uint) {
    shift_mask = c.GDK_SHIFT_MASK,
    mod1_mask = c.GDK_MOD1_MASK,
    control_mask = c.GDK_CONTROL_MASK,
};

/// enum Orientation
pub const Orientation = enum(c_uint) {
    horizontal = c.GTK_ORIENTATION_HORIZONTAL,
    vertical = c.GTK_ORIENTATION_VERTICAL,
};

/// Enum PackType
pub const PackType = enum(c_uint) {
    end = c.GTK_PACK_END,
    start = c.GTK_PACK_START,
};

/// Enum PositionType
pub const PositionType = enum(c_uint) {
    left = c.GTK_POS_LEFT,
    right = c.GTK_POS_RIGHT,
    top = c.GTK_POS_TOP,
    bottom = c.GTK_POS_BOTTOM,
};

/// Enum ReliefStyle
pub const ReliefStyle = enum(c_uint) {
    normal = c.GTK_RELIEF_NORMAL,
    none = c.GTK_RELIEF_NONE,
};

/// Enum SelectionMode
pub const SelectionMode = enum(c_uint) {
    none = c.GTK_SELECTION_NONE,
    single = c.GTK_SELECTION_SINGLE,
    browse = c.GTK_SELECTION_BROWSE,
    multiple = c.GTK_SELECTION_MULTIPLE,
};

/// Enum SensitivityType
pub const SensitivityType = enum(c_uint) {
    auto = c.GTK_SENSITIVITY_AUTO,
    on = c.GTK_SENSITIVITY_ON,
    off = c.GTK_SENSITIVITY_OFF,
};

/// Used to change the appearance of an outline typically provided by a GtkFrame.
///
/// Note that many themes do not differentiate the appearance of the various
/// shadow types: Either their is no visible shadow (GTK_SHADOW_NONE ), or there
/// is (any other value).
pub const ShadowType = enum(c_uint) {
    none = c.GTK_SHADOW_NONE,
    in = c.GTK_SHADOW_IN,
    out = c.GTK_SHADOW_OUT,
    etched_in = c.GTK_SHADOW_ETCHED_IN,
    etched_out = c.GTK_SHADOW_ETCHED_OUT,
};

/// enum SpawnFlags
pub const SpawnFlags = enum(c_uint) {
    default = c.G_SPAWN_DEFAULT,
    leave_descriptors_open = c.G_SPAWN_LEAVE_DESCRIPTORS_OPEN,
    do_not_reap_child = c.G_SPAWN_DO_NOT_REAP_CHILD,
    search_path = c.G_SPAWN_SEARCH_PATH,
    stdout_to_dev_null = c.G_SPAWN_STDOUT_TO_DEV_NULL,
    stderr_to_dev_null = c.G_SPAWN_STDERR_TO_DEV_NULL,
    child_inherits_stdin = c.G_SPAWN_CHILD_INHERITS_STDIN,
    file_and_argv_zero = c.G_SPAWN_FILE_AND_ARGV_ZERO,
    search_path_from_envp = c.G_SPAWN_SEARCH_PATH_FROM_ENVP,
    cloexec_pipes = c.G_SPAWN_CLOEXEC_PIPES,
};

/// Enum SpinButtonUpdatePolicy
pub const SpinButtonUpdatePolicy = enum(c_uint) {
    always = c.GTK_UPDATE_ALWAYS,
    if_valid = c.GTK_UPDATE_IF_VALID,
};

/// Enum SpinType
pub const SpinType = enum(c_uint) {
    step_forward = c.GTK_SPIN_STEP_FORWARD,
    step_backward = c.GTK_SPIN_STEP_BACKWARD,
    page_forward = c.GTK_SPIN_PAGE_FORWARD,
    page_backward = c.GTK_SPIN_PAGE_BACKWARD,
    home = c.GTK_SPIN_HOME,
    end = c.GTK_SPIN_END,
    user_defined = c.GTK_SPIN_USER_DEFINED,
};

/// enum WindowType
pub const WindowType = enum(c_uint) {
    toplevel = c.GTK_WINDOW_TOPLEVEL,
    popup = c.GTK_WINDOW_POPUP,
};
