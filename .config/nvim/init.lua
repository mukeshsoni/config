local vim = vim
local api = vim.api

-- otherwise vim replaces the content of current buffer with the new file you
-- open. Or maybe deletes the current buffer and creates a new one. Either way,
-- it makes swithcing between open files quickly a pain in the ass.
-- If i set the hidden option, i lose the line numbers for some reason. Not 
-- for every file though. If i open this file, everything's fine. If i open
-- a directory and then open a js file. Boom!
-- vim.o.hidden = true
vim.cmd [[set hidden]]
-- vim.cmd [[let mapleader=" "]]
-- -- create a vertical split below the current pane
vim.o.splitbelow = true
-- -- create a horizontal split to the right of the current pane
vim.o.splitright = true

-- TODO: Not able to change leader key to space. If i change mapleader variable,
-- the default leader (\) also doesn't work
-- api.nvim_set_var('mapleader', '<Space>')

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
        use 'joshdick/onedark.vim'
        use 'itchyny/lightline.vim'
	-- need popup, plenary and telescope plugins for telescope to work
	use 'nvim-lua/popup.nvim'
	-- need popup, plenary and telescope plugins for telescope to work
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'jiangmiao/auto-pairs'
	use 'tpope/vim-unimpaired'
	use 'tpope/vim-surround'
	use 'neovim/nvim-lspconfig'
        use 'tpope/vim-fugitive'
        use 'nvim-lua/completion-nvim'
end)

-- Appearance
------------------------------------------------------------------------
-- relative line numbering, yo
-- number and relativenumber are window options. So doing vim.o.relativenumber = true
-- will not work
vim.wo.relativenumber = true
-- but we don't want pure relative line numbering. The line where the cursor is 
-- should show absolute line number
vim.wo.number = true
-- show a bar on column 80. Going beyond 80 chars per line gets hard to read.
-- I have a linting rule in most of my projects to keep line limit to 80 chars.
-- I had no idea that colorcolumn is a window option
-- Tip: One way to find whether an option is global or window or buffer
-- try vim.o.<option_name> = 'blah' and run ex command :luafile %
-- It will tell you what the real type of the option_name should be
vim.wo.colorcolumn = '80'

-- maintain undo history between sessions
vim.cmd(
	[[
		set undofile
	]]
)

-- colorscheme
api.nvim_command [[colorscheme onedark]]

-- Editing
-----------------------
-- doing vim.o.tabstop does not work. tabstop only works as a buffer option when trying to set with meta accessors
-- ideally, i guess they should be set per buffer depending on the type of file
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
-- don't want case sensitive searches
vim.o.ignorecase = true
-- but still want search to be smart. If i type a upper case thing, do a case
-- sensitive search
vim.o.smartcase = true
-- In insert mode, on pressing tab, insert 2 spaces
vim.o.expandtab = true
-- Use system clipboard
-- I don't know why this is not the default option. I am missing something.
-- TODO: Figure out a better way to copy to system clipboard and paste from
-- system clipboard.
-- TODO: I think when we do `set clipboard+=unnamedplus`, it's not concatenating
-- the string 'unnamedplus' to the option clipboard. It's add another value to
-- some object probably
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'


-- Key mappings
api.nvim_set_keymap('n', '<leader>h', ':echo "hello"<cr>', { noremap = true })
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
-- TODO: Anything with <leader> is not working. mapleader is not working.
api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', { noremap = true })
-- reveal open buffer in NERDTree
api.nvim_set_keymap('n', '<leader>r', ':NERDTreeFind<CR>', { noremap = true })

------ Telescope command mappings ------
-- map Ctrl-q (terminals don't recognize ctrl-tab) (recent files) to show all
-- files in the buffer
api.nvim_set_keymap('n', '<leader>f', ':Telescope buffers<CR>', { noremap = true })
-- Ctrl-I maps to tab
-- But it destroys the C-i mapping in vim. Which is used to kind of go in and
-- used in conjunction with C-o.
-- api.nvim_set_keymap('n', '<C-I>', ':Telescope buffers<CR>', { noremap = true })
-- map ctrlp to open file search
api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', { noremap = true })
-- Doesn't show anything in .gitignore of the project
-- Have used the lua way of invoking the function instead of the custom
-- sugar Telescope commands. 
-- Here's the list of all builtins - https://github.com/nvim-telescope/telescope.nvim#built-in-pickers
api.nvim_set_keymap('n', '<C-t>', ':lua require("telescope.builtin").git_files()<CR>', { noremap = true })
api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true })

-- NERDCommenter
-- shortcuts to toggle comment
api.nvim_set_keymap('n', ',c', ':call NERDComment(0, "toggle")<CR>', { noremap = true })
api.nvim_set_keymap('v', ',c', ':call NERDComment(0, "toggle")<CR>', { noremap = true })

------ lsp keymappings -------
-- TODO: Some of the calls are not supported by the flow language server
-- like declaration or signature_help or implementation. definition works, 
-- hover works, type_definition works, references works.
api.nvim_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })

-- setup lsp client

api.nvim_exec(
[[
let g:completion_enable_auto_popup = 0
]], false
)
require'lspconfig'.flow.setup{
        -- because we want to run the locally installed flow binary version
        -- cmd = { "yarn", "flow", "lsp" },
        on_attach = require'completion'.on_attach
}

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
-- api.nvim_exec (
-- [[
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
-- , false)

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

-- the live_grep default implementation is slow. Get's stuck between typing.
-- Enabling the fzf_writer extension makes it better
require('telescope').setup {
    extensions = {
        fzf_writer = {
            minimum_grep_characters = 2,
            minimum_files_characters = 2,

            -- Disabled by default.
            -- Will probably slow down some aspects of the sorter, but can make color highlights.
            -- I will work on this more later.
            use_highlighter = false,
        }
    }
}
