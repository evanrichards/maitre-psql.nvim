local generate_query_name = require("maitre-psql.generate-query-name")
local function save_favorite_query(config)
	local query_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	local query_name = generate_query_name(query_text, config)
	local query_data = {
		queryText = query_text,
		timestamp = os.date("%Y-%m-%d %H:%M:%S"),
		queryName = query_name,
	}
	local path = vim.fn.resolve(config.save_dir .. "/favorites/" .. query_name .. ".json")
	-- if the file already exists, append a number to the end of the file name
	local i = 1
	while vim.fn.filereadable(path) == 1 do
		path = vim.fn.resolve(config.save_dir .. "/" .. query_name .. "-" .. i .. ".json")
		i = i + 1
	end
	local file = io.open(path, "w+")
	if not file then
		print("Failed to open file for writing")
		return
	end
	file:write(vim.fn.json_encode(query_data))
	file:close()
	vim.notify("Saved query as " .. query_name)
end

return save_favorite_query
