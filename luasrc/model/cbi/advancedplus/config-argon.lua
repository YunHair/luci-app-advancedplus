local fs = require 'nixio.fs'
local ipkg = require 'luci.model.ipkg'
local util = require 'nixio.util'
local uci = luci.model.uci.cursor()
local name = 'argon'

local primary, dark_primary, blur_radius, blur_radius_dark, blur_opacity, mode
if fs.access('/etc/config/argon') then
	primary = uci:get_first('argon', 'global', 'primary')
	dark_primary = uci:get_first('argon', 'global', 'dark_primary')
	blur_radius = uci:get_first('argon', 'global', 'blur')
	blur_radius_dark = uci:get_first('argon', 'global', 'blur_dark')
	blur_opacity = uci:get_first('argon', 'global', 'transparency')
	blur_opacity_dark = uci:get_first('argon', 'global', 'transparency_dark')
	mode = uci:get_first('argon', 'global', 'mode')
	bing_background = uci:get_first('argon', 'global', 'bing_background')
end

local opacity_sets = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local transparency_sets = {0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1}
local br, s, o

br = SimpleForm('config', translate("Argon Config"), translate("Here you can adjust various theme settings. [Recommend Chrome]"))
br.reset = false
br.submit = false
s = br:section(SimpleSection)

o = s:option(ListValue, 'bing_background', translate("Wallpaper Source"))
o:value('0', translate("Built-in"))
o:value('1', translate("Bing Wallpapers"))
o.default = bing_background
o.rmempty = false

o = s:option(ListValue, 'mode', translate("Theme mode"))
o:value('normal', translate("Follow System"))
o:value('light', translate("Force Light"))
o:value('dark', translate("Force Dark"))
o.default = mode
o.rmempty = false
o.description = translate("You can choose Theme color mode here")

o = s:option(Value, 'primary', translate("[Light mode]")..translate(" Primary Color"), translate("A HEX Color"))
o.default = primary
o.datatype = ufloat
o.rmempty = false

o = s:option(ListValue, 'transparency', translate("[Light mode]")..translate(" Transparency"), translate("0 transparent - 1 opaque"))
for _, v in ipairs(transparency_sets) do
	o:value(v)
end
o.default = blur_opacity
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'blur', translate("[Light mode]")..translate(" Frosted Glass Radius"), translate("0 clear - 10 blur"))
for _, v in ipairs(opacity_sets) do
	o:value(v)
end
o.default = blur_radius
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'dark_primary', translate("[Dark mode]")..translate(" Primary Color"), translate("A HEX Color"))
o.default = dark_primary
o.datatype = ufloat
o.rmempty = false

o = s:option(ListValue, 'transparency_dark', translate("[Dark mode]")..translate(" Transparency"), translate("0 transparent - 1 opaque"))
for _, v in ipairs(transparency_sets) do
	o:value(v)
end
o.default = blur_opacity_dark
o.datatype = ufloat
o.rmempty = false

o = s:option(Value, 'blur_dark', translate("[Dark mode]")..translate(" Frosted Glass Radius"), translate("0 clear - 10 blur"))
for _, v in ipairs(opacity_sets) do
	o:value(v)
end
o.default = blur_radius_dark
o.datatype = ufloat
o.rmempty = false

o = s:option(Button, 'save', translate("Save Changes"))
o.inputstyle = 'reload'

function br.handle(self, state, data)
	if (state == FORM_VALID and data.blur ~= nil and data.blur_dark ~= nil and data.transparency ~= nil and data.transparency_dark ~= nil and data.mode ~= nil) then
		fs.writefile('/tmp/aaa', data)
		for key, value in pairs(data) do
			uci:set('argon','@global[0]',key,value)
		end
		uci:commit('argon')
	end
	return true
end

return br
