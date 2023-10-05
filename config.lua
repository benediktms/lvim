vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

lvim.user = {}
lvim.user.rust_programming = { enabled = true }
lvim.user.gutter_marks = { enabled = true }
lvim.user.latex = { enabled = true }
lvim.user.db = { enabled = true }
lvim.transparent_window = true

local user = vim.env.USER
if user and user == "benediktschnatterbeck" then
	lvim.reload_config_on_save = true
	require("user.features").config()
	lvim.user.functions = require("user.functions")
end

lvim.format_on_save = true
lvim.colorscheme = "github_dark_dimmed"

lvim.leader = "space"

lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.insert_mode["<C-s>"] = "<Esc> :w<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- lvim.builtin.lualine.options.theme = "tokyonight"
lvim.builtin.lualine.sections.lualine_b = {
	{
		"branch",
		fmt = lvim.user.functions.trunc,
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

require("user.which-key").config()

lvim.lsp.installer.setup.ensure_installed = { "tsserver", "rust_analyzer", "lua_ls", "emmet_ls", "eslint" }
require("lvim.lsp.manager").setup("tsserver")
require("lvim.lsp.manager").setup("eslint")
require("lvim.lsp.manager").setup("lua_ls")
require("lvim.lsp.manager").setup("emmet_ls")

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "prettierd" },
	{ command = "stylua" },
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
