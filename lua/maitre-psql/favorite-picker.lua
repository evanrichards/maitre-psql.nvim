local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local write_file_to_buffer = require("maitre-psql.buffer-writer")

---@param config plugin_config
local function open_favorite_picker(config)
	local saved_queries = vim.fn.glob(vim.fn.resolve(config.save_dir .. "/favorites/*.json"), false, true)

	pickers
		.new({}, {
			prompt_title = "Favorite Queries",
			finder = finders.new_table({
				results = saved_queries,
				entry_maker = function(entry)
					local file = io.open(entry, "r")
					if file then
						local content = file:read("*all")
						file:close()
						local query_data = vim.fn.json_decode(content)
						local query_text = query_data and query_data.queryName or false
						if query_text then
							return {
								value = entry,
								display = query_text,
								ordinal = query_text,
								path = entry,
							}
						end
					end

					return {
						value = entry,
						display = vim.fn.fnamemodify(entry, ":t"),
						ordinal = entry,
						path = entry,
					}
				end,
			}),

			previewer = previewers.new_buffer_previewer({
				define_preview = function(self, entry)
					local file = io.open(entry.path, "r")
					if file then
						local content = file:read("*all")
						file:close()
						local query_data = vim.fn.json_decode(content)
						local query_text = query_data and query_data.queryText or content
						vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(query_text, "\n"))
						vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "sql")
					else
						vim.api.nvim_buf_set_lines(
							self.state.bufnr,
							0,
							-1,
							false,
							{ "Failed to read the file: " .. entry.path }
						)
					end
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					write_file_to_buffer(selection.path)
				end)
				return true
			end,
		})
		:find()
end

return open_favorite_picker
