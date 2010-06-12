require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("vicious")
require("scratch")

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------

-- Load theme
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- Common programs
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Modifier key
modkey = "Mod4"

-- Available layouts
layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

--------------------------------------------------------------------------------
-- Tags
--------------------------------------------------------------------------------

-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end

--------------------------------------------------------------------------------
-- Markup helpers
--------------------------------------------------------------------------------

function fg(color, text)
    return '<span color="' .. color .. '">' .. text .. '</span>'
end

function bold(text)
    return '<b>' .. text .. '</b>'
end

function hilight(text)
    return bold(fg(beautiful.fg_title, text))
end

function widget_set(label, text)
    return label and hilight(label) .. " " .. text or text
end

--------------------------------------------------------------------------------
-- Widgets
--------------------------------------------------------------------------------

-- Separators
separator = widget({ type = "textbox" })
separator.text = fg(beautiful.bg_focus, " | ")

spacer = widget({ type = "textbox" })
spacer.text = " "

-- Clock
clockwidget = awful.widget.textclock({ }, "%a %d.%m.%Y %T", 1)

-- CPU
cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu,
    widget_set("CPU", "$1%"), 3)

-- Memory
memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem,
    widget_set("RAM", "$2" .. hilight("/") .. "$3MB"), 13)

-- Network
netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net,
    widget_set("NET", fg("#ff5050", "${eth0 down_kb}") .. hilight(" :: ") ..
                      fg("#9eee81", "${eth0 up_kb}")), 3)

-- Launcher
menu_awesome = {
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
    { "restart", awesome.restart },
    { "quit", awesome.quit },
}

menu_main = awful.menu({
    items = {
        { "awesome", menu_awesome, beautiful.awesome_icon },
        { "open terminal", terminal },
    }
})

launcher = awful.widget.launcher({
    image = image(beautiful.awesome_icon),
    menu = menu_main,
})

-- Systray
systray = widget({ type = "systray" })

-- Statusbar
statusbar = {}
promptbox = {}
layoutbox = {}
taglist = {}
taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)

tasklist = {}
tasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ width = 250 })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    promptbox[s] = awful.widget.prompt({
        layout = awful.widget.layout.horizontal.leftright
    })

    -- Create an imagebox widget indicating the current layout
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
    tasklist[s] = awful.widget.tasklist(function(c)
            return awful.widget.tasklist.label.currenttags(c, s)
        end, tasklist.buttons)

    -- Create the wibox
    statusbar[s] = awful.wibox({
        position = "top",
        screen = s,
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
    })

    -- Add widgets to the wibox - order matters
    statusbar[s].widgets = {
        {
            launcher,
            taglist[s],
            promptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        layoutbox[s],
        s == 1 and systray or nil,
        spacer,
        clockwidget,
        separator,
        netwidget,
        separator,
        memwidget,
        separator,
        cpuwidget,
        spacer,
        tasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

--------------------------------------------------------------------------------
-- Mouse bindings
--------------------------------------------------------------------------------

root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () menu_main:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

--------------------------------------------------------------------------------
-- Key bindings
--------------------------------------------------------------------------------

globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () menu_main:show({ keygrabber = true }) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return",function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey            }, "r",     function () promptbox[mouse.screen]:run() end),

    awful.key({ modkey            }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  promptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Drop down terminal
    awful.key({ modkey            }, "grave", function () scratch.drop(terminal) end),
    awful.key({ modkey            }, "s",     function () scratch.pad.toggle() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey            }, "d",      function (c) scratch.pad.set(c) end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({        }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

--------------------------------------------------------------------------------
-- Rules
--------------------------------------------------------------------------------

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Ventrilo.exe" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}

--------------------------------------------------------------------------------
-- Signals
--------------------------------------------------------------------------------

client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Set floating clients always on top
    if awful.client.floating.get(c) then
        c.above = true
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
