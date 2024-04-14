---This function is used to save the content of the current buffer to file with
---timestamp as the filename.
---@param config plugin_config: The plugin configuration.
local function quick_save(config)
	local symlink = vim.fn.resolve(config.save_dir .. "/quick-save/most-recent.sql")
	-- Read the content of the current buffer
	local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	-- If the content is empty, even after trimming, then return
	if content:gsub("^%s*(.-)%s*$", "%1") == "" then
		return
	end
	-- if its just super short, dont save it
	if #content < 100 then
		return
	end

	-- if the most recent query is the same as the current buffer, dont save it
	local most_recent_file = io.open(symlink, "r")
	if most_recent_file then
		local most_recent_content = most_recent_file:read("*all")
		most_recent_file:close()
		if most_recent_content == content then
			return
		end
	end

	local file_name = vim.fn.resolve(config.save_dir .. "/quick-save/" .. os.date("%Y-%m-%d-%H-%M-%S") .. ".sql")
	local file = io.open(file_name, "w+")
	-- Write the content to a file
	if file then
		file:write(content)
		file:close()
	else
		print("Failed to write the file: " .. vim.fn.expand("%:p:r") .. ".json")
	end

	-- write/update a symlink to the most recent quick save
	os.remove(symlink)
	os.execute("ln -s " .. file_name .. " " .. symlink)

	if config.num_quick_save_files ~= -1 then
		local quick_save_files = vim.fn.glob(vim.fn.resolve(config.save_dir .. "/quick-save/*.sql"), false, true)
		table.sort(quick_save_files, function(a, b)
			return a > b
		end)
		if #quick_save_files > config.num_quick_save_files then
			for i = config.num_quick_save_files + 1, #quick_save_files do
				os.remove(quick_save_files[i])
			end
		end
	end
end

return quick_save
