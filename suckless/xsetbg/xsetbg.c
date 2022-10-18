#include <X11/Xlib.h>
#include <Imlib2.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void usage(char *commandline) {
  printf("Syntax: %s <image>\n", commandline);
}

int load_image_fill(Display *display, int screen, const char *file, Imlib_Image image) {
  Imlib_Image buffer = imlib_load_image(file);

  if (!buffer)
    return 0;

  imlib_context_set_image(buffer);
  int imgW = imlib_image_get_width();
  int imgH = imlib_image_get_height();

  imlib_context_set_image(image);
  imlib_blend_image_onto_image(buffer, 0, 0, 0, imgW, imgH, 0, 0, DisplayWidth(display, screen), DisplayHeight(display, screen));

  imlib_context_set_image(buffer);
  imlib_free_image();
  imlib_context_set_image(image);

  return 1;
}

int main(int argc, char **argv) {
  if (argc != 2) {
    usage(argv[0]);
    return 1;
  }

  const char *file = argv[1];

  Display* display = XOpenDisplay(NULL);
  if (!display) {
    fprintf(stderr, "Cannot open X11 display \n");
    return 1;
  }

  int screen = DefaultScreen(display);
  Imlib_Context *context = imlib_context_new();
  imlib_context_push(context);

  Visual *vis = DefaultVisual(display, screen);
  Colormap cm = DefaultColormap(display, screen);
  int width = DisplayWidth(display, screen);
  int height = DisplayHeight(display, screen);
  int depth = DefaultDepth(display, screen);

  Pixmap pixmap = XCreatePixmap(display, RootWindow(display, screen), width, height, depth);

  imlib_context_set_display(display);
  imlib_context_set_visual(vis);
  imlib_context_set_colormap(cm);
  imlib_context_set_drawable(pixmap);

  imlib_context_set_dither(1);
  imlib_context_set_blend(1);

  Imlib_Image image = imlib_create_image(width, height);
  imlib_context_set_image(image);

  imlib_context_set_color(0, 0, 0, 255);
  imlib_image_fill_rectangle(0, 0, width, height);

  if (load_image_fill(display, screen, file, image) == 0) {
    fprintf(stderr, "Bad image (%s)\n", file);
    imlib_free_image();
    imlib_context_pop();
    imlib_context_free(context);
    XFreePixmap(display, pixmap);
    XCloseDisplay(display);
    return 1;
  }

  imlib_render_image_on_drawable(0, 0);
  XSetWindowBackgroundPixmap(display, RootWindow(display, screen), pixmap);
  XClearWindow(display, RootWindow(display, screen));
  XFlush(display);
  XSync(display, False);

  imlib_free_image();
  imlib_context_pop();
  imlib_context_free(context);
  XFreePixmap(display, pixmap);
  XCloseDisplay(display);

  return 0;
}

