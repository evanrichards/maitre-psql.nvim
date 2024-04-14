---This function is used to load the most recent query file if the current buffer is blank.
---@param config plugin_config: The plugin configuration.
local function load_most_recent_query_if_blank(config)
	local symlink = vim.fn.resolve(config.save_dir .. "/quick-save/most-recent.sql")
	if vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
		if vim.fn.filereadable(symlink) == 1 then
			local file = io.open(symlink, "r")
			if file then
				local content = file:read("*all")
				file:close()

				-- Replace the current buffer's content with the file content
				vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(content, "\n"))
				vim.notify("Loaded most recent query")
			end
		end
	end
end

return load_most_recent_query_if_blank
