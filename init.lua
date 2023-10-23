--[[
Use Alt-l and stay mostly in normal mode.
This configuration file provides the following additional key mappings:

t             next page
,             previous page
f             jump to a desired location on screen
Alt-o         insert a line
Alt-s         save file in insert mode or normal mode
<Space>x      close window gracefully
<Space>X      close window forced
:Q            forced quit all

<Space>fb     file browser
<Space>sf     search file
<Space>sh     search help
<Space>sr     search references
<Space>sc     show current colorscheme or use n-th colorscheme
<Space>tc     toggle between light and dark theme

gc            toggle comment
ic/ac         class object during selecton and deletion
if/af         function object during selecton and deletion
<Space>ca     code action
<Space>gd     jump to definition
<Space>rn     rename varaible
<Space>nw     show next warning or error

--]]

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,})
end
vim.opt.rtp:prepend(lazypath)

-- RECIPE
-- vim +'redir >outfile' +'hi' +'redir END' +'q'
-- :Inspect
-- :CocInstall coc-clangd coc-css coc-html coc-json coc-lua coc-pyright coc-rust-analyzer coc-tsserver coc-texlab
-- :CocCommand clangd.install
-- Coc key bindings C-n C-p C-y C-e C-j C-k
-- pip install pynvim --upgrade
-- npm i -g neovim tree-sitter tree-sitter-cli
-- apt install ripgrep fd-find #(for telescope and CoC)

