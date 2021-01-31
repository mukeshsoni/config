local vim = vim
local api = vim.api


-- this initializes jhe packer plugin manager
api.nvim_command [[packadd packer.nvim]]

-- plugins
require('packer').startup(function()
	use {'wbthomason/packer.nvim', opt = true}
	-- navigating the file tree
	use 'preservim/nerdtree'
	-- for easily changing a line to comment
	use 'preservim/nerdcommenter'
	-- Colorscheme
	use 'itchyny/lightline.vim'
	use 'morhetz/gruvbox'
	use 'pangloss/vim-javascript'
	use 'mxw/vim-jsx'
	use 'jxnblk/vim-mdx-js'

	use 'jiangmiao/auto-pairs'
	use 'alvan/vim-closetag'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-surround'
	use 'neovim/nvim-lspconfig'
    use 'tpope/vim-fugitive'
	use 'hrsh7th/nvim-compe'
	use 'glepnir/lspsaga.nvim'
	use '/usr/local/opt/fzf'
	use 'junegunn/fzf.vim'
end)

vim.cmd [[set mouse=a]]
-- otherwise vim replaces the content of current buffer with the new file you
-- open. Or maybe deletes the current buffer and creates a new one. Either way,
-- it makes swithcing between open files quickly a pain in the ass.
-- If i set the hidden option, i lose the line numbers for some reason. Not 
-- for every file though. If i open this file, everything's fine. If i open
-- a directory and then open a js file. Boom!
vim.o.hidden = true
-- vim.cmd [[set hidden]]
-- -- create a vertical split below the current pane
vim.o.splitbelow = true
-- -- create a horizontal split to the right of the current pane
vim.o.splitright = true
vim.cmd [[set termguicolors]]

-- took me a long time to figure out how to change the leader key in lua
vim.g.mapleader = " "

-- Appearance
------------------------------------------------------------------------
-- relative line numbering, yo
-- number and relativenumber are window options. So doing vim.o.relativenumber = true
-- will not work
vim.wo.relativenumber = true
-- but we don't want pure relative line numbering. The line where the cursor is 
-- should show absolute line number
vim.wo.number = true
-- show a bar on column 120. Going beyond 120 chars per line gets hard to read.
-- I have a linting rule in most of my projects to keep line limit to 120 chars.
-- I had no idea that colorcolumn is a window option
-- Tip: One way to find whether an option is global or window or buffer
-- try vim.o.<option_name> = 'blah' and run ex command :luafile %
-- It will tell you what the real type of the option_name should be
vim.wo.colorcolumn = '120'

-- maintain undo history between sessions
vim.cmd(
	[[
		set undofile
	]]
)

-- colorscheme
api.nvim_command [[colorscheme gruvbox]]

-- Editing
-----------------------
-- doing vim.o.tabstop does not work. tabstop only works as a buffer option when trying to set with meta accessors
-- ideally, i guess they should be set per buffer depending on the type of file
-- vim.cmd [[set tabstop=4]]
-- vim.cmd [[set shiftwidth=4]]
-- vim.cmd [[set smarttab]]
-- vim.cmd [[autocmd FileType javascript setlocal ts=4 sts=4 sw=4]]
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
-- don't want case sensitive searches
vim.o.ignorecase = true
-- but still want search to be smart. If i type a upper case thing, do a case
-- sensitive search
vim.o.smartcase = true
-- In insert mode, on pressing tab, insert 2 spaces
-- vim.o.expandtab = true
-- vim.o.smarttab = true
-- Use system clipboard
-- I don't know why this is not the default option. I am missing something.
-- TODO: Figure out a better way to copy to system clipboard and paste from
-- system clipboard.
-- TODO: I think when we do `set clipboard+=unnamedplus`, it's not concatenating
-- the string 'unnamedplus' to the option clipboard. It's add another value to
-- some object probably
vim.o.clipboard = 'unnamedplus'

-- trigger prettier formatting on save
-- vim.cmd [[augroup fmt]]
-- vim.cmd [[autocmd!]]
-- vim.cmd [[augroup END]]

-- Key mappings
api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true })
-- remap j and k to move across display lines and not real lines
api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })
api.nvim_set_keymap('n', 'gk', 'k', { noremap = true })
api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
api.nvim_set_keymap('n', 'gj', 'j', { noremap = true })

