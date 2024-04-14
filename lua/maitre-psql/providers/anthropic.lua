local request = require("maitre-psql.common.request").request

--- Generate a chat completion using the Anthropic API.
---@param system_prompt string: The system prompt to provide to the API.
---@param user_prompt string: The user prompt to provide to the API.
---@param anthropic_config anthropic_config: The configuration for the Anthropic API.
local function generate_chat_completion(system_prompt, user_prompt, anthropic_config)
	local url = "https://api.anthropic.com/v1/messages"
	local headers = {
		["Content-Type"] = "application/json",
		["x-api-key"] = os.getenv(anthropic_config.anthropic_api_key_env),
		["anthropic-version"] = "2023-06-01",
	}

	local body = {
		model = anthropic_config.model_name,
		max_tokens = 1024,
		messages = {
			{
				role = "user",
				content = system_prompt .. " " .. user_prompt,
			},
		},
	}

	local success, response = request("POST", url, headers, vim.fn.json_encode(body))
	if not success then
		vim.notify("Error: Request failed with message -- " .. response, vim.log.levels.ERROR)
		return nil
	end

	-- Decode JSON response
	local decoded_response = vim.fn.json_decode(response)
	if decoded_response and decoded_response.content and #decoded_response.content > 0 then
		return decoded_response.content[1].text
	else
		vim.notify("Error: No response from Anthropic", vim.log.levels.ERROR)
		return nil
	end
end

-- local test = generate_chat_completion(
-- 	"You are an AI assistant that generates concise and descriptive names for SQL queries.",
-- 	"Please generate a name for the following SQL query: ```sql SELECT * FROM users; ```",
-- 	{ anthropic_api_key_env = "ANTHROPIC_API_KEY", model_name = "claude-3-haiku-20240307" }
-- )
-- print(test)

return generate_chat_completion
