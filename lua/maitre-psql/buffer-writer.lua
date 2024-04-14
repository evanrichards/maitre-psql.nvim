local function write_file_to_buffer(file_path)
	-- Read the content of the selected file
	local file = io.open(file_path, "r")
	if file then
		local content = file:read("*all")
		file:close()
		local query_data = vim.fn.json_decode(content)
		local query_text = query_data and query_data.queryText or content
		-- Replace the current buffer's content with the file content
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(query_text, "\n"))
	else
		print("Failed to read the file: " .. file_path)
	end
end
return write_file_to_buffer
