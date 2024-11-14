-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = ","
vim.opt.colorcolumn = "80"
vim.opt.textwidth = 78
vim.tex_flavour = "latex"

vim.g.python3_host_prog = "/Users/sonntaghimself/.pyenv/shims/python3"
vim.g.python_host_prog = "/Users/sonntaghimself/.pyenv/shims/python"
-- let g:python_host_prog = $HOME.'/.virtualenvs/neovim2-[pipenv garbage]/bin/python'
-- " and same for g:python3_host_prog

vim.api.nvim_command("let g:cmdline_vsplit=1")
vim.g.cmdline_follow_colorscheme = 1
vim.api.nvim_command("let g:cmdline_term_width=80")
vim.g.cmdline_app = { python = "ipython" }
vim.api.nvim_command("let g:cmdline_map_start = '<leader>s'")
vim.api.nvim_command("let g:cmdline_map_send = '<return>'")

-- Don't treat .rnw as an R filetype
vim.g.R_filetypes = { "r" }

vim.api.nvim_command("let g:vimtex_view_method = 'skim'")
vim.api.nvim_command("let g:vimtex_compiler_latexmk = {'aux_dir' : '../AuxFiles/', 'out_dir' : '../', 'continuous': 1}")

vim.opt.foldmethod = "marker"
