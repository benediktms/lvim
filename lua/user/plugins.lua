local M = {}

M.config = function()
	lvim.plugins = {
		{
			"LunarVim/darkplus.nvim",
		},
		{
			"ggandor/leap.nvim",
			name = "leap",
			config = function()
				local status_ok, leap = pcall(require, "leap")
				if not status_ok then
					return
				end

				leap.add_default_mappings()
			end,
		},
		{ "folke/zen-mode.nvim" },
		{ "folke/tokyonight.nvim" },
		{ "projekt0n/github-nvim-theme" },
		{
			"folke/twilight.nvim",
			config = function()
				local opts = {
					dimming = {
						alpha = 0.25, -- amount of dimming
						-- we try to get the foreground from the highlight groups or fallback color
						color = { "Normal", "#ffffff" },
						term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
						inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
					},
					context = 10, -- amount of lines we will try to show around the current line
					treesitter = true, -- use treesitter when available for the filetype
					-- treesitter is used to automatically expand the visible text,
					-- but you can further control the types of nodes that should always be fully expanded
					expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
						-- "function_declaration",
						"function",
						"method",
						"table",
						"if_statement",
					},
					exclude = {}, -- exclude these filetypes
				}
				require("twilight").setup(opts)
			end,
		},
		{
			"folke/trouble.nvim",
			cmd = "TroubleToggle",
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
			lazy = true,
			config = function()
				require("user.rust-tools").config()
			end,
			ft = { "rust", "rs" },
			enabled = lvim.user.rust_programming.enabled,
		},
		{
			"Saecki/crates.nvim",
			event = { "BufRead Cargo.toml" },
			config = function()
				local status_ok, crates = pcall(require, "crates")
				if not status_ok then
					return
				end

				local opts = {
					null_ls = {
						enabled = true,
						name = "crates.nvim",
					},
				}

				crates.setup(opts)
			end,
			enabled = lvim.user.rust_programming.enabled,
		},
		{ "mbbill/undotree" },
		{
			"chentoast/marks.nvim",
			config = function()
				require("user.marks").config()
			end,
			enabled = lvim.user.gutter_marks.enabled,
		},
		{
			"nvim-pack/nvim-spectre",
			event = { "BufRead" },
			config = function()
				-- see https://github.com/nvim-pack/nvim-spectre
				local opts = {
					mapping = {
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
					},
				}
				require("spectre").setup(opts)
			end,
		},
		{
			"nvim-tree/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({
					override = {
						vue = {
							icon = "󰡄",
							color = "#42D392",
							name = "Vue",
						},
					},
				})
			end,
		},
		{
			"nvim-treesitter/playground",
			config = function()
				local opts = {
					playground = {
						enable = true,
						disable = {},
						updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
						persist_queries = false, -- Whether the query persists across vim sessions
						keybindings = {
							toggle_query_editor = "o",
							toggle_hl_groups = "i",
							toggle_injected_languages = "t",
							toggle_anonymous_nodes = "a",
							toggle_language_display = "I",
							focus_language = "f",
							unfocus_language = "F",
							update = "R",
							goto_node = "<cr>",
							show_help = "?",
						},
					},
				}

				require("nvim-treesitter.configs").setup(opts)
			end,
		},
		{ "NoahTheDuke/vim-just" },
		{
			"lervag/vimtex",
			enabled = lvim.user.latex.enabled,
		},
		{ "fladson/vim-kitty" },
		{
			"smoka7/multicursors.nvim",
			event = "VeryLazy",
			dependencies = {
				"smoka7/hydra.nvim",
			},
			opts = {},
			cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
			keys = {
				{
					mode = { "v", "n" },
					"<Leader>m",
					"<cmd>MCstart<cr>",
					desc = "Create a selection for selected text or word under the cursor",
				},
			},
		},
		{
			"kaarmu/typst.vim",
			ft = "typst",
			lazy = false,
		},
	}
end

return M
