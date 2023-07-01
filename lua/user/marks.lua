local M = {}

M.config = function()
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
end

return M
