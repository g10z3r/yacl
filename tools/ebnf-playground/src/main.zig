const std = @import("std");
const gtk = @cImport({
    @cInclude("gtk/gtk.h");
});

const lib = @import("ebnf_playground_lib");

pub fn main() !void {
    gtk.gtk_init(0, null);

    const window = gtk.gtk_window_new(gtk.GTK_WINDOW_TOPLEVEL);
    gtk.gtk_window_set_title(@as(*gtk.GtkWindow, @ptrCast(window)), "Hello, Zig + GTK!");
    gtk.gtk_window_set_default_size(@as(*gtk.GtkWindow, @ptrCast(window)), 400, 200);

    const destroy_callback = struct {
        fn callback() callconv(.C) void {
            gtk.gtk_main_quit();
        }
    }.callback;

    _ = gtk.g_signal_connect_data(
        window,
        "destroy",
        @as(fn () callconv(.C) void, destroy_callback),
        null,
        null,
        0,
    );

    gtk.gtk_widget_show_all(window);
    gtk.gtk_main();
}
