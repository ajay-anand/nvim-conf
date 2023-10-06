local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath, })
end
vim.opt.rtp:prepend(lazypath)

-- RECIPE
-- vim +'redir >outfile' +'hi' +'redir END' +'q'
-- :Inspect
-- :CocInstall coc-clangd coc-css coc-html coc-json coc-lua coc-pyright coc-rust-analyzer coc-tsserver
-- Coc key bindings C-n C-p C-y C-e C-j C-k
-- :CocConfig json settings diagnostic.enable, clangd.enabled, pyright.inlayHints.enable

require("lazy").setup({

  { 'catppuccin/nvim', name = "catppuccin", priority = 1000 },
  { 'rmehri01/onenord.nvim' },
  { 'mcchrish/zenbones.nvim', dependencies = { {'rktjmp/lush.nvim'} } },
  { 'neoclide/coc.nvim', branch = 'master', build = 'npm ci' },
  { 'numToStr/Comment.nvim', opts = {} },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-treesitter/nvim-treesitter', dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects', }, build = ':TSUpdate', },
  { 'phaazon/hop.nvim' },
})
local Builtin = require('telescope.builtin')
require'hop'.setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "javascript", "latex", "lua", "python", "rust", "vimdoc" },
  sync_install = false,
  auto_install = true,
  additional_vim_regex_highlighting = false,
  use_languagetree = false,
  highlight = {
    enable=true,
    disable = function(lang, buf)
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return (ok and stats and (stats.size > 1024*1024))
    end,
  },
}

require('telescope').setup { pickers = { find_files = { mappings={i={["<CR>"]=require("telescope.actions").file_tab}} } } }
vim.keymap.set('n', '<leader>sh', Builtin.help_tags, {}) -- search help

math.randomseed(os.time())

Coc = 1
Colorschemes = vim.fn.getcompletion('', 'color')
Csn = math.random(1000000)
CsLight = 0

function IndexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then return i end
    end
    return nil
end

function CocToggle()
  Coc = 1 - Coc
  if Coc==1 then vim.cmd([[CocEnable]]) else vim.cmd([[CocDisable]]) end
end

function Start_up_func()
  print(Colorschemes[Csn], '--', Csn)
end

function ShowColorScheme()
  Csn = Csn% #Colorschemes + 1
  vim.cmd.colorscheme(Colorschemes[Csn])
  Csn = (Csn - 2 + #Colorschemes)% #Colorschemes + 1
  vim.cmd.colorscheme(Colorschemes[Csn])
  local timer = vim.loop.new_timer()
  timer:start(500, 0, vim.schedule_wrap(Start_up_func))
end

function SelectNextColorScheme()
  if vim.v.count == 0 then
    Csn = Csn%#Colorschemes + 1
  else
    Csn = vim.v.count
  end
  ShowColorScheme()
end

function SelectPrevColorScheme()
  if vim.v.count == 0 then
    Csn = (Csn - 2 + #Colorschemes)%#Colorschemes + 1
  else
    Csn = vim.v.count
  end
  ShowColorScheme()
end

function ToggleColorScheme()
  CsLight = 1 - CsLight
  if CsLight == 1 then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
  ShowColorScheme()
end


vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ "BufWritePost" , "BufEnter" }, {
  pattern = { "*" },
  callback = function(ev)
	  vim.o.foldenable = false
	  vim.o.foldmethod = "manual"
	  vim.o.foldlevelstart = 99
    vim.diagnostic.config({ signs = false })
  end
})



-- SelectNextColorScheme()

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.o.background="dark"
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

-- vim.cmd([[au Filetype python setlocal ts=2 sts=0 sw=2]])
vim.cmd([[ let g:python_recommended_style = 0 ]])
vim.cmd([[cabbr h tab help]])
vim.cmd([[cabbr q qa!]])
vim.cmd([[let g:coc_snippet_next = '<c-j>']])
vim.cmd([[let g:coc_snippet_prev = '<c-k>']])
vim.keymap.set("n", "<C-j>", "gj", { noremap = true})
vim.keymap.set("n", "<C-k>", "gk", { noremap = true})
vim.keymap.set("n", "<C-w>c", "<cmd>bd!<CR>", { noremap = true})
vim.keymap.set("n", "N", "Nzz", { noremap = true})
vim.keymap.set("n", "n", "nzz", { noremap = true})
vim.keymap.set('n', '<leader>nc', '<cmd>lua SelectNextColorScheme()<CR>', {noremap = true}) -- next color
vim.keymap.set('n', '<leader>nw', '<Plug>(coc-diagnostic-next)', {noremap = true}) -- next color
vim.keymap.set('n', '<leader>pc', '<cmd>lua SelectPrevColorScheme()<CR>', {noremap = true}) -- previous color
vim.keymap.set('n', '<leader>sc', '<cmd>lua ShowColorScheme()<CR>', {noremap = true}) -- show color
vim.keymap.set('n', '<leader>sf', function() Builtin.find_files({cwd='/home/ashoka', }) end, {}) -- search file
vim.keymap.set('n', '<leader>ta', CocToggle, {}) -- toggle autocomplete
vim.keymap.set('n', '<leader>tc', '<cmd>lua ToggleColorScheme()<CR>', {noremap = true}) -- toggle color
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', {noremap = true}) -- toggle color
vim.keymap.set('n', 'f', "<cmd>HopWord<CR>", {noremap = true})
vim.keymap.set('v', 'f', "<cmd>HopWord<CR>", {noremap = true})
vim.keymap.set({"n", "v"}, ",", "<C-b>M", { noremap = true})
vim.keymap.set({"n", "v"}, "gj", "j", {noremap = true})
vim.keymap.set({"n", "v"}, "gk", "k", {noremap = true})
vim.keymap.set({"n", "v"}, "j", "gj", {noremap = true})
vim.keymap.set({"n", "v"}, "k", "gk", {noremap = true})
vim.keymap.set({"n", "v"}, "t", "<C-f>M", { noremap = true})

-- DiagnosticEnabled = 1
-- function MyDiagnosticJump()
--   vim.diagnostic.goto_next()
--   vim.cmd('norm zz')
-- end
-- function ToggleDiagnostics()
--   DiagnosticEnabled = 1 - DiagnosticEnabled
--   if DiagnosticEnabled == 0 then vim.diagnostic.disable() else vim.diagnostic.enable() end
-- end
-- function LspConfig(client, bfnr)
--   client.server_capabilities.semanticTokensProvider = nil
--   vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer = 0}) -- code action
--   vim.keymap.set('n', '<leader>nw', MyDiagnosticJump, {buffer = 0}) -- next warning
--   vim.keymap.set('n', '<leader>rv', vim.lsp.buf.rename, {buffer = 0}) -- rename variable
--   vim.keymap.set('n', '<leader>tw', ToggleDiagnostics, {buffer = 0}) -- toggle warning
--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = 0})
--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = 0})
-- end

-- not useful in general, not recommended
package.path = package.path .. ";/home/ashoka/.config/nvim/colorscheme.lua"
vim.cmd(require('colorscheme'))

function AttachString()
  local start = vim.fn.search('---', 'bW') + 1
  local end1 = vim.fn.search('---', 'W')
  if end1==0 then end1 = vim.fn.line('$') else end1 = end1-1 end
  vim.print(start .. ' ' .. end1)
  vim.cmd(start .. ',' .. end1 .. 's/$/' .. vim.fn.getreg('"') )
  vim.cmd('norm ' .. start .. 'Gd' .. end1 .. 'G')
end
vim.keymap.set('n', '<leader>as', AttachString, {noremap = true})
