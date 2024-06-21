function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
	vim.opt.background = "dark"
	-- vim.opt.background = "light"

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- For inside
ColorMyPencils("retrobox")
-- ColorMyPencils("gruvbox")
-- ColorMyPencils("habamax")

-- For outside
-- ColorMyPencils("zellner")
