local fs = require 'nixio.fs'
local uci = luci.model.uci.cursor()
local name = 'design'

local mode, navbar, navbar_proxy
if fs.access('/etc/config/design') then
	mode = uci:get_first('design', 'global', 'mode')
	navbar = uci:get_first('design', 'global', 'navbar')
	navbar_proxy = uci:get_first('design', 'global', 'navbar_proxy')
end

local br, s, o

br = SimpleForm('config', translate("Design Config"), translate("Here you can adjust various theme settings. [Recommend Chrome]"))
br.reset = false
br.submit = false
s = br:section(SimpleSection)

o = s:option(ListValue, 'mode', translate("Theme mode"))
o:value('normal', translate("Follow System"))
o:value('light', translate("Force Light"))
o:value('dark', translate("Force Dark"))
o.default = mode
o.rmempty = false
o.description = translate("You can choose Theme color mode here")

o = s:option(ListValue, 'navbar', translate("Navigation bar setting"))
o:value('display', translate("Display navigation bar"))
o:value('close', translate("Close navigation bar"))
o.default = navbar
o.rmempty = false
o.description = translate("The navigation bar is display by default")

o = s:option(ListValue, 'navbar_proxy', translate("Navigation bar proxy"))
o:value('helloworld', 'helloworld')
o:value('homeproxy', 'homeproxy')
o:value('mihomo', 'mihomo')
o:value('openclash', 'openclash')
o:value('passwall', 'passwall')
o:value('passwall2', 'passwall2')
o.default = navbar_proxy
o.rmempty = false
o.description = translate("Homeproxy by default")

o = s:option(Button, 'save', translate("Save Changes"))
o.inputstyle = 'reload'

function br.handle(self, state, data)
	if (state == FORM_VALID and data.mode ~= nil and data.navbar ~= nil and data.navbar_proxy ~= nil) then
		fs.writefile('/tmp/aaa', data)
		for key, value in pairs(data) do
			uci:set('design','@global[0]',key,value)
		end
		uci:commit('design')
	end
	return true
end

return br
