vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

lvim.transparent_window = true
lvim.format_on_save = true

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

lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.view.width = 40

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
	x = { "<cmd>TSContextToggle<cr>", "Toggle context" },
	c = {
		function()
			switch_case()
		end,
		"Switch case (camelCase/snake_case)",
	},
}

lvim.builtin.which_key.mappings["H"] = {
	name = "Spectre",
	s = { "<cmd>lua require('spectre').open()<CR>", "Spectre" },
	f = { '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>' },
	w = { '<cmd>lua require("spectre").open_visual({select_word=true})<CR>' },
}

lvim.lsp.installer.setup.ensure_installed = { "tsserver", "rust_analyzer", "lua_ls", "emmet_ls" }
require("lvim.lsp.manager").setup("tsserver")
require("lvim.lsp.manager").setup("rust_analyzer")
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

lvim.plugins = {
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("hop").setup()
			vim.api.nvim_set_keymap("n", "s", ":HopWord<cr>", { silent = true })
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
					-- default = {
					-- 	"class",
					-- 	"function",
					-- 	"method",
					-- 	"mod",
					-- 	"struct",
					-- 	"impl",
					-- 	"fn",
					-- 	"local",
					-- 	"property",
					-- },
				},
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
		event = { "vimEnter" },
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
	{
		"simrat39/rust-tools.nvim",
		config = function()
			local status_ok, rust_tools = pcall(require, "rust-tools")
			if not status_ok then
				return
			end

			local opts = {
				tools = {
					executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
					reload_workspace_from_cargo_toml = true,
					inlay_hints = {
						auto = true,
						only_current_line = false,
						show_parameter_hints = true,
						parameter_hints_prefix = "",
						other_hints_prefix = "-> ",
						max_len_align = false,
						max_len_align_padding = 1,
						right_align = false,
						right_align_padding = 7,
						highlight = "Comment",
					},
					hover_actions = {
						auto_focus = true,
					},
				},
				server = {
					on_attach = require("lvim.lsp").common_on_attach,
					on_init = require("lvim.lsp").common_on_init,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
			}
			rust_tools.setup(opts)
		end,
		ft = { "rust", "rs" },
	},
	{ "mbbill/undotree" },
	{
		"chentoast/marks.nvim",
		config = function()
			local status_ok, marks = pcall(require, "marks")
			if not status_ok then
				return
			end

			local opts = {
				builtin_marks = {
					".",
					"'",
					"<",
					">",
					"^",
					"0",
					"$",
					"a",
					"b",
					"c",
					"d",
					"e",
					"f",
					"g",
					"h",
					"i",
					"j",
					"k",
					"l",
					"m",
					"o",
					"p",
					"q",
					"r",
					"s",
					"t",
					"u",
					"v",
					"w",
					"x",
					"y",
					"z",
				},
			}
			marks.setup(opts)
		end,
	},
	{
		"mrjones2014/nvim-ts-rainbow",
		config = function()
			require("nvim-treesitter.configs").setup({
				rainbow = {
					colors = {
						"#ffd700", -- gold
						"#da70d6", -- orchid
						"#87cefa", -- light sky blue
					},
					extended_mode = false,
				},
			})
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		config = function()
			-- see https://github.com/nvim-pack/nvim-spectre
			local opts = {
				mapping = {
					["toggle_line"] = {
						map = "dd",
						cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
						desc = "toggle current item",
					},
					["enter_file"] = {
						map = "<cr>",
						cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
						desc = "goto current file",
					},
					["send_to_qf"] = {
						map = "<leader>tq",
						cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
						desc = "send all item to quickfix",
					},
					["replace_cmd"] = {
						map = "<leader>c",
						cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
						desc = "input replace vim command",
					},
					["show_option_menu"] = {
						map = "<leader>o",
						cmd = "<cmd>lua require('spectre').show_options()<CR>",
						desc = "show option",
					},
					["run_current_replace"] = {
						map = "<leader>rc",
						cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
						desc = "replace current line",
					},
					["run_replace"] = {
						map = "<leader>R",
						cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
						desc = "replace all",
					},
					["change_view_mode"] = {
						map = "<leader>v",
						cmd = "<cmd>lua require('spectre').change_view()<CR>",
						desc = "change result view mode",
					},
					["change_replace_sed"] = {
						map = "trs",
						cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
						desc = "use sed to replace",
					},
					["change_replace_oxi"] = {
						map = "tro",
						cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
						desc = "use oxi to replace",
					},
					["toggle_live_update"] = {
						map = "tu",
						cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
						desc = "update change when vim write file.",
					},
					["toggle_ignore_case"] = {
						map = "ti",
						cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
						desc = "toggle ignore case",
					},
					["toggle_ignore_hidden"] = {
						map = "th",
						cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
						desc = "toggle search hidden",
					},
					["resume_last_search"] = {
						map = "<leader>l",
						cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
						desc = "resume last search before close",
					},
				},
			}
			require("spectre").setup(opts)
		end,
	},
}

lvim.builtin.treesitter.rainbow.enable = true