require('lazy').setup({
  {'navarasu/onedark.nvim'},
  {'rmehri01/onenord.nvim'},
  {'neoclide/coc.nvim', branch = 'master', build = 'npm ci'},
  {'numToStr/Comment.nvim', opts = {}},
  {'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}},
  {'nvim-treesitter/nvim-treesitter', dependencies = {'nvim-treesitter/nvim-treesitter-textobjects',}, build = ':TSUpdate',},
  {'easymotion/vim-easymotion'},
  -- {'phaazon/hop.nvim'},
  {'stevearc/oil.nvim', opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" },},
})
-- require'hop'.setup {keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5}
require('oil').setup()
require('telescope').setup {pickers = {find_files = {mappings={i={['<CR>']=require('telescope.actions').file_tab}}}}}
require('nvim-treesitter.configs').setup {
  ensure_installed = {'c', 'cpp', 'javascript', 'latex', 'lua', 'python', 'rust', 'vimdoc'},
  sync_install = false,
  auto_install = true,
  additional_vim_regex_highlighting = false,
  use_languagetree = true,
  highlight = {
    enable=true,
    disable = function(_, buf) -- first arg is lang
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return (ok and stats and (stats.size > 1024*1024))
    end,
  },
}

-- automatically remove extra spaces
vim.api.nvim_create_autocmd({'BufWritePre'}, {
  pattern = {'*'},
  command = [[%s/\s\+$//e]],
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

vim.cmd([[ let g:python_recommended_style = 0 ]])
vim.cmd([[au Filetype * setlocal ts=2 sts=0 sw=2]])
vim.cmd([[au FileType * set formatoptions-=cro]])
vim.cmd([[cabbr h tab help]]) -- open help in new tab
vim.cmd([[cabbr Q qa!]]) -- open help in new tab
-- vim.cmd([[let g:coc_snippet_next = '<c-j>']])
-- vim.cmd([[let g:coc_snippet_prev = '<c-k>']])
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
-- vim.g.loaded_python3_provider = 0
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

vim.keymap.set('n', '<leader>fb', ':tabnew<CR>:Oil /home/ashoka<CR>', {}) --file browser
vim.keymap.set('n', '<leader>gd', '<Plug>(coc-definition)', {noremap = true}) --go to definition
vim.keymap.set('n', '<leader>nw', '<Plug>(coc-diagnostic-next)', {noremap = true}) --next warning
vim.keymap.set('n', '<leader>rn', '<Plug>(coc-rename)', {noremap = true}) --rename
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files({cwd='/home/ashoka',}) end, {noremap = true}) --search file
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, {}) --search help
vim.keymap.set('n', '<leader>sr', '<Plug>(coc-references)', {noremap = true}) --search references
vim.keymap.set('n', '<leader>X', '<cmd>bd!<CR>', {noremap = true}) --force close window
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>', {noremap = true}) --close window
vim.keymap.set('n', 'N', 'Nzz', {noremap = true})
vim.keymap.set('n', 'n', 'nzz', {noremap = true})
vim.keymap.set({'n', 'v'}, '<C-j>', 'j', {noremap = true})
vim.keymap.set({'n', 'v'}, '<C-k>', 'k', {noremap = true})
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', {silent = true})
vim.keymap.set({'n', 'v'}, 'j', "v:count == 0 ? 'gj' : 'j'", { noremap=true, expr = true, silent = true })
vim.keymap.set({'n', 'v'}, 'k', "v:count == 0 ? 'gk' : 'k'", { noremap=true, expr = true, silent = true })
vim.keymap.set({'n','v'}, '<leader>ca', '<Plug>(coc-codeaction)', {}) --code action
vim.keymap.set({'o','x'}, 'ac', '<Plug>(coc-classobj-a)', {noremap=true})
vim.keymap.set({'o','x'}, 'af', '<Plug>(coc-funcobj-a)', {noremap=true})
vim.keymap.set({'o','x'}, 'ic', '<Plug>(coc-classobj-i)', {noremap=true})
vim.keymap.set({'o','x'}, 'if', '<Plug>(coc-funcobj-i)', {noremap=true})

vim.keymap.set({'i'}, '<M-o>', "<Esc>o", {silent=true, noremap = true}) --insert a line
vim.keymap.set({'n'}, '<M-o>', "moO<Esc>'o`o", {silent=true, noremap = true}) --insert a line
vim.keymap.set({'i','n'}, '<M-s>', '<Esc><cmd>w<CR>', {silent=true, noremap = true}) --save file
vim.keymap.set({'n', 'v'}, ',', '<C-b>M', {noremap = true}) -- previous page
vim.keymap.set({'n', 'v'}, 'f', '<Plug>(easymotion-bd-w)', {noremap = true}) -- hop <cmd>HopWord<CR>
vim.keymap.set({'n', 'v'}, 't', '<C-f>M', {noremap = true}) -- next page

-- not useful in general, not recommended
function IndexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then return i end
    end
    return nil
end

Colorschemes = vim.fn.getcompletion('', 'color')
CsDark = IndexOf(Colorschemes, "onedark")
CsLight = IndexOf(Colorschemes, "onenord")
Csn = CsDark

function Start_up_func()
  print(Colorschemes[Csn], '--', Csn)
end

function ShowColorScheme()
  if vim.v.count ~= 0 then
    Csn = vim.v.count
  end
  Csn = Csn% #Colorschemes + 1
  vim.cmd.colorscheme(Colorschemes[Csn])
  Csn = (Csn - 2 + #Colorschemes)% #Colorschemes + 1
  vim.cmd.colorscheme(Colorschemes[Csn])
  local timer = vim.loop.new_timer()
  timer:start(500, 0, vim.schedule_wrap(Start_up_func))
end

function ToggleColorScheme()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
    Csn = CsLight
  else
    vim.o.background = 'dark'
    Csn = CsDark
  end
  ShowColorScheme()
end

ShowColorScheme()

vim.keymap.set('n', '<leader>sc', ShowColorScheme, {noremap = true}) -- show color
vim.keymap.set('n', '<leader>tc', ToggleColorScheme, {noremap = true}) -- toggle color

function AttachString()
  local start = vim.fn.search('---', 'bW') + 1
  local end1 = vim.fn.search('---', 'W')
  if end1==0 then end1 = vim.fn.line('$') else end1 = end1-1 end
  vim.print(start .. ' ' .. end1)
  vim.cmd(start .. ',' .. end1 .. 's/$/' .. vim.fn.getreg('"') )
  vim.cmd('norm ' .. start .. 'Gd' .. end1 .. 'G')
end

vim.keymap.set('n', '<leader>as', AttachString, {noremap = true})

