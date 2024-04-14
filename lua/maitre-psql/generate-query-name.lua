local system_prompt = [[You are an AI assistant that generates descriptive file names for SQL queries.]]
local user_prompt =
	[[Please generate a name for the following SQL query. Your reply will be used directly as the name of the query so please do not include any special characters or newlines, or use full sentences and please do use kebab-case. It does not necessarily have to be a short name, so please include any detail that look like specific hints to what the author of the query was trying to achieve. Here is the query:
```sql
]]

---@param query_text string: The SQL query text for which to generate a name.
---@param config plugin_config: The plugin configuration.
local function generate_query_name(query_text, config)
	local user_content = user_prompt .. query_text .. "\n```"
	if config.anthropic_config.enabled then
		vim.notify("Generating query name...", vim.log.levels.INFO, { hide_from_history = true, animate = false })
		local generate_chat_completion = require("maitre-psql.providers.anthropic")
		return generate_chat_completion(system_prompt, user_content, config.anthropic_config)
	elseif config.openai_config.enabled then
		vim.notify("Generating query name...", vim.log.levels.INFO, { hide_from_history = true, animate = false })
		local generate_chat_completion = require("maitre-psql.providers.openai")
		return generate_chat_completion(system_prompt, user_content, config.openai_config)
	else
		return os.date("%Y-%m-%d %H:%M:%S")
	end
end

return generate_query_name