-- i always misspell the as teh
-- iabbrev works in insert mode after i press any non-keyword after entering
-- the letter
vim.cmd [[iabbrev teh the]]


-- Let's make & to trigger :&&, which preserves substitution flags when 
-- rerunning a substitute, which is what we want most of the times
api.nvim_set_keymap('n', '&', ':&&<CR>', { noremap = true })
api.nvim_set_keymap('x', '&', ':&&<CR>', { noremap = true })

-- expand with current file path. Picked from practical vim.
-- Try out :e %%
api.nvim_set_keymap('c', '%%', "getcmdtype() == ':' ? expand('%:h').'/' : '%%'", { noremap = true, expr = true })

-- I like my cmd+s for saving files. In insert mode!
-- The terminal (or iterm) does not have support for anything related to
-- Command key
-- Hence need to hack stuff - 
-- https://stackoverflow.com/questions/33060569/mapping-command-s-to-w-in-vim
api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>i', { noremap = true })
api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true })

-- To remove highlight from searched word
-- C-l redraws the screen. We change it so that it also removes all highlights
-- C-u so that we remove any ranges which might be there due to visual mode
api.nvim_set_keymap('n', '<C-l>', ':<C-u>noh<CR><C-l>', { noremap = true, silent = true })

-- When in terminal mode, escape will leave terminal mode and then it becomes
-- like any other vim buffer and can be switched or deleted or whatever
api.nvim_set_keymap('t', '<esc>', ':<C-\\><C-n>', { noremap = true })

-- open vimrc
api.nvim_set_keymap('n', '<leader>ev', ':split $MYVIMRC<CR>', { noremap = true })
-- Source my vimrc file
-- TODO: i don't know how to source a lua file
-- source /path/to/lua does not work
api.nvim_set_keymap('n', '<leader>sv', ':source $MYVIMRC<CR>', { noremap = true })

-- open my vimrc file in a split pane
-- command! Vimrc :sp $MYVIMRC
-- TODO: Don't know how to define a command from lua

------ NerdTree configuration ------

-- toggle NERDTree show/hide using <C-n> and <leader>n
api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', { noremap = true })
-- reveal open buffer in NERDTree
api.nvim_set_keymap('n', '<leader>r', ':NERDTreeFind<CR>', { noremap = true })

------ file search and find in project command mappings ------
-- map Ctrl-q (terminals don't recognize ctrl-tab) (recent files) to show all
-- files in the buffer
api.nvim_set_keymap('n', '<leader>f', ':Buffers<CR>', { noremap = true })
-- Ctrl-I maps to tab
-- But it destroys the C-i mapping in vim. Which is used to kind of go in and
-- used in conjunction with C-o.
api.nvim_set_keymap('n', '<C-b>', ':Buffers<CR>', { noremap = true })
-- map ctrlp to open file search
api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', { noremap = true })
api.nvim_set_keymap('n', '<C-t>', ':GFiles<CR>', { noremap = true })
api.nvim_set_keymap('n', '<leader>fg', ':Rg!', { noremap = true })
api.nvim_set_keymap('n', '<leader>a', ":exe 'Rg!' expand('<cword')<CR>", { noremap = true })

-- NERDCommenter
-- shortcuts to toggle comment
api.nvim_set_keymap('n', ',c', ':call NERDComment(0, "toggle")<CR>', { noremap = true })
api.nvim_set_keymap('v', ',c', ':call NERDComment(0, "toggle")<CR>', { noremap = true })

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  allow_prefix_unmatch = false;

  source = {
    path = true;
    buffer = true;
    vsnip = true;
    lamp = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    snippets_nvim = true;
  };
}
-- setup lsp client
local on_attach = function(client)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
		hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
		hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
		hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
		augroup lsp_document_highlight
		autocmd!
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]], false)
	end
end

vim.o.completeopt = "menu,menuone,noselect"
require'lspconfig'.flow.setup{
        -- because we want to run the locally installed flow binary version
        -- cmd = { "yarn", "flow", "lsp" },
		on_attach = on_attach
}
require'lspconfig'.tsserver.setup { on_attach = on_attach }
require'lspconfig'.pyls.setup{ on_attach = on_attach }

