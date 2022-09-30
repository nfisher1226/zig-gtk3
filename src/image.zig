const c = @import("cimport.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");

/// The GtkImage widget displays an image. Various kinds of object can be
/// displayed as an image; most typically, you would load a GdkPixbuf ("pixel
/// buffer") from a file, and then display that. There’s a convenience function
/// to do this, gtk_image_new_from_file(), used as follows:
/// ```
/// const image = Image.new_from_file ("myfile.png");
/// ```
/// If the file isn’t loaded successfully, the image will contain a “broken image”
/// icon similar to that used in many web browsers. If you want to handle errors
/// in loading the file yourself, for example by displaying an error message,
/// then load the image with gdk_pixbuf_new_from_file(), then create the GtkImage
/// with gtk_image_new_from_pixbuf().
///
/// The image file may contain an animation, if so the GtkImage will display an
/// animation (GdkPixbufAnimation) instead of a static image.
///
/// GtkImage is a subclass of GtkMisc, which implies that you can align it (center,
/// left, right) and add padding to it, using GtkMisc methods.
///
/// GtkImage is a “no window” widget (has no GdkWindow of its own), so by default
/// does not receive events. If you want to receive events on the image, such as
/// button clicks, place the image inside a GtkEventBox, then connect to the event
/// signals on the event box.
///
/// When handling events on the event box, keep in mind that coordinates in the
/// image may be different from event box coordinates due to the alignment and
/// padding settings on the image (see GtkMisc). The simplest way to solve this
/// is to set the alignment to 0.0 (left/top), and set the padding to zero. Then
/// the origin of the image will be the same as the origin of the event box.
///
/// Sometimes an application will want to avoid depending on external data files,
/// such as image files. GTK+ comes with a program to avoid this, called
/// “gdk-pixbuf-csource”. This library allows you to convert an image into a C
/// variable declaration, which can then be loaded into a GdkPixbuf using
/// gdk_pixbuf_new_from_inline().
/// ### CSS
/// GtkImage has a single CSS node with the name image. The style classes may
/// appear on image CSS nodes: .icon-dropshadow, .lowres-icon.
pub const Image = struct {
    ptr: *c.GtkImage,

    const Self = @This();

    pub const IconDesc = struct {
        name: [:0]const u8,
        size: c_uint,
    };

    pub const GIconDesc = struct {
        gicon: *c.gicon,
        size: IconSize,
    };

    /// Built-in stock icon sizes.
    pub const IconSize = enum(c_uint) {
        /// Invalid size.
        invalid = c.GTK_ICON_SIZE_INVALID,
        /// Size appropriate for menus (16px).
        menu = c.GTK_ICON_SIZE_MENU,
        /// Size appropriate for small toolbars (16px).
        small_toolbar = c.GTK_ICON_SIZE_SMALL_TOOLBAR,
        /// Size appropriate for large toolbars (24px).
        large_toolbar = c.GTK_ICON_SIZE_LARGE_TOOLBAR,
        /// Size appropriate for buttons (16px).
        button = c.GTK_ICON_SIZE_BUTTON,
        /// Size appropriate for drag and drop (32px).
        dnd = c.GTK_ICON_SIZE_DND,
        /// Size appropriate for dialogs (48px).
        dialog = c.GTK_ICON_SIZE_DIALOG,
    };

    /// Describes the image data representation used by a GtkImage. If you want
    /// to get the image from the widget, you can only get the currently-stored
    /// representation. e.g. if the gtk_image_get_storage_type() returns
    /// GTK_IMAGE_PIXBUF, then you can call gtk_image_get_pixbuf() but not
    /// gtk_image_get_stock(). For empty images, you can request any storage
    /// type (call any of the "get" functions), but they will all return NULL
    /// values.
    pub const Type = enum(c_uint) {
        /// there is no image displayed by the widget
        empty = c.GTK_IMAGE_TYPE_EMPTY,
        /// the widget contains a GdkPixbuf
        pixbuf = c.GTK_IMAGE_TYPE_PIXBUF,
        /// the widget contains a stock item name
        stock = c.GTK_IMAGE_TYPE_STOCK,
        /// the widget contains a GtkIconSet
        icon_set = c.GTK_IMAGE_TYPE_ICON_SET,
        /// the widget contains a GdkPixbufAnimation
        animation = c.GTK_IMAGE_TYPE_ANIMATION,
        /// the widget contains a named icon. This image type was added in GTK+
        /// 2.6
        icon_name = c.GTK_IMAGE_TYPE_ICON_NAME,
        /// the widget contains a GIcon. This image type was added in GTK+ 2.14
        gicon = c.GTK_IMAGE_TYPE_GICON,
        /// the widget contains a cairo_surface_t. This image type was added in
        /// GTK+ 3.10
        surface = c.GTK_ICON_TYPE_SURFACE,
    };

    /// Gets the GdkPixbuf being displayed by the GtkImage. The storage type of
    /// the image must be GTK_IMAGE_EMPTY or GTK_IMAGE_PIXBUF (see
    /// gtk_image_get_storage_type()). The caller of this function does not own
    /// a reference to the returned pixbuf.
    pub fn get_pixbuf(self: Self) ?*c.GdkPixbuf {
        return if (c.gtk_image_get_pixbuf(self.ptr)) |p| p else null;
    }

    /// Gets the GdkPixbufAnimation being displayed by the GtkImage. The storage
    /// type of the image must be GTK_IMAGE_EMPTY or GTK_IMAGE_ANIMATION (see
    /// gtk_image_get_storage_type()). The caller of this function does not own
    /// a reference to the returned animation.
    pub fn get_animation(self: Self) ?*c.GdkPixbufAnimation {
        return if (c.gtk_image_get_animation(self.ptr)) |a| a else null;
    }

    /// Gets the icon name and size being displayed by the GtkImage. The storage
    /// type of the image must be GTK_IMAGE_EMPTY or GTK_IMAGE_ICON_NAME (see
    /// gtk_image_get_storage_type()). The returned string is owned by the
    /// GtkImage and should not be freed.
    pub fn get_icon_name(self: Self) IconDesc {
        var name: [:0]const u8 = undefined;
        var size: c_uint = undefined;
        c.gtk_image_get_icon_name(self.ptr & name.ptr, &size);
        return IconDesc{
            .name = name,
            .size = size,
        };
    }

    /// Gets the GIcon and size being displayed by the GtkImage. The storage
    /// type of the image must be GTK_IMAGE_EMPTY or GTK_IMAGE_GICON (see
    /// gtk_image_get_storage_type()). The caller of this function does not own
    /// a reference to the returned GIcon.
    pub fn get_gicon(self: Self) GIconDesc {
        var gicon: *c.gicon = undefined;
        var size: IconSize = undefined;
        c.gtk_image_get_gicon(self.ptr, gicon, &size);
        return GIconDesc{
            .gicon = gicon,
            .size = @enumToInt(size),
        };
    }

    /// Gets the type of representation being used by the GtkImage to store image
    /// data. If the GtkImage has no image data, the return value will be
    /// GTK_IMAGE_EMPTY.
    pub fn get_storage_type(self: Self) Type {
        return @intToEnum(Type, c.gtk_image_get_storage_type(self.ptr));
    }

    /// Creates a new GtkImage displaying the file filename . If the file isn’t
    /// found or can’t be loaded, the resulting GtkImage will display a “broken
    /// image” icon. This function never returns NULL, it always returns a valid
    /// GtkImage widget.
    ///
    /// If the file contains an animation, the image will contain an animation.
    ///
    /// If you need to detect failures to load the file, use
    /// gdk_pixbuf_new_from_file() to load the file yourself, then create the
    /// GtkImage from the pixbuf. (Or for animations, use
    /// gdk_pixbuf_animation_new_from_file()).
    ///
    /// The storage type (gtk_image_get_storage_type()) of the returned image is
    /// not defined, it will be whatever is appropriate for displaying the file.
    pub fn new_from_file(file: [:0]const u8) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkImage, c.gtk_image_new_from_file(file.ptr)),
        };
    }

    /// Creates a new GtkImage displaying pixbuf . The GtkImage does not assume
    /// a reference to the pixbuf; you still need to unref it if you own references.
    /// GtkImage will add its own reference rather than adopting yours.
    ///
    /// Note that this function just creates an GtkImage from the pixbuf. The
    /// GtkImage created will not react to state changes. Should you want that,
    /// you should use gtk_image_new_from_icon_name().
    pub fn new_from_pixbuf(pixbuf: ?*c.GdkPixbuf) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkImage, c.gtk_image_new_from_pixbuf(if (pixbuf) |p| p else null)),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_image_get_type());
    }
};
