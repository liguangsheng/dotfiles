local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local fg_widget = "#eee"
local bg_widget = "#222"
local widget_font = beautiful.font
local icon_font = "Symbols Nerd Font Mono"
local configuration_bin = gears.filesystem.get_configuration_dir() .. "bin/"
local margin_vert = 6

local function icon_font_with_size(size)
   return icon_font .. " " .. size
end

local function create_separator_widget()
   return wibox.widget {
	  opacity = 0.5,
	  widget = wibox.widget.textbox,
	  text = "",
	  font = icon_font_with_size(10),
   }
end

local function create_icon_widget(text, args)
   if args == nil then args = {} end
   return wibox.widget {
	  text         = text,
	  font         = icon_font_with_size(args.font_size or 10),
	  align        = 'center',
	  valign       = 'center',
	  forced_width = args.forced_width or 16,
	  widget       = wibox.widget.textbox
   }
end

local function create_boxed_widget(args)
   local icon = nil
   if args.left_widget then
	  icon = {
		 {
			{
			   {
				  widget = args.left_widget,
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
	  }
   end

   local text = {
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
   }
   local wgt = {
	  icon,
	  text,
	  spacing = 0,
	  layout = wibox.layout.fixed.horizontal,
   }
   return wgt
end

-- kernel widget
local function create_kernel_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("", { forced_width = 14 }),
		 right_widget = awful.widget.watch("uname -r", 600, function(widget, stdout)
											  widget:set_text(stdout)
		 end, wibox.widget.textbox()),
   })
end

-- uptime widget
local function create_uptime_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("", { font_size = 9 }),
		 right_widget = awful.widget.watch(configuration_bin .. "uptime.sh", 1, function(widget, stdout)
											  widget:set_text(stdout)
		 end, wibox.widget.textbox()),
   })
end

-- cpu widget
local function create_cpu_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("", { font_size = 9 }),
		 right_widget = awful.widget.watch(configuration_bin .. "cpu.sh", 1, function(widget, stdout)
											  widget:set_text(string.format("%.1f%%", stdout))
		 end, wibox.widget.textbox()),
   })
end

-- meminfo widget
local function create_meminfo_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("",{  font_size = 9 }),
		 right_widget = awful.widget.watch(configuration_bin .. "meminfo.sh", 1, function(widget, stdout)
											  local m = load("return " .. stdout)()
											  m.Used = m.MemTotal - m.MemFree - m.Buffers - m.Cached - m.SReclaimable - m.Shmem
											  m.UsedPercent = m.Used / m.MemTotal
											  local text = string.format("%.2fGB(%.0f%%)", m.Used / 1024 / 1024, m.UsedPercent * 100)
											  widget:set_text(text)
		 end, wibox.widget.textbox()),
   })
end

-- disk widget
local function create_disk_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("", { font_size = 9 }),
		 right_widget = awful.widget.watch(configuration_bin .. "disk.sh", 1, function(widget, stdout)
											  widget:set_text(stdout)
		 end, wibox.widget.textbox()),
   })
end

-- traffic widget
local function create_traffic_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("", { font_size = 9 }),
		 right_widget = awful.widget.watch(
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
			wibox.widget.textbox()),
   })
end

-- textclock widget
local function create_clock_widget()
   return create_boxed_widget({
		 left_widget = create_icon_widget("", { font_size = 9 }),
		 right_widget = wibox.widget.textclock("%Y-%m-%d %H:%M:%S", 1, nil),
   })
end

