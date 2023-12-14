-- RECIPE
-- vim +'redir >outfile' +'hi' +'redir END' +'q'
-- :Inspect
-- :CocInstall coc-clangd coc-css coc-html coc-json coc-lua coc-pyright coc-rust-analyzer coc-tsserver coc-texlab
-- :CocCommand clangd.install
-- Coc key bindings C-n C-p C-y C-e C-j C-k
-- pip install pynvim --upgrade
-- npm i -g neovim tree-sitter tree-sitter-cli

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {'navarasu/onedark.nvim'},
  {'rmehri01/onenord.nvim'},
  {'neoclide/coc.nvim', branch = 'master', build = 'npm ci'},
  {'numToStr/Comment.nvim', opts = {}},
  {'easymotion/vim-easymotion'},
})

-- automatically remove extra spaces
vim.api.nvim_create_autocmd({'BufWritePre'}, {
  pattern = {'*'},
  callback = function()
  pcall(function() vim.cmd([[normal mq]]) end)
  vim.cmd([[%s/\s\+$//e]])
  vim.cmd([[%s/\n\n\n\+/\r\r/e]])
  pcall(function() vim.cmd([[normal `q]]) end)
end
})

-- disable folding
vim.api.nvim_create_autocmd({'BufWritePost' , 'BufEnter'}, {
  pattern = {'*'},
  callback = function(_) -- arg is ev
	  vim.o.foldenable = false
	  vim.o.foldmethod = 'manual'
	  vim.o.foldlevelstart = 99
    vim.diagnostic.config({signs = false})
  end
})

vim.cmd([[let g:python_recommended_style = 0]])
vim.cmd([[au Filetype * setlocal ts=2 sts=0 sw=2]])
vim.cmd([[au FileType * set formatoptions-=cro]])
vim.cmd.colorscheme('onedark')
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.python3_host_prog = '/home/ashoka/.app/python/bin/python'
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.background='dark'
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.laststatus = 0 -- lualine
vim.o.mouse = 'a'
vim.o.ruler = false
vim.o.shiftround = 2
vim.o.shiftwidth = 2
vim.o.showmode = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 9999
vim.o.ttimeoutlen = 0
vim.opt.shell = '/usr/bin/fish'
vim.wo.number = false
vim.wo.relativenumber = false

function AttachString()
  local start = vim.fn.search('---', 'bW') + 1
  local end1 = vim.fn.search('---', 'W')
  if end1==0 then end1 = vim.fn.line('$') else end1 = end1-1 end
  vim.print(start .. ' ' .. end1)
  vim.cmd(start .. ',' .. end1 .. 's/$/' .. vim.fn.getreg('"') )
  vim.cmd('norm ' .. start .. 'Gd' .. end1 .. 'G')
end

SpellCheckStatus = false
FileType = 'plaintex'

function ToggleSpellCheck()
  if SpellCheckStatus == false then
    vim.cmd('setlocal spell spelllang=en_us')
    FileType = vim.o.filetype
    vim.o.filetype = 'plaintex'
  else
    vim.o.filetype = FileType
    vim.cmd('setlocal nospell')
  end
  SpellCheckStatus = not SpellCheckStatus
end

function ToggleColorScheme()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
    vim.cmd.colorscheme('onenord')
  else
    vim.o.background = 'dark'
    vim.cmd.colorscheme('onedark')
  end
end

vim.keymap.set('n', '<leader>a', '<Plug>(coc-codeaction)', {}) --code action
vim.keymap.set('n', '<leader>c', ToggleColorScheme, {noremap = true}) -- toggle color
vim.keymap.set('n', '<leader>d', '<Plug>(coc-definition)', {noremap = true}) --go to definition
vim.keymap.set({'n', 'v'}, '<leader>f', '<Plug>(easymotion-bd-w)', {noremap = true}) -- easymotion
vim.keymap.set('n', '<leader>h', ':tab help ', {noremap = true}) --search file
vim.keymap.set('n', '<leader>n', '<cmd>tabnew<CR>', {noremap = true}) --new tab
vim.keymap.set('n', '<leader>o', ':tabe ', {noremap = true}) --open file
vim.keymap.set('n', '<leader>q', '<cmd>qa<CR>', {noremap = true}) --exit
vim.keymap.set('n', '<leader>r', '<Plug>(coc-references)', {noremap = true}) --search references
vim.keymap.set('n', '<leader>s', ToggleSpellCheck, {noremap = true}) -- check spelling
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR><cmd>terminal<CR>a', {noremap = true}) --search references
vim.keymap.set('n', '<leader>v', '<Plug>(coc-rename)', {noremap = true}) --rename
vim.keymap.set('n', '<leader>w', '<Plug>(coc-diagnostic-next)', {noremap = true}) --next warning
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', {noremap = true}) --close window
vim.keymap.set('n', '<leader>X', '<cmd>bd!<CR>', {noremap = true}) --force close window
vim.keymap.set('n', '<leader>y', AttachString, {noremap = true})
vim.keymap.set('n', 'N', 'Nzz', {noremap = true})
vim.keymap.set('n', 'n', 'nzz', {noremap = true})
vim.keymap.set({'i','n'}, '<M-s>', '<Esc><cmd>w<CR>', {silent=true, noremap = true}) --save file
vim.keymap.set({'t'}, '<M-s>', '<C-\\><C-n>G', {silent=true, noremap = true}) --save file
vim.keymap.set({'i'}, '<M-o>', "<Esc>o", {silent=true, noremap = true}) --insert a line
vim.keymap.set({'n', 'v'}, ',', 'gkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkg0', {noremap = true}) -- previous page <C-b>M
vim.keymap.set({'n', 'v'}, '<C-j>', 'j', {noremap = true})
vim.keymap.set({'n', 'v'}, '<C-k>', 'k', {noremap = true})
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'j', "v:count == 0 ? 'gj' : 'j'", { noremap=true, expr = true, silent = true })
vim.keymap.set({'n', 'v'}, 'k', "v:count == 0 ? 'gk' : 'k'", { noremap=true, expr = true, silent = true })
vim.keymap.set({'n', 'v'}, 't', 'gjgjgjgjgjgjgjgjgjgjgjgjgjgjgjgjgjgjg0', {noremap = true}) -- next page <C-f>M
vim.keymap.set({'n'}, '<M-o>', "moO<Esc>'o`o", {silent=true, noremap = true}) --insert a line
vim.keymap.set({'o','x'}, 'ac', '<Plug>(coc-classobj-a)', {noremap=true})
vim.keymap.set({'o','x'}, 'af', '<Plug>(coc-funcobj-a)', {noremap=true})
vim.keymap.set({'o','x'}, 'ic', '<Plug>(coc-classobj-i)', {noremap=true})
vim.keymap.set({'o','x'}, 'if', '<Plug>(coc-funcobj-i)', {noremap=true})

