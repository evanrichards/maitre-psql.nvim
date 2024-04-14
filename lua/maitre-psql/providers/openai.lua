local request = require("maitre-psql.common.request").request

--- Generate a chat completion using the Anthropic API.
---@param system_prompt string: The system prompt to provide to the API.
---@param user_prompt string: The user prompt to provide to the API.
---@param openai_config openai_config: The configuration for the OpenAI API.
local function generate_chat_completion(system_prompt, user_prompt, openai_config)
	local url = "https://api.openai.com/v1/chat/completions"
	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. vim.env[openai_config.openai_api_key_env],
	}
	local body = {
		model = openai_config.model_name,
		messages = {
			{
				role = "system",
				content = system_prompt,
			},
			{
				role = "user",
				content = user_prompt,
			},
		},
	}
	local success, response = request("POST", url, headers, vim.fn.json_encode(body))
	if not success then
		vim.notify("Error: Request failed", vim.log.levels.ERROR)
		return nil
	end
	-- Decode JSON response
	local decoded_response = vim.fn.json_decode(response)
	if decoded_response and decoded_response.choices and #decoded_response.choices > 0 then
		return decoded_response.choices[1].message.content
	else
		vim.notify("Error: No response from OpenAI", vim.log.levels.ERROR)
		return nil
	end
end

return generate_chat_completion
