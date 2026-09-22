
local mod = "SUPER"
local term = "kitty"
local browser = "firefox"
hl.on("hyprland.start", function()
hl.notification.create({text = "welcome to hyprland version: " .. hl.version(), duration = 10000, color = "0xFF0000", icon = 1, font_size = 10, timeout = 10})
hl.exec_cmd("awww-daemon")
hl.exec_cmd("wayle shell")
hl.dsp.exec_cmd("hyprcursor setcursor aidwata 24")
end
)


hl.window_rule({
	name = "no shadow",
	match = {
		focus = 0
	},
	border_size = false,
	no_shadow = true,
	rounding = 10
})

hl.window_rule({
	name = "no shadow",
	match = {
		focus = 1
	},
	border_size = false,
	no_shadow = true,
	rounding = 10
})

hl.bind(mod .. " + Q",hl.dsp.window.close())
hl.bind(mod .. " + TAB", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("steam"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + S", hl.dsp.exec_cmd("grim"))
hl.bind(mod .. " + GRAVE", hl.dsp.exec_cmd("rofi -show drun"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 9600+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 9600-"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 -5%"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute 0 toggle"))

hl.bind(mod .. " + 1", hl.dsp.focus({workspace = 1}))
hl.bind(mod .. " + 2", hl.dsp.focus({workspace = 2}) )
hl.bind(mod .. " + 3", hl.dsp.focus({workspace = 3}) )
hl.bind(mod .. " + 4", hl.dsp.focus({workspace = 4}) )
hl.bind(mod .. " + 5", hl.dsp.focus({workspace = 5}) )
hl.bind(mod .. " + 6", hl.dsp.focus({workspace = 6}) )
hl.bind(mod .. " + 7", hl.dsp.focus({workspace = 7}) )

for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + SHIFT + " .. key, function()
        hl.dispatch(hl.dsp.window.move({ workspace = tostring(i), follow = false }))
    end)
end

hl.bind(mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + C", hl.dsp.window.float() )
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + E", hl.dsp.exit())
