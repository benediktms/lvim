--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
-- helpers

-- @param str the string to be trimmed
local function trunc(str)
	local length = #str
	local max_len = 18
	if length >= max_len then
		return str:sub(1, max_len) .. "..."
	end
	return str
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "darkplus"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false
vim.opt.relativenumber = true
vim.opt.background = "dark"

vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
		["<C-n>"] = actions.cycle_history_next,
		["<C-p>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["<C-j>"] = actions.move_selection_next,
		["<C-k>"] = actions.move_selection_previous,
	},
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
	name = "Trouble",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.which_key.mappings["o"] = {
	name = "Other",
	t = { "<cmd>MinimapToggle<cr>", "Toggle code minimap" },
	m = { "<cmd>Glow<cr>", "Preview markdown file in glow" },
}

lvim.builtin.which_key.vmappings["s"] = {
	name = "Sort",
	a = { "<cmd>'<, '>%sort<cr>", "ASC" },
	d = { "<cmd>'<, '>%sort!<cr>", "DESC" },
	n = { "<cmd>'<, '>%sort n<cr>", "DESC" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

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
-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumeko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	-- { command = "black", filetypes = { "python" } },
	{
		-- { command = "isort", filetypes = { "python" } },
		-- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
		command = "prettierd",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
		-- extra_args = { "--print-with", "100" },
		---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
		-- filetypes = { "typescript", "typescriptreact" },
	},
	{ command = "stylua" },
	{ command = "rustfmt", extra_args = { "--edition", "2018" } },
})

-- -- set additional linters
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	--   { command = "flake8", filetypes = { "python" } },
	{ command = "eslint_d" },
	-- { command = "luacheck" },
	{ command = "shellcheck" },
	--   {
	--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
	--     command = "shellcheck",
	--     ---@usage arguments to pass to the formatter
	--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
	--     extra_args = { "--severity", "warning" },
	--   },
	--   {
	--     command = "codespell",
	--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
	--     filetypes = { "javascript", "python" },
	--   },
})

-- Additional Plugins
lvim.plugins = {
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{ "LunarVim/darkplus.nvim" },
	{ "pantharshit00/vim-prisma" },
	{ "jparise/vim-graphql" },
	{
		"wfxr/minimap.vim",
		run = "cargo install --locked code-minimap",
		cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
		config = function()
			vim.cmd("let g:minimap_width = 10")
			vim.cmd("let g:minimap_auto_start = 1")
			vim.cmd("let g:minimap_auto_start_win_enter = 1")
		end,
	},
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
						"mod",
						"struct",
						"impl",
						"fn",
						"local",
						"property",
					},
				},
			})
		end,
	},
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			local hop = require("hop")
			hop.setup()
			-- local directions = require("hop.hint").HintDirection
			-- vim.keymap.set("", "f", function()
			-- 	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
			-- end, { remap = true })
			-- vim.keymap.set("", "F", function()
			-- 	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
			-- end, { remap = true })
			-- vim.keymap.set("", "t", function()
			-- 	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
			-- end, { remap = true })
			-- vim.keymap.set("", "T", function()
			-- 	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
			-- end, { remap = true })
			-- vim.api.nvim_set_keymap("n", "S", ":HopChar2<cr>", { silent = true })
			vim.api.nvim_set_keymap("n", "s", ":HopWord<cr>", { silent = true })
		end,
	},
	{
		"npxbr/glow.nvim",
		ft = { "markdown" },
	},
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
		end,
	},
	{
		"f-person/git-blame.nvim",
		event = "BufRead",
		config = function()
			vim.cmd("highlight default link gitblame SpecialComment")
			vim.g.gitblame_enabled = 0
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		event = { "VimEnter" },
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					suggestion = {
						enabled = true,
						auto_trigger = true,
						keymap = {
							accept = "<C-l>",
							dismiss = "<C-;>",
							next = "<C-j>",
							prev = "<C-k>",
						},
					},
				})
			end, 100)
		end,
	},
	-- { "p00f/nvim-ts-rainbow" },
}

-- lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
-- table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
-- lvim.builtin.treesitter.rainbow.enable = true
-- lvim.builtin.treesitter.rainbow.max_file_lines = 5000
-- lvim.builtin.treesitter.rainbow.colors = {
-- 	"Gold",
-- 	"Orchid",
-- 	"LightSkyBlue",
-- }

vim.api.nvim_exec(
	[[
  augroup telescope
      autocmd!
      autocmd FileType TelescopePrompt inoremap <buffer> <silent> <C-r> <C-r>
  augroup END
  ]],
	false
)

-- vim.api.nvim_create_autocmd("BufEnter", {
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
