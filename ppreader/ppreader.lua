local M = {}

local xml2lua = require("ppreader.xml2lua")
local handler = require("ppreader.xmlhandler.tree")

local hex_to_char = function(x)
	return string.char(tonumber(x, 16))
end

local unescape = function(url)
	return url:gsub("%%(%x%x)", hex_to_char)
end

local function read_file(path)
	local file = io.open(path, "rb")
	if not file then return nil end
	local content = file:read("*a")
	file:close()
	return content
end

local function read_node(value, type, node)
	name = unescape(value._attr.name)
	node[name] = value._attr.value or value[1]
	if type == "string" then
		node[name] = unescape(node[name])
	else
		node[name] = tonumber(node[name])
	end
end

local function parse(data)
	local treeHandler = handler:new()
	local parser = xml2lua.parser(treeHandler)
	parser:parse(data)
	local result = {}
	local node, name
	for type, values in pairs(treeHandler.root.map) do
		node = {}
		if #values > 0 then
			for k, value in pairs(values) do
				read_node(value, type, result)
			end
		else
			read_node(values, type, result)
		end
	end
	return result
end

local get_pathes  = {
	["Darwin"] = function() --~/Library/Preferences/unity.[company name].[product name].plist where company and product names are the names set up in Project Settings
		local company_name = sys.get_config("ppreader.company_name")
		local product_name = sys.get_config("ppreader.product_name")
		return {"~/Library/Preferences/unity."..company_name.."."..product_name..".plist"} 
	end, 
	["Linux"] = function() end, -- ~/.config/unity3d/[CompanyName]/[ProductName] again using the company and product names specified in the Project Settings.
	["Windows"] = function() end, --HKCU\Software\[company name]\[product name] key, where company and product names are the names set up in Project Settings.
	["HTML5"] = function() end, -- On WebGL, PlayerPrefs are stored using the browser's IndexedDB API.
	["Android"] = function()
		local package_name = sys.get_config("android.package")
		return {
			"/data/data/"..package_name.."/shared_prefs/"..package_name..".v2.playerprefs.xml", --Unity >= 5.3 
			--more info: http://www.yaku.to/blog/2016/01/24/Unity-QA-screws-us-again-or-how-we-learned-to-stop-worrying-and-fix-it-ourselves/
			"/data/data/"..package_name.."/shared_prefs/"..package_name..".xml" -- Unity < 5.3
		}
	end, 
	["iPhone OS"] = function() -- /Library/Preferences/[bundle identifier].plist.
		local bundle_id = sys.get_config("ios.bundle_identifier")
		return {
			"~/Library/Preferences/"..bundle_id..".plist"
		}
	end
}

function M.get()
	local current_platform = sys.get_sys_info().system_name
	local pathes_table = get_pathes[current_platform]()
	if not pathes_table then
		return
	end
	local file
	for k, path in pairs(pathes_table) do
		if current_platform == "iPhone OS" or current_platform == "Darwin" then
			return ppreader_native.read(path)
		else
			file = read_file(path, current_platform)
			if file then
				return parse(file), path
			end
		end
	end
end

return M