local opacity_sets = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local transparency_sets = {0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1}
local m, s, o

m = Map("advancedplus")
m.title = translate("KuCat Theme Config")
m.description = translate("Set and manage features such as KuCat themed background wallpaper, main background color, partition background, transparency, blur, toolbar retraction and shortcut pointing.</br>")..
translate("There are 6 preset color schemes, and only the desktop background image can be set to display or not. The custom color values are RGB values such as 255,0,0 (representing red), and a blur radius of 0 indicates no lag in the image.")..
translate("</br>For specific usage, see:")..translate("<a href=\'https://github.com/sirpdboy/luci-app-advancedplus.git' target=\'_blank\'>GitHub @sirpdboy/luci-app-advancedplus </a>")

s = m:section(TypedSection, "basic", translate("Settings"))
s.anonymous = true

o = s:option(ListValue, 'background', translate("Wallpaper Source"), translate("Local wallpapers need to be uploaded on their own, and only the first update downloaded on the same day will be automatically downloaded."))
o:value('0', translate("Local wallpaper"))
o:value('1', translate("Auto download Iciba wallpaper"))
o:value('2', translate("Auto download unsplash wallpaper"))
o:value('3', translate("Auto download Bing wallpaper"))
o:value('4', translate("Auto download Bird 4K wallpaper"))
o.default = '3'
o.rmempty = false

o = s:option(Flag, "bklock", translate("Wallpaper synchronization"), translate("Is the login wallpaper consistent with the desktop wallpaper? If not selected, it indicates that the desktop wallpaper and login wallpaper are set independently."))
o.rmempty = false
o.default = '0'

o = s:option(Flag, "setbar", translate("Expand Toolbar"), translate("Expand or shrink the toolbar"))
o.rmempty = false
o.default = '1'

o = s:option(Flag, "bgqs", translate("Refreshing mode"), translate("Cancel background glass fence special effects"))
o.rmempty = false
o.default = '0'

o = s:option(Flag, "dayword", translate("Enable Daily Word"))
o.rmempty = false
o.default = '0'

o = s:option(Value, 'gohome', translate("Status Homekey Settings"))
o:value('overview', translate("Overview"))
o:value('routes', translate("Routing"))
o:value('logs', translate("System Log"))
o:value('processes', translate("Processes"))
o:value('realtime', translate("Realtime Graphs"))
o.default = 'overview'
o.rmempty = false

o = s:option(Value, 'gouser', translate("System Userkey Settings"))
o:value('advancedplus', translate("Advanced plus"))
o:value('system', translate("System"))
o:value('admin', translate("Administration"))
o:value('opkg', translate("Software"))
o:value('startup', translate("Startup"))
o:value('crontab', translate("Scheduled Tasks"))
o:value('mounts', translate("Mount Points"))
o:value('diskman', translate("Disk Man"))
o:value('leds', translate("LED Configuration"))
o:value('flash', translate("Backup / Flash"))
o:value('autoreboot', translate("Scheduled Reboot"))
o:value('reboot', translate("Reboot"))
o.default = 'advancedplus'
o.rmempty = false

o = s:option(Value, 'goproxy', Translate('Services Proxy Settings'))
o:value('helloworld', 'helloworld')
o:value('homeproxy', 'homeproxy')
o:value('mihomo', 'mihomo')
o:value('openclash', 'openclash')
o:value('passwall', 'passwall')
o:value('passwall2', 'passwall2')
o.default = 'homeproxy'
o.rmempty = false

o = s:option(Flag, "fontmode", translate("Care mode (large font)"))
o.rmempty = false
o.default = '0'

s = m:section(TypedSection, "theme", translate("Color scheme list"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

o = s:option(Value, 'remarks', translate("Remarks"))

o = s:option(Flag, "use", translate("Enable color matching"))
o.rmempty = false
o.default = '1'

o = s:option(ListValue, 'mode', translate("Theme mode"))
o:value('auto', translate("Auto"))
o:value('light', translate("Light"))
o:value('dark', translate("Dark"))
o.default = 'light'

o = s:option(Value, 'primary_rgbm', translate("Main Background color(RGB)"))
o:value("blue", translate("RoyalBlue"))
o:value("green", translate("MediumSeaGreen"))
o:value("orange", translate("SandyBrown"))
o:value("red", translate("TomatoRed"))
o:value("black", translate("Black tea eye protection gray"))
o:value("gray", translate("Cool night time(gray and dark)"))
o:value("bluets", translate("Cool Ocean Heart (transparent and bright)"))
o.default='green'
o.datatype = ufloat
o.default='74,161,133'

o = s:option(Flag, "bkuse", translate("Enable wallpaper"))
o.rmempty = false
o.default = '1'

o = s:option(Value, 'primary_rgbm_ts', translate("Wallpaper transparency"))
for _, v in ipairs(transparency_sets) do
	o:value(v)
end
o.datatype = ufloat
o.rmempty = false

o.default='0.5'

o = s:option(Value, 'primary_opacity', translate("Wallpaper blur radius"))
for _, v in ipairs(opacity_sets) do
	o:value(v)
end
o.datatype = ufloat
o.rmempty = false

o.default='10'

o = s:option(Value, 'primary_rgbs', translate("Fence background(RGB)"))
o.default='225,112,88'
o.datatype = ufloat

o = s:option(Value, 'primary_rgbs_ts', translate("Fence background transparency"))
for _, v in ipairs(transparency_sets) do
	o:value(v)
end
o.datatype = ufloat
o.rmempty = false

o.default='0.3'

m.apply_on_parse = true
m.on_after_apply = function(self,map)
	luci.sys.exec("/etc/init.d/advancedplus start >/dev/null 2>&1")
	luci.http.redirect(luci.dispatcher.build_url("admin", "system", "advancedplus", "kucatset"))
end

return m
