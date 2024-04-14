local maitre_psql = require("maitre-psql")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "psql.edit.*.sql",
	callback = function()
		maitre_psql.register()
	end,
})
