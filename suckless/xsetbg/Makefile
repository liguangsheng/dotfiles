
CC = gcc
CFLAGS = -Wall -Wextra -I/usr/include/X11 -I/usr/include/imlib2
LDLIBS = -lX11 -lImlib2

# 修改下面的变量为您的目标程序名和源文件名
TARGET = xsetbg
SOURCE = xsetbg.c

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE) $(LDLIBS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	mv $(TARGET) /usr/local/bin
