# Maître PSQL

Maître PSQL is a Neovim plugin that enhances your PostgreSQL workflow by providing a set of useful features for managing and working with SQL queries. With Maître PSQL, you can easily save, organize, and retrieve your favorite queries, as well as generate descriptive names for them using AI-powered suggestions.

## Features

- Save and organize your favorite SQL queries
- Quick save and retrieve recently used queries
- Generate descriptive names for your queries using AI (powered by Anthropic or OpenAI)
- Seamless integration with Neovim's built-in features and commands

## Installation

### Using Lazy.nvim

If you're using [Lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager, you can install Maître PSQL by adding the following to your Neovim configuration:

```lua
return {
	"evanrichards/maitre-psql",
	opts = {
		-- Your configuration options here
	},
}
```

### Using Packer.nvim

If you're using [Packer.nvim](https://github.com/wbthomason/packer.nvim) plugin manager, you can install Maître PSQL by adding the following to your Neovim configuration:

```lua
use {
	"evanrichards/maitre-psql",
	config = function()
		require("maitre-psql").setup({
			-- Your configuration options here
		})
	end,
}
```

## Configuration

Maître PSQL comes with a set of default configuration options. You can customize these options by passing a configuration table to the `setup` function. Here's an example configuration:

```lua
require("maitre-psql").setup({
	save_dir = "/path/to/your/save/directory/",
	num_quick_save_files = 10,
	anthropic_config = {
		anthropic_api_key_env = "ANTHROPIC_API_KEY",
		model_name = "claude-3-haiku-20240307",
		enabled = true,
	},
	openai_config = {
		openai_api_key_env = "OPENAI_API_KEY",
		model_name = "gpt-3.5-turbo",
		enabled = false,
	},
})
```

### Configuration Options

- `save_dir` (string): The path to the directory where the files will be saved.
- `num_quick_save_files` (integer): The number of quick save files to keep. Default value is `-1` for unlimited.
- `anthropic_config` (table): The configuration for the Anthropic API.
  - `anthropic_api_key_env` (string): The environment variable that contains the API key for the Anthropic API.
  - `model_name` (string): The name of the model to use for the Anthropic API. Default value is `"claude-3-haiku-20240307"`.
  - `enabled` (boolean): Whether the Anthropic API is enabled. Default value is `false`.
- `openai_config` (table): The configuration for the OpenAI API.
  - `openai_api_key_env` (string): The environment variable that contains the API key for the OpenAI API.
  - `model_name` (string): The name of the model to use for the OpenAI API. Default value is `"gpt-3.5-turbo"`.
  - `enabled` (boolean): Whether the OpenAI API is enabled. Default value is `false`.

## Available Commands

Maître PSQL provides the following commands:

- `:MaitrePsql`: Save the current query as a favorite query.
- `:MaitrePsqlOpen`: Open saved queries using Telescope.
- `:MaitrePsqlQuickSaveOpen`: Open quick save queries using Telescope.

## Contributing

Contributions to Maître PSQL are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/evanrichards/maitre-psql).

## License

Maître PSQL is released under the [MIT License](https://opensource.org/licenses/MIT).
