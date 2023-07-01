vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

lvim.user = {}
lvim.user.rust_programming = { enabled = true }
lvim.user.gutter_marks = { enabled = true }

local user = vim.env.USER
if user and user == "benedikt" then
	lvim.reload_config_on_save = true
	require("user.features").config()
end

lvim.format_on_save = true
lvim.colorscheme = "tokyonight-moon"

lvim.leader = "space"

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.insert_mode["<C-s>"] = "<Esc> :w<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- @param str the string to be trimmed
local function trunc(str)
	local length = #str
	local max_len = 18
	if length >= max_len then
		return str:sub(1, max_len) .. "..."
	end
	return str
end

-- fucntion to toggle between camelCase and snake_case
local function switch_case()
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

lvim.builtin.lualine.options.theme = "tokyonight"
lvim.builtin.lualine.sections.lualine_b = {
	{
		"branch",
		fmt = trunc,
		icon = {
			lvim.icons.git.Branch,
			color = { fg = "orange" },
		},
		color = { gui = "bold", fg = "#bbc2cf" },
	},
}

lvim.builtin.lualine.sections.lualine_c = {
	{ "filename", file_status = true, path = 1 },
}

local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
	},
}

lvim.builtin.which_key.vmappings["s"] = {
	name = "Sort",
	a = { "<cmd>'<, '>%sort<cr>", "ASC" },
	d = { "<cmd>'<, '>%sort!<cr>", "DESC" },
	n = { "<cmd>'<, '>%sort n<cr>", "DESC" },
}

lvim.builtin.which_key.mappings["o"] = {
	name = "Other",
	u = { "<cmd>UndotreeToggle<cr>", "Toggle undo tree" },
	c = {
		function()
			switch_case()
		end,
		"Switch case (camelCase/snake_case)",
	},
}

lvim.builtin.which_key.mappings["x"] = {
	name = "TS Context",
	x = { "<cmd>TSContextToggle<cr>", "Toggle scrope context" },
	t = { "<cmd>Twilight<cr>", "Toggle twilight" },
}

lvim.builtin.which_key.mappings["t"] = {
	name = "Trouble Diagnostics",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.which_key.mappings["H"] = {
	name = "Spectre",
	s = { "<cmd>lua require('spectre').open()<CR>", "Spectre" },
	f = { '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>' },
	w = { '<cmd>lua require("spectre").open_visual({select_word=true})<CR>' },
}

lvim.lsp.installer.setup.ensure_installed = { "tsserver", "rust_analyzer", "lua_ls", "emmet_ls", "eslint" }
require("lvim.lsp.manager").setup("tsserver")
require("lvim.lsp.manager").setup("eslint")
require("lvim.lsp.manager").setup("lua_ls")
require("lvim.lsp.manager").setup("emmet_ls")

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "prettierd" },
	{ command = "stylua" },
	{ command = "rustfmt" },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "eslint_d" },
	{ command = "shellcheck" },
})

lvim.autocommands = {
	{
		{ "ColorScheme" },
		{
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "TSRainbowYellow", { fg = "#FFD700" })
				vim.api.nvim_set_hl(0, "TSRainbowMagenta", { fg = "#DA70D6" })
				vim.api.nvim_set_hl(0, "TSRainbowBlue", { fg = "#87CEFA" })
			end,
		},
	},
}

require("user.plugins").config()

lvim.builtin.treesitter.rainbow.enable = true
