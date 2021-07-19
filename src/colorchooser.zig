usingnamespace @import("cimport.zig");
usingnamespace @import("button.zig");
usingnamespace @import("convenience.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");

const std = @import("std");

pub const ColorChooser = struct {
    ptr: *GtkColorChooser,

    pub fn get_rgba(self: ColorChooser) GdkRGBA {
        var rgba: GdkRGBA = undefined;
        _ = gtk_color_chooser_get_rgba(self.ptr, &rgba);
        return rgba;
    }

    pub fn set_rgba(self: ColorChooser, rgba: GdkRGBA) void {
        gtk_color_chooser_set_rgba(self.ptr, &rgba);
    }

    pub fn get_use_alpha(self: ColorChooser) bool {
        return (gtk_color_chooser_get_use_alpha(self.ptr) == 1);
    }

    pub fn set_use_alpha(self: ColorChooser, use: bool) void {
        gtk_color_chooser_set_use_alpha(self.ptr, bool_to_c_int(use));
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_color_chooser_get_type() or ColorChooserButton.is_instance(gtype) or ColorChooserWidget.is_instance(gtype) or ColorChooserDialog.is_instance(gtype));
    }

    pub fn to_color_button(self: ColorChooser) ?ColorButton {
        if (self.as_widget().isa(ColorButton)) {
            return ColorButton{
                .ptr = @ptrCast(*GtkColorButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_widget(self: ColorChooser) ?ColorChooserWidget {
        if (self.as_widget().isa(ColorChooserWidget)) {
            return ColorChooserWidget{
                .ptr = @ptrCast(*GtkColorChooserWidget, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_dialog(self: ColorChooser) ?ColorChooserDialog {
        if (self.as_widget().isa(ColorChooserWidget)) {
            return ColorChooserDialog{
                .ptr = @ptrCast(*GtkColorChooserDialog, self.ptr),
            };
        } else return null;
    }
};

pub const ColorButton = struct {
    ptr: *GtkColorButton,

    pub fn as_color_chooser(self: ColorButton) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*GtkColorChooser, self.ptr),
        };
    }

    pub fn as_button(self: ColorButton) Button {
        return Button{
            .ptr = @ptrCast(*GtkButton, self.ptr),
        };
    }

    pub fn as_widget(self: ColorButton) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_color_button_get_type());
    }
};

pub const ColorChooserWidget = struct {
    ptr: *GtkColorChooserWidget,

    pub fn as_color_chooser(self: ColorChooserWidget) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*GtkColorChooser, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_color_chooser_widget_get_type());
    }
};

pub const ColorChooserDialog = struct {
    ptr: *GtkColorChooserDialog,

    pub fn as_color_chooser(self: ColorChooserDialog) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*GtkColorChooser, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == gtk_color_chooser_dialog_get_type());
    }
};
