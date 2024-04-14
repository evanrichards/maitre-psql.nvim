local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

---@param config plugin_config
local function open_favorite_picker(config)
	local saved_queries = vim.fn.glob(vim.fn.resolve(config.save_dir .. "/quick-save/*.sql"), false, true)

	pickers
		.new({}, {
			prompt_title = "Quick Save Queries",
			finder = finders.new_table({
				results = saved_queries,
				entry_maker = function(entry)
					local display = vim.fn.fnamemodify(entry, ":t")
					return {
						value = entry,
						display = display,
						ordinal = display,
						path = entry,
					}
				end,
			}),
			previewer = conf.file_previewer({}),

			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					-- Read the content of the selected file
					local file = io.open(selection.path, "r")
					if file then
						local content = file:read("*all")
						file:close()

						-- Replace the current buffer's content with the file content
						vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(content, "\n"))
					else
						print("Failed to read the file: " .. selection.path)
					end
				end)
				return true
			end,
		})
		:find()
end

return open_favorite_picker
