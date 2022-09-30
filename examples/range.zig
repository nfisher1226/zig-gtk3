const std = @import("std");
const allocator = std.heap.page_allocator;
const fmt = std.fmt;
const GTK = @import("gtk");
const gtk = GTK.gtk;
const c = GTK.c;

var scale0: gtk.Scale = undefined;
var scale1: gtk.Scale = undefined;

pub fn main() !void {
    const app = c.gtk_application_new("org.gtk.range-example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    // Call the C function directly to connect our "activate" signal
    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, &activate),
        null,
        null,
        c.G_CONNECT_AFTER,
    );
    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}

// Whatever we connect to the "activate" signal in main() actually builds and runs our application window
fn activate(app: *c.GtkApplication) void {
    // Create an ApplicationWindow using our *GtkApplication pointer, which we then use as a window
    // in order to inherit the Window methods
    const window = gtk.ApplicationWindow.new(app).as_window();
    window.set_title("Range Program");
    window.set_default_size(400, 400);
    window.as_container().set_border_width(10);

    const vbox = gtk.Box.new(.vertical, 5);

    const heading0 = gtk.Label.new(null);
    heading0.set_markup("<b>Linked Range widgets</b>");
    vbox.pack_start(heading0.as_widget(), false, true, 1);

    const text0 = gtk.Label.new("These two range widgets have been given the same Adjustment");
    text0.set_line_wrap(true);
    vbox.pack_start(text0.as_widget(), false, true, 1);

    const scale_adjustment = gtk.Adjustment.new(0.0, 0.0, 100.0, 0.01, 10.0, 20.0);
    scale0 = gtk.Scale.new(.horizontal, scale_adjustment);

    const spinbutton = gtk.SpinButton.new(scale_adjustment, 10.0, 2);

    const hbox0 = gtk.Box.new(.horizontal, 2);
    hbox0.pack_start(scale0.as_widget(), true, true, 1);
    hbox0.pack_start(spinbutton.as_widget(), false, true, 1);
    vbox.pack_start(hbox0.as_widget(), false, true, 1);

    const heading1 = gtk.Label.new(null);
    heading1.set_markup("<b>Orientation and Marks</b>");
    vbox.pack_start(heading1.as_widget(), false, true, 1);

    const text1_value =
        \\This scale can change orientation, and can have marks set
        \\and removed. Use the buttons below to explore these features.
    ;
    const text1 = gtk.Label.new(text1_value);
    vbox.pack_start(text1.as_widget(), false, true, 1);

    scale1 = gtk.Scale.new_with_range(.vertical, 0.0, 100.0, 10.0);
    vbox.pack_start(scale1.as_widget(), true, true, 1);

    const or_button = gtk.Button.new_with_label("Change orientation");
    or_button.set_focus_on_click(false);
    or_button.connect_clicked(@ptrCast(c.GCallback, &change_orientation), null);

    const mark_button = gtk.Button.new_with_label("Set Mark");
    mark_button.set_focus_on_click(false);
    mark_button.connect_clicked(@ptrCast(c.GCallback, &add_mark), null);

    const clr_button = gtk.Button.new_with_label("Clear Marks");
    clr_button.set_focus_on_click(false);
    clr_button.connect_clicked(@ptrCast(c.GCallback, &clear_marks), null);

    const hbox1 = gtk.Box.new(.horizontal, 2);
    hbox1.pack_end(clr_button.as_widget(), false, true, 1);
    hbox1.pack_end(mark_button.as_widget(), false, true, 1);
    hbox1.pack_end(or_button.as_widget(), false, true, 1);
    vbox.pack_start(hbox1.as_widget(), false, true, 1);

    window.as_container().add(vbox.as_widget());
    // show_all() is a Widget method
    window.as_widget().show_all();
}

fn change_orientation() void {
    const orientable = scale1.as_orientable();
    const orientation = orientable.get_orientation();
    switch (orientation) {
        .horizontal => {
            orientable.set_orientation(.vertical);
            scale1.set_value_pos(.top);
        },
        .vertical => {
            orientable.set_orientation(.horizontal);
            scale1.set_value_pos(.left);
        },
    }
}

fn add_mark() void {
    const val = scale1.as_range().get_value();
    const text = fmt.allocPrintZ(allocator, "{d}", .{val}) catch return;
    defer allocator.free(text);
    scale1.add_mark(val, .top, text);
}

fn clear_marks() void {
    scale1.clear_marks();
}
