local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

mywidgets = {}

local fg_widget = "#eee"
local bg_widget = "#222"
local widget_font = beautiful.font
local configuration_bin = gears.filesystem.get_configuration_dir() .. "bin/"
local margin_vert = 6

mywidgets.separator = wibox.widget{
   opacity = 0.5,
   widget = wibox.widget.textbox,
   text = "",
   font = "JetBrainsMono Nerd Font 12",
}

local function create_fixed_text(text, width)
   return wibox.widget{
	  text = text,
	  font = "JetBrainsMono Nerd Font 9",
	  align  = 'center',
	  valign = 'center',
	  forced_width = width,
	  widget = wibox.widget.textbox
   }
end

local function create_icon_widget(args)
   return {
	  {
		 {
			{
			   {
				  widget = args.left_widget,
				  font = args.left_font or "JetBrainsMono Nerd Font 9",
			   },
			   left = 3,
			   right = 3,
			   top = 0,
			   bottom = 0,
			   widget = wibox.container.margin,
			},
			shape = gears.shape.partially_rounded_rect,
			fg = args.left_fg or beautiful.fg_widget or fg_widget,
			bg = args.left_bg or beautiful.bg_widget or bg_widget,
			widget = wibox.container.background,
		 },

		 left = 0,
		 right = 0,
		 top = margin_vert,
		 bottom = margin_vert,
		 widget = wibox.container.margin,
	  },
	  {
		 {
			{
			   {
				  widget = args.right_widget,
				  font = args.font or widget_font,
			   },
			   left = 0,
			   right = 2,
			   top = 0,
			   bottom = 0,
			   widget = wibox.container.margin,
			},
			shape = gears.shape.partially_rounded_rect,
			fg = args.left_fg or beautiful.fg_widget or fg_widget,
			bg = args.left_bg or beautiful.bg_widget or bg_widget,
			widget = wibox.container.background,
		 },

		 left = 0,
		 right = 3,
		 top = margin_vert,
		 bottom = margin_vert,
		 widget = wibox.container.margin,
	  },
	  spacing = 0,
	  layout = wibox.layout.fixed.horizontal,
   }
end

-- Create a kernel widget
local mykernel = awful.widget.watch("uname -r", 600, function(widget, stdout)
									   widget:set_text(stdout)
end, wibox.widget.textbox())
mywidgets.container_kernel_widget = create_icon_widget({
	  left_widget = create_fixed_text("", 14),
	  right_widget = mykernel,
})

-- Create a uptime widget
local myuptime = awful.widget.watch(configuration_bin .. "uptime.sh", 1, function(widget, stdout)
									   widget:set_text(stdout)
end, uptime_widget)
mywidgets.container_uptime_widget = create_icon_widget({
	  left_widget = create_fixed_text("", 14),
	  right_widget = myuptime,
})

-- Create a cpu widget
mycpu = awful.widget.watch(configuration_bin .. "cpu.sh", 1, function(widget, stdout)
							  widget:set_text(string.format("%.1f%%", stdout))
end, wibox.widget.textbox())
mywidgets.container_cpu_widget = create_icon_widget({
	  left_widget = create_fixed_text("﬙", 14),
	  right_widget = mycpu,
})

-- Create a meminfo widget
mymeminfo = awful.widget.watch(configuration_bin .. "meminfo.sh", 1, function(widget, stdout)
								  local m = load("return " .. stdout)()
								  m.Used = m.MemTotal - m.MemFree - m.Buffers - m.Cached - m.SReclaimable - m.Shmem
								  m.UsedPercent = m.Used / m.MemTotal
								  local text = string.format("%.2fGB(%.0f%%)", m.Used / 1024 / 1024, m.UsedPercent * 100)
								  widget:set_text(text)
end, wibox.widget.textbox())
mywidgets.container_meminfo_widget = create_icon_widget({
	  left_widget = create_fixed_text("", 14),
	  left_font = "JetBrainsMono Nerd Font 11",
	  right_widget = mymeminfo,
})

-- Create a disk widget
mydisk = awful.widget.watch(configuration_bin .. "disk.sh", 1, function(widget, stdout)
							   widget:set_text(stdout)
end, wibox.widget.textbox())
mywidgets.container_disk_widget = create_icon_widget({
	  left_widget = create_fixed_text("", 14),
	  left_font = "JetBrainsMono Nerd Font 10",
	  right_widget = mydisk,
})

-- Create a traffic widget
mytraffic = awful.widget.watch(
   configuration_bin .. "traffic.sh",
   1,
   function(widget, stdout)
	  local bytes = tonumber(stdout)
	  local kilobytes = bytes / 1024
	  local megabytes = kilobytes / 1024
	  local gigabytes = megabytes / 1024

	  local formattedValue = ""
	  if gigabytes >= 1 then
		 formattedValue = string.format("%.2fGB/s", gigabytes)
	  elseif megabytes >= 1 then
		 formattedValue = string.format("%.2fMB/s", megabytes)
	  else
		 formattedValue = string.format("%.0fKB/s", kilobytes)
	  end

	  widget:set_text(formattedValue)
   end,
   wibox.widget.textbox())
mywidgets.container_traffic_widget = create_icon_widget({
	  left_widget = create_fixed_text("李", 16),
	  left_font = "JetBrainsMono Nerd Font 11",
	  right_widget = mytraffic,
})

-- Create a textclock widget
local format = "%Y-%m-%d %H:%M:%S"
local mytextclock = wibox.widget.textclock(format, 1, nil)
mywidgets.container_clock_widget = create_icon_widget({
	  left_widget = create_fixed_text("", 16),
	  right_widget = mytextclock,
})

-- Create a systray widget
mywidgets.container_systray_widget = {
   {
	  {
		 {
			{
			   widget = wibox.widget.systray,
			   font = widget_font,
			},
			left = 0,
			right = 2,
			top = 0,
			bottom = 0,
			widget = wibox.container.margin,
		 },
		 fg = fg_widget,
		 bg = beautiful.bg_normal,
		 widget = wibox.container.background,
	  },

	  left = 2,
	  right = 2,
	  top = margin_vert,
	  bottom = margin_vert,
	  widget = wibox.container.margin,
   },
   spacing = 5,
   layout = wibox.layout.fixed.horizontal,
}

function mywidgets.create_layoutbox_widget(screen)
   local mylayoutbox = awful.widget.layoutbox(screen)
   mylayoutbox:buttons(gears.table.join(
						  awful.button({}, 1, function()
								awful.layout.inc(1)
						  end),
						  awful.button({}, 3, function()
								awful.layout.inc(-1)
						  end),
						  awful.button({}, 4, function()
								awful.layout.inc(1)
						  end),
						  awful.button({}, 5, function()
								awful.layout.inc(-1)
						  end)
   ))

   return wibox.container.margin(mylayoutbox, margin_vert, margin_vert, margin_vert, margin_vert)
end

return mywidgets
