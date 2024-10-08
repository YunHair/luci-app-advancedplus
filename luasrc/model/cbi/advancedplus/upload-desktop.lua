local fs = require 'nixio.fs'
local wa = require 'luci.tools.webadmin'
local ipkg = require 'luci.model.ipkg'
local http = require 'luci.http'
local util = require 'nixio.util'
local uci = luci.model.uci.cursor()
local name = 'kucat'

local fstat = fs.statvfs(ipkg.overlay_root())
local space_total = fstat and fstat.blocks or 0
local space_free = fstat and fstat.bfree or 0
local space_used = space_total - space_free
local free_byte = space_free * fstat.frsize

function glob(...)
	local iter, code, msg = fs.glob(...)
	if iter then
		return util.consume(iter)
	else
		return nil, code, msg
	end
end

local dir = '/www/luci-static/kucat/bg/'
ful = SimpleForm('upload', translate("Upload  (Free: ")..wa.byte_format(free_byte)..')', translate("Only JPG, PNG, and GIF files can be uploaded."))
ful.reset = false
ful.submit = false

sul = ful:section(SimpleSection, '', translate("Upload file to ")..dir)
fu = sul:option(FileUpload, '')
fu.template = 'advancedplus/other_upload'
um = sul:option(DummyValue, '', nil)
um.template = 'advancedplus/other_dvalue'

local fd
fs.mkdir(dir)
http.setfilehandler(
	function(meta, chunk, eof)
		if not fd then
			if not meta then
				return
			end

			if meta and chunk then
				fd = nixio.open(dir..meta.file, 'w')
			end

			if not fd then
				um.value = translate("Create upload file error.")
				return
			end
		end
		if chunk and fd then
			fd:write(chunk)
		end
		if eof and fd then
			fd:close()
			fd = nil
			um.value = translate("File saved to")..dir..meta.file
		end
	end
)

if http.formvalue('upload') then
	local f = http.formvalue('ulfile')
	if #f <= 0 then
		um.value = translate("No specify upload file.")
	end
end

local function getSizeStr(size)
	local i = 0
	local byteUnits = {' kB', ' MB', ' GB', ' TB'}
	repeat
		size = size / 1024
		i = i + 1
	until (size <= 1024)
	return string.format('%.1f', size)..byteUnits[i]
end

local inits, attr = {}
for i, f in ipairs(glob(dir..'*')) do
	attr = fs.stat(f)
	if attr then
		inits[i] = {}
		inits[i].name = fs.basename(f)
		inits[i].mtime = os.date('%Y-%m-%d %H:%M:%S', attr.mtime)
		inits[i].modestr = attr.modestr
		inits[i].size = getSizeStr(attr.size)
		inits[i].remove = 0
		inits[i].install = false
	end
end

form = SimpleForm('filelist', translate("Background file list"), nil)
form.reset = false
form.submit = false

tb = form:section(Table, inits)
nm = tb:option(DummyValue, 'name', translate("File name"))
mt = tb:option(DummyValue, 'mtime', translate("Modify time"))
sz = tb:option(DummyValue, 'size', translate("Size"))
btnrm = tb:option(Button, 'remove', translate("Remove"))
btnrm.render = function(self, section, scope)
	self.inputstyle = 'remove'
	Button.render(self, section, scope)
end

btnrm.write = function(self, section)
	local v = fs.unlink(dir..fs.basename(inits[section].name))
	if v then
		table.remove(inits, section)
	end
	return v
end

return  ful, form
