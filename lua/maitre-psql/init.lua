local default_config = require("maitre-psql.config").default_config
local favorite_picker = require("maitre-psql.favorite-picker")
local quick_save_picker = require("maitre-psql.quick-save-picker")
local load_most_recent_query_if_blank = require("maitre-psql.load-most-recent-query-if-blank")
local save_favorite_query = require("maitre-psql.save-favorite-query")
local quick_save = require("maitre-psql.quick-save")

local _config = default_config

---@param config plugin_config
local function setup(config)
	_config = vim.tbl_deep_extend("force", default_config, config)
	vim.fn.mkdir(vim.fn.resolve(_config.save_dir .. "/favorites"), "p")
	vim.fn.mkdir(vim.fn.resolve(_config.save_dir .. "/quick-save"), "p")
end

local function register()
	load_most_recent_query_if_blank(_config)
	vim.api.nvim_create_user_command("MaitrePsql", function()
		save_favorite_query(_config)
	end, { desc = "Save the current query as a favorite query" })

	vim.api.nvim_create_user_command("MaitrePsqlOpen", function()
		favorite_picker(_config)
	end, { desc = "Open saved queries" })

	vim.api.nvim_create_user_command("MaitrePsqlQuickSaveOpen", function()
		quick_save_picker(_config)
	end, { desc = "Open quick save queries" })

	vim.api.nvim_create_autocmd({ "BufWrite" }, {
		pattern = "psql.edit.*.sql",
		callback = function()
			quick_save(_config)
		end,
	})
end

return {
	setup = setup,
	register = register,
}
