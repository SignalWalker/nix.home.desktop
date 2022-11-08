local fs = {}

function fs.readdir(path)
	local dir = vim.loop.fs_opendir(path, nil, 100)
	local entries = dir:readdir()
	dir:closedir()
	return entries
end

function fs.readfile(path, dest)
	local file = assert(io.open(path, 'r'))

	local result
	if dest ~= nil then
		for line in file:lines() do
			table.insert(dest, line)
		end

		result = dest
	else
		result = file:read('*all')
	end

	file:close()

	return result
end

function math.randomchoice(t)
	local keys = {}
	for key,_ in pairs(t) do
		keys[#keys + 1] = key
	end
	local index = math.random(1, #keys)
	local key = keys[index]
	return t[key]
end

function  table.map(t, fn)
	local result = {}
	for _,item in ipairs(t) do
		table.insert(result, fn(item))
	end
	return result
end

return function()

	-- skip if we're reading a file
	-- if (vim.api.nvim_exec('echo argc()', true) ~= "0") then return end

	-- local logos_dir = vim.fn.stdpath('config') .. '/assets/logos'
	--
	-- local logo_files = table.map(fs.readdir(logos_dir), function(entry)
	-- 	return string.format('%s/%s', logos_dir, entry.name)
	-- end)

	require'alpha'.setup({
		layout = {
			[[im gay]]
			-- fs.readfile(math.randomchoice(logo_files), {})
		},
		opts = {
			margin = 5
		}
	})
end
