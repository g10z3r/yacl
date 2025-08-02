const std = @import("std");
const gtk = @cImport({
    @cInclude("gtk/gtk.h");
    @cInclude("gtk/gtkx.h");
    @cInclude("gtksourceview/gtksource.h");
});

const lib = @import("ebnf_playground_lib");

pub fn main() !void {
    gtk.gtk_init(0, null);

    const css_provider = gtk.gtk_css_provider_new();

    const window = gtk.gtk_window_new(gtk.GTK_WINDOW_TOPLEVEL);
    gtk.gtk_window_set_title(@as(*gtk.GtkWindow, @ptrCast(window)), "EBNF Playground");
    gtk.gtk_window_set_default_size(@as(*gtk.GtkWindow, @ptrCast(window)), 800, 600);

    const vbox = gtk.gtk_box_new(gtk.GTK_ORIENTATION_VERTICAL, 5);
    const label = gtk.gtk_label_new("Enter your EBNF below");

    const source_view = gtk.gtk_source_view_new();
    gtk.gtk_source_view_set_show_line_numbers(@as(*gtk.GtkSourceView, @ptrCast(source_view)), 1);

    const scroll = gtk.gtk_scrolled_window_new(null, null);
    gtk.gtk_container_add(@as(*gtk.GtkContainer, @ptrCast(scroll)), source_view);
    gtk.gtk_widget_set_size_request(scroll, 780, 550);

    const frame = gtk.gtk_frame_new(null);
    gtk.gtk_container_set_border_width(@as(*gtk.GtkContainer, @ptrCast(frame)), 10);
    gtk.gtk_container_add(@as(*gtk.GtkContainer, @ptrCast(frame)), scroll);

    gtk.gtk_box_pack_start(@as(*gtk.GtkBox, @ptrCast(vbox)), label, 0, 0, 0);
    gtk.gtk_box_pack_start(@as(*gtk.GtkBox, @ptrCast(vbox)), frame, 1, 1, 0);
    gtk.gtk_container_add(@as(*gtk.GtkContainer, @ptrCast(window)), vbox);

    const context = gtk.gtk_widget_get_style_context(scroll);
    gtk.gtk_style_context_add_provider(
        context,
        @ptrCast(css_provider),
        gtk.GTK_STYLE_PROVIDER_PRIORITY_USER,
    );

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