------ Commands ------
-- There is not api to set a command directly
-- But there's an api to execute random vimscript - vim.nvim_exec
-- But vim.cmd or vim.api.nvim_command serve the same purpose
-- The second argument says if we want the return value from the executed 
-- vimscript
vim.cmd('command! Vimrc :sp $MYVIMRC')


------ Nerd commenter ------
--
-- add 1 space after comment delimiter
api.nvim_set_var('NERDSpaceDelims', 1)

-- NERDTree
-- If we toggle the nerdtree buffer, and it's the only buffer open, it shouldn't
-- close vim itself. It should just replace the current buffer with last open
-- buffer
-- I just couldn't get nvim_exec to run the below code
-- And my guess is that nvim_command or vim.cmd only runs the first line
-- And just ignores the rest
-- Can test by putting echo as the second line
-- Yup, when i put echo in the second line, nothing echoes
-- But when it's in the first line, all is good
-- One way to define a vimscript function can be to create a multiline string
-- and then split it by newline and execute each line using vim.cmd
-- local nerdtree_safe = [[
-- autocmd FileType nerdtree let t:nerdtree_winnr = bufwinnr('%')
-- autocmd BufWinEnter * call PreventBuffersInNERDTree()

-- function! PreventBuffersInNERDTree()
  -- if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr && &buftype == '' && !exists('g:launching_fzf')
          -- let bufnum = bufnr('%')
          -- close
          -- exe 'b ' . bufnum
  -- endif
  -- if exists('g:launching_fzf') | unlet g:launching_fzf | endif
-- endfunction
-- ]]
-- 
-- for cmd in nerdtree_safe:gmatch("[^\r\n]+") do
  -- -- print(cmd)
  -- vim.cmd(cmd)
-- end
-- The above didn't work. It waits for input after the first line of function
-- declaration
-- Solution 2: Define the function in lua and then call `lua LuaFn` for the 
-- autocmd
-- local nerdtree_safe = [[
-- autocmd FileType nerdtree let t:nerdtree_winnr = bufwinnr('%')
-- autocmd BufWinEnter * call PreventBuffersInNERDTree()

-- function! PreventBuffersInNERDTree()
  -- if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree' && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr && &buftype == '' && !exists('g:launching_fzf')
          -- let bufnum = bufnr('%')
          -- close
          -- exe 'b ' . bufnum
  -- endif
  -- if exists('g:launching_fzf') | unlet g:launching_fzf | endif
-- endfunction
-- ]]

-- api.nvim_command(nerdtree_safe)

-- highlight yanked stuff. Done with native neovim api. No plugin.
-- augroup command didn't work with vim.cmd. 
-- TODO: Find the difference between vim.api.nvim_command (alias vim.cmd)
-- and vim.api.nvim_exec
api.nvim_exec (
[[
	augroup highlight_yank
			autocmd!
			au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
	augroup END
]], false
)

vim.cmd [[ set grepprg=rg\ --vimgrep ]]

-- the live_grep default implementation is slow. Get's stuck between typing.
-- Enabling the fzf_writer extension makes it better
-- require('telescope').setup {
    -- extensions = {
        -- fzf_writer = {
            -- minimum_grep_characters = 2,
            -- minimum_files_characters = 2,

            -- -- Disabled by default.
            -- -- Will probably slow down some aspects of the sorter, but can make color highlights.
            -- -- I will work on this more later.
            -- use_highlighter = false,
        -- },
		-- fzy_native = {
			-- override_generic_sorter = true,
			-- override_file_sorter = true
		-- }
    -- }
-- }
-- require('telescope').load_extension('fzy_native')

-- Gstatus or git status in vim-fugitive
api.nvim_set_keymap('n', '<leader>gs', ':G<CR>', { noremap = true })

-- mapping to format file using prettier installed inside projectplace frontend/harmony folder
vim.cmd [[nnoremap <leader>p :silent %!/Volumes/code-case-sensitive/code/main_service/frontend/harmony/node_modules/.bin/prettier --stdin-filepath %<CR>]]

local saga = require 'lspsaga'
saga.init_lsp_saga()

