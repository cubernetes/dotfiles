vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "ca\"", "vi\"lohc")
vim.keymap.set("n", "ca'", "vi'lohc")
vim.keymap.set("n", "da\"", "vi\"lohd")
vim.keymap.set("n", "da'", "vi'lohd")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end)

-- vims quickfix feature, don't need it atm
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>X", "<cmd>w<CR><cmd>!./%<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>wq<CR>")
-- vim.keymap.set("n", "<leader>P", "<cmd>w<CR><cmd>!sent *.sent<CR>")
vim.keymap.set("n", "<leader><leader>X", "<cmd>w<CR><cmd>!chmod +x %<CR><CR>")

vim.keymap.set("n", "<leader>x", ":w<CR>:!cc -std=c89 -Wall -Wextra -pedantic -Wconversion -g3 -O0 -o main *.c && ./main ; rm -f ./main<CR>")
-- vim.keymap.set("n", "<leader>x", ":w<CR>:!cc -std=c89 -Wall -Wextra -pedantic -Wconversion -g3 -O0 -o main *.c<CR>")
-- vim.keymap.set("n", "<leader>x", ":w<CR>:!cc -trigraphs -Wall -Wextra -pedantic -Wconversion -g3 -O0 -o main *.c && echo 'OUTPUT:' ; ./main<CR>")

vim.keymap.set("n", "<leader>c", "mz:s/\\(^\\s*\\)\\(.*$\\)/\\1\\/* \\2 *\\//g<CR>:noh<CR>`z")
vim.keymap.set("n", "<leader>C", "mz:s/\\/\\* \\(.*\\) \\*\\//\\1/g<CR>:noh<CR>`z")
vim.keymap.set("v", "<leader>c", "mz:s/\\(^\\s*\\)\\(.*$\\)/\\1\\/* \\2 *\\//g<CR>:noh<CR>`z")
vim.keymap.set("v", "<leader>C", "mz:s/\\/\\* \\(.*\\) \\*\\//\\1/g<CR>:noh<CR>`z")

vim.fn.setreg("t", "m5`1v`2y`3v`4p`1v`2p`5")
vim.keymap.set("n", "<C-t>", "m3yiwi<CR> <C-w><ESC>m2`1bviwp`2viwp`2i<BS><ESC>`3")

-- vim.keymap.set("i", "{<CR>", "<CR>{<CR>}<ESC>O")
vim.keymap.set("n", "*", "#*")
