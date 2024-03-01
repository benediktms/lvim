local M = {}

M.config = function()
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
				lvim.user.functions.switch_case()
			end,
			"Switch case (camelCase/snake_case)",
		},
		z = { "<cmd>ZenMode<cr>", "Zen mode" },
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
end

return M
