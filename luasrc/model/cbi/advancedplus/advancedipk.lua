local uci = luci.model.uci.cursor()
local m, s, o

m = Map("advancedplus")
m.title = translate("Loading plugins")
m.description = translate("Choose to load and install the app store, DOCKER, all drivers, etc")..translate("</br>For specific usage, see:")..translate("<a href = \'https://github.com/sirpdboy/luci-app-advancedplus.git' target = \'_blank\'>GitHub @sirpdboy/luci-app-advancedplus </a>")
m.apply_on_parse = true

s = m:section(TypedSection, "basic", "")
s.anonymous = true

o = s:option(ListValue, 'select_ipk', translate("Select the type of loading"))
o:value("istore", translate("Install iStore"))
o:value("docker", translate("Install Docker"))
o:value("drv", translate("Install All drives"))
o.default = "istore"

o = s:option(Button, "restart", translate("Perform operation"))
o.inputtitle = translate("Click to execute")
o.template = 'advancedplus/advanced'

return m
