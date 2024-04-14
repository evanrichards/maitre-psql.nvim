-- A simple HTTP client in Lua using curl for Neovim.
local M = {}

-- Function to make an HTTP request
-- @param method (string): The HTTP method (e.g., "GET", "POST")
-- @param url (string): The URL to which the request will be made
-- @param headers (table): A table containing HTTP headers
-- @param body (string|nil): The JSON body for the request (if needed)
-- @return success (boolean): Whether the request was successful
-- @return response (string): The response body or error message
function M.request(method, url, headers, body)
	local curl_cmd = { "curl", "-s", "-X", method, "-w", '"\\n%{http_code}"' }

	-- Add headers to the curl command
	for k, v in pairs(headers) do
		table.insert(curl_cmd, "-H")
		table.insert(curl_cmd, string.format("'%s: %s'", k, v))
	end

	-- Add body if provided and the method supports it
	if body and (method == "POST" or method == "PUT" or method == "PATCH") then
		table.insert(curl_cmd, "-d")
		table.insert(curl_cmd, string.format("'%s'", body))
	end

	-- Add the URL
	table.insert(curl_cmd, string.format("'%s'", url))

	-- Convert command array to string for execution
	local command = table.concat(curl_cmd, " ")

	-- Execute the curl command and capture output
	local output = vim.fn.systemlist(command)

	-- Ensure there is a status code to process
	if not output or #output == 0 then
		vim.notify("Curl did not return any output", vim.log.levels.ERROR)
		print("Curl did not return any output")
		return false, "Curl did not return any output"
	end

	-- Extract HTTP status code which should be on the last line
	local http_status_line = output[#output]
	local http_status = tonumber(string.match(http_status_line, "(%d+)$"))
	if not http_status then
		vim.notify("Error: HTTP status code is missing or not a number", vim.log.levels.ERROR)
		return false, "HTTP status code is missing or not a number"
	end

	-- Remove the status code from the output
	table.remove(output, #output)

	-- Determine success from the HTTP status code
	local success = (http_status >= 200 and http_status < 300)
	local response = table.concat(output, "\n")
	return success, response
end

return M
