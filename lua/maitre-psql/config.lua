---@class (exact) anthropic_config
---@field anthropic_api_key_env string The environment variable that contains the API key for the Anthropic API. Default value:
---@field model_name string The name of the model to use for the Anthropic API. Default value: "claude-3-haiku-20240307"
---@field enabled boolean Whether the Anthropic API is enabled. Default value: false
---@class anthropic_config
local default_anthropic_config = {
	anthropic_api_key_env = "ANTHROPIC_API_KEY",
	model_name = "claude-3-haiku-20240307",
	enabled = false,
}

---@class (exact) openai_config
---@field openai_api_key_env string The environment variable that contains the API key for the OpenAI API. Default value:
---@field model_name string The name of the model to use for the OpenAI API. Default value: "text-davinci-003"
---@field enabled boolean Whether the OpenAI API is enabled. Default value: false
---@class openai_config
local default_openai_config = {
	openai_api_key_env = "OPENAI_API_KEY",
	model_name = "gpt-3.5-turbo",
	enabled = false,
}

---@class (exact) plugin_config
---@field save_dir string The path to the directory where the files will be saved. No default value.
---@field num_quick_save_files integer The number of quick save files to keep. Default value: -1 for unlimited.
---@field anthropic_config anthropic_config The configuration for the Anthropic API. Default value:
---@field openai_api_key string The API key for the OpenAI API. No default value.
---@class plugin_config
local default_config = {
	save_dir = "",
	num_quick_save_files = -1,
	anthropic_config = default_anthropic_config,
	openai_config = default_openai_config,
}

return {
	default_config = default_config,
}