-- systray widget
local function create_systray_widget()
   return {
	  {
		 {
			{
			   {
				  widget = wibox.widget.systray,
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
end

local function create_layoutbox_widget(screen)
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

local function create_taglist_widget(s)
   local taglist_buttons = gears.table.join(
	  awful.button({}, 1, function(t)
			t:view_only()
	  end),
	  awful.button({ modkey }, 1, function(t)
			if client.focus then
			   client.focus:move_to_tag(t)
			end
	  end),
	  awful.button({}, 3, awful.tag.viewtoggle),
	  awful.button({ modkey }, 3, function(t)
			if client.focus then
			   client.focus:toggle_tag(t)
			end
	  end),
	  awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
	  end),
	  awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
	  end)
   )


   return awful.widget.taglist({
		 screen = s,
		 filter = awful.widget.taglist.filter.all,
		 buttons = taglist_buttons,
		 widget_template = {
			{
			   {
				  {
					 {
						id = "icon_role",
						widget = wibox.widget.imagebox,
					 },
					 widget = wibox.container.margin,
				  },
				  {
					 id = "text_role",
					 widget = wibox.widget.textbox,
				  },
				  layout = wibox.layout.fixed.horizontal,
			   },

			   widget = wibox.container.place,
			   forced_height = beautiful.bar_height,
			   forced_width = 32,
			},
			id = "background_role",
			widget = wibox.container.background,
		 },
   })
end

local function create_tasklist_widget(s)
   local tasklist_buttons = gears.table.join(
	  awful.button({}, 1, function(c)
			if c == client.focus then
			   c.minimized = true
			else
			   c:emit_signal("request::activate", "tasklist", { raise = true })
			end
	  end),
	  awful.button({}, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
	  end),
	  awful.button({}, 4, function()
			awful.client.focus.byidx(1)
	  end),
	  awful.button({}, 5, function()
			awful.client.focus.byidx(-1)
	  end)
   )

   return awful.widget.tasklist({
		 screen = s,
		 filter = awful.widget.tasklist.filter.currenttags,
		 buttons = tasklist_buttons,
		 widget_template = {
			{
			   {
				  {
					 {
						id = "icon_role",
						widget = wibox.widget.imagebox,
						forced_height = 18,
						forced_width = 18,
					 },
					 forced_height = 30,
					 forced_width = 30,
					 widget = wibox.container.place,
				  },
				  {
					 id = "text_role",
					 widget = wibox.widget.textbox,
				  },
				  layout = wibox.layout.fixed.horizontal,
			   },
			   left = 5,
			   right = 5,
			   widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		 },
   })
end

local function create_launcher_widget()
   mymainmenu = awful.menu({
		 items = {
			{
			   "awesome",
			   {
				  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
				  { "manual", terminal .. " -e man awesome" },
				  { "edit config", editor_cmd .. " " .. awesome.conffile },
				  { "restart", awesome.restart },
				  { "quit", function() awesome.quit() end },
			   },
			   beautiful.awesome_icon
			},
			{ "open terminal", terminal },
			{ "reboot", terminal .. " -e reboot"},
			{ "shutdown", terminal .. " -e shutdown -h now"},
		 }
   })

   return awful.widget.launcher({ image = beautiful.awesome_icon,
								  menu = mymainmenu })
end


local function init_screen(s)
   s.widgets = {
	  promptbox = awful.widget.prompt(),
	  taglist = create_taglist_widget(s),
	  tasklist = create_tasklist_widget(s),
	  layoutbox = create_layoutbox_widget(s),
	  separator = create_separator_widget(),
	  kernel = create_kernel_widget(),
	  uptime = create_uptime_widget(),
	  cpu = create_cpu_widget(),
	  meminfo = create_meminfo_widget(),
	  disk = create_disk_widget(),
	  traffic = create_traffic_widget(),
	  clock = create_clock_widget(),
	  systray = create_systray_widget(),
	  launcher = create_launcher_widget(),
   }

   -- Create the wibox
   s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.bar_height, opacity = 0.75 })

   -- Add widgets to the wibox
   s.mywibox:setup({
		 layout = wibox.layout.align.horizontal,
		 { -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			s.widgets.taglist,
			s.widgets.layoutbox,
			s.widgets.promptbox,
		 },
		 s.widgets.tasklist, -- Middle widget
		 {                -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			s.widgets.kernel,
			s.widgets.separator,
			s.widgets.uptime,
			s.widgets.separator,
			s.widgets.traffic,
			s.widgets.separator,
			s.widgets.cpu,
			s.widgets.separator,
			s.widgets.meminfo,
			s.widgets.separator,
			s.widgets.disk,
			s.widgets.separator,
			s.widgets.clock,
			s.widgets.separator,
			s.widgets.systray,
			s.widgets.launcher,
		 },
   })
end

return {
   init_screen = init_screen,
}
