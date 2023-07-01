local M = {}

-- @param str the string to be trimmed
M.trunc = function(str)
	local length = #str
	local max_len = 18
	if length >= max_len then
		return str:sub(1, max_len) .. "..."
	end
	return str
end

-- fucntion to toggle between camelCase and snake_case
M.switch_case = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local word = vim.fn.expand("<cword>")
	local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

	-- detect camelCase
	if word:find("[a-z][A-Z]") then
		-- convert camelCase to snake_case
		local snake_case_word = word:gsub("%u", "_%0"):gsub("^_", ""):lower()
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
	-- detect snake_case
	elseif word:find("[a-z]_[a-z]") then
		-- convert snake_case to camelCase
		local camel_case_word = word:gsub("_(%l)", function(l)
			return l:upper()
		end)
		vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
	else
		print("Not a snake_case or camelCase word")
	end
end

return M
