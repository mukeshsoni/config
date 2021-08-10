local vim = vim
local api = vim.api

-- needed by nvim-compe
vim.o.completeopt = "menuone,noselect"

-- i sometimes use the mouse to scroll through a buffer
vim.cmd [[set mouse=a]]
-- otherwise vim replaces the content of current buffer with the new file you
-- open. Or maybe deletes the current buffer and creates a new one. Either way,
-- it makes swithcing between open files quickly a pain in the ass.
-- If i set the hidden option, i lose the line numbers for some reason. Not
-- for every file though. If i open this file, everything's fine. If i open
-- a directory and then open a js file. Boom!
vim.o.hidden = true
vim.cmd [[set report=2]]
-- took me a long time to figure out how to change the leader key in lua
vim.g.mapleader = " "

require("packer").startup(
  function()
    -- Packer can manage itself
    -- navigating the file tree
    use "preservim/nerdtree"
    -- for easily changing a line to comment
    use "preservim/nerdcommenter"
    use "wbthomason/packer.nvim"

    -- navigating the file tree

    use "/usr/local/opt/fzf"
    use "junegunn/fzf.vim"
    use "neovim/nvim-lspconfig"
    -- Colorscheme
    use "itchyny/lightline.vim"
    use "morhetz/gruvbox"
    use "pangloss/vim-javascript"
    use "MaxMEllon/vim-jsx-pretty"

    use "jiangmiao/auto-pairs"
    use "alvan/vim-closetag"
    use "tpope/vim-unimpaired"
    use "tpope/vim-surround"
    -- auto format files. E.g. format js files using typescript.
    use "mhartington/formatter.nvim"
    use "tpope/vim-fugitive"
    use "airblade/vim-gitgutter"
    use "hrsh7th/nvim-compe"
    use "mattn/efm-langserver"
    -- TODO - find some way to verify that vsnip works
    -- TODO - Also verify if nvim-compe works with vsnip. I don't know how they work together.
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/vim-vsnip-integ"
    -- Never remember what register contains what? vim-peekaboo to the rescue
    use "junegunn/vim-peekaboo"
    -- focus mode. Might not ever use it.
    use "junegunn/goyo.vim"
    use "junegunn/limelight.vim"
    use "tpope/vim-obsession"
    use "ryanoasis/vim-devicons"
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate"
    }
    use "haya14busa/is.vim"
    use "nelstrom/vim-visual-star-search"
  end
)

local lspconfig = require "lspconfig"

-- colorscheme
-- vim.cmd [[set termguicolors]]
api.nvim_command [[colorscheme gruvbox]]

-- so that vim-closetag works for jsx inside javascript files
vim.cmd [[
let g:closetag_filetypes = 'html,xhtml,jsx,javascript,typescript.tsx'
]]

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
vim.wo.colorcolumn = "120"

-- maintain undo history between sessions
vim.cmd([[
set undofile
]])

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
-- sensitive blah
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
vim.o.clipboard = "unnamedplus"

-- Key mappings
api.nvim_set_keymap("i", "jk", "<esc>", {noremap = true})
-- remap j and k to move across display lines and not real lines
api.nvim_set_keymap("n", "k", "gk", {noremap = true})
api.nvim_set_keymap("n", "gk", "k", {noremap = true})
api.nvim_set_keymap("n", "j", "gj", {noremap = true})
api.nvim_set_keymap("n", "gj", "j", {noremap = true})

-- i always misspell the as teh
-- iabbrev works in insert mode after i press any non-keyword after entering
-- the letter
vim.cmd [[iabbrev teh the]]

-- I like my cmd+s for saving files. In insert mode!
-- The terminal (or iterm) does not have support for anything related to
-- Command key
-- Hence need to hack stuff -
-- https://stackoverflow.com/questions/33060569/mapping-command-s-to-w-in-vim
api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>i", {noremap = true})
api.nvim_set_keymap("n", "<C-s>", ":w<CR>", {noremap = true})

-- To remove highlight from searched word
-- C-l redraws the screen. We change it so that it also removes all highlights
-- C-u so that we remove any ranges which might be there due to visual mode
api.nvim_set_keymap("n", "<C-l>", ":<C-u>noh<CR><C-l>", {noremap = true, silent = true})

-- When in terminal mode, escape will leave terminal mode and then it becomes
-- like any other vim buffer and can be switched or deleted or whatever
api.nvim_set_keymap("t", "<esc>", ":<C-\\><C-n>", {noremap = true})

-- There is not api to set a command directly
-- But there's an api to execute random vimscript - vim.nvim_exec
-- But vim.cmd or vim.api.nvim_command serve the same purpose
-- The second argument says if we want the return value from the executed
-- vimscript
vim.cmd("command! Vimrc :sp $MYVIMRC")

-- open vimrc
api.nvim_set_keymap("n", "<leader>ev", ":split $MYVIMRC<CR>", {noremap = true})
-- Source my vimrc file
-- TODO: i don't know how to source a lua file
-- source /path/to/lua does not work
api.nvim_set_keymap("n", "<leader>sv", ":luafile $MYVIMRC<CR>", {noremap = true})

vim.cmd [[ set grepprg=rg\ --vimgrep ]]

-- highlight yanked stuff. Done with native neovim api. No plugin.
-- augroup command didn't work with vim.cmd.
-- TODO: Find the difference between vim.api.nvim_command (alias vim.cmd)
-- and vim.api.nvim_exec
api.nvim_exec(
  [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END
]],
  false
)

------ NerdTree configuration ------

-- toggle NERDTree show/hide using <C-n> and <leader>n
api.nvim_set_keymap("n", "<leader>n", ":NERDTreeToggle<CR>", {noremap = true})
-- reveal open buffer in NERDTree
api.nvim_set_keymap("n", "<leader>r", ":NERDTreeFind<CR>", {noremap = true})

------ file search and find in project command mappings ------
-- map Ctrl-q (terminals don't recognize ctrl-tab) (recent files) to show all
-- files in the buffer
api.nvim_set_keymap("n", "<leader>f", ":Buffers<CR>", {noremap = true})
-- Ctrl-I maps to tab
-- But it destroys the C-i mapping in vim. Which is used to kind of go in and
-- used in conjunction with C-o.
api.nvim_set_keymap("n", "<C-b>", ":Buffers<CR>", {noremap = true})
-- map ctrlp to open file search
api.nvim_set_keymap("n", "<C-p>", ":Files<CR>", {noremap = true})
-- go to next buffer
api.nvim_set_keymap("n", "gn", ":bn<cr>", {noremap = true})
-- go to previous buffer
api.nvim_set_keymap("n", "gp", ":bp<cr>", {noremap = true})
-- toggle between 2 buffers
api.nvim_set_keymap("n", "gb", ":b#<cr>", {noremap = true})
api.nvim_set_keymap("n", "<C-t>", ":GFiles<CR>", {noremap = true})
api.nvim_set_keymap("n", "<leader>l", ":Lines<CR>", {noremap = true})
api.nvim_set_keymap("n", "<leader>fg", ":Rg!", {noremap = true})
api.nvim_set_keymap("n", "<leader>a", ":exe 'Rg!' expand('<cword>')<CR>", {noremap = true})

-- NERDCommenter
-- add 1 space after comment delimiter
api.nvim_set_var("NERDSpaceDelims", 1)
-- shortcuts to toggle commen
api.nvim_set_keymap("n", ",c", ':call NERDComment(0, "toggle")<CR>', {noremap = true})
api.nvim_set_keymap("v", ",c", ':call NERDComment(0, "toggle")<CR>', {noremap = true})

-- auto-pairs
-- disable flymode in auto-pairs plugin. Too much magic. Comes in the way more often than note
vim.cmd [[
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'
]]

-- autocompletion
-- nvim-compe
-- so that tab select the next option in autocomplete menu
-- vim.api.nvim_set_keymap(
-- "i",
-- "<Tab>",
-- 'pumvisible() ? "<C-n>" : v:lua.check_backspace() ? "<Tab>" : "<C-r>=compe#complete()<CR>"',
-- {noremap = true, expr = true}
-- )
-- The below is copied directly from github readme of nvim-compe - https://github.com/hrsh7th/nvim-compe
-- I guess those are the default values. But if i don't put there in my init.lua file, the autocompletion doesn't
-- trigger without me pressing Ctrl-n
require "compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    ultisnips = true
  }
}

-- vim-fugitive
-- Otherwise the diffs or something else looks total funky. I forgot what.
vim.cmd [[let g:fugitive_pty = 0]]
api.nvim_set_keymap("n", "<leader>gs", ":Git<CR>", {noremap = true})

-- formatting
-- formatter.nvim
-- This plugin needs a lot of setup code. Have to add one config object for each type of file. But it's the only one
-- i could get working properly through init.lua.
require("formatter").setup(
  {
    logging = false,
    filetype = {
      typescriptreact = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      css = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      typescript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      svelte = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      json = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      javascriptreact = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout"},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      }
    }
  }
)

-- format on save
vim.cmd [[
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.rs,*.lua FormatWrite
augroup END
]]

local function buf_set_keymap(...)
  vim.api.nvim_buf_set_keymap(bufnr, ...)
end
local function buf_set_option(...)
  vim.api.nvim_buf_set_option(bufnr, ...)
end
local key_binding_options = {noremap = true, silent = true}

-- lsp configurations
-- The most interesting and the most hairy. Also the most unreliable. Work sometimes and then stop working suddenly.
local on_attach = function(client, bufnr)
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", key_binding_options)
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", key_binding_options)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", key_binding_options)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", key_binding_options)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", key_binding_options)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", key_binding_options)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", key_binding_options)
  buf_set_keymap(
    "n",
    "<space>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    key_binding_options
  )
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", key_binding_options)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", key_binding_options)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", key_binding_options)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", key_binding_options)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", key_binding_options)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", key_binding_options)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", key_binding_options)
  buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", key_binding_options)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", key_binding_options)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", key_binding_options)
  end

  -- Set autocommands conditional on server_capabilities
  -- if client.resolved_capabilities.document_highlight then
  -- vim.api.nvim_exec(
  -- [[
  -- hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
  -- hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
  -- hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  -- augroup lsp_document_highlight
  -- autocmd!
  -- autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  -- autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  -- augroup END
  -- ]],
  -- false
  -- )
  -- end
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- we update the lsp capabilities so that the lsps support snippets
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits"
  }
}

local current_dir = vim.fn.getcwd()
-- if string.find(current_dir, "main_service") or string.find(current_dir, "harmony") then
-- lspconfig.tsserver.setup {on_attach = on_attach}
-- print("we are in projectplace context. donot switch on lsp tsserver")
-- lspconfig.flow.setup {capabilities = capabilities, on_attach = on_attach}
-- else
lspconfig.tsserver.setup {on_attach = on_attach}
-- end

-- lspconfig.tsserver.setup { on_attach = on_attach }
lspconfig.pyls.setup {capabilities = capabilities, on_attach = on_attach}
lspconfig.rust_analyzer.setup {on_attach = on_attach}
local eslint_d = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true
  -- formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  -- formatStdin = true
}
-- prettier or eslint --fix is not working with neovim lsp
-- calling :lua vim.lsp.buf.formatting() should have worked, but never did
-- I don't know how to debug that
local prettier = {
  formatCommand = "prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true
}

-- not sure if this one works well or not. If i want to debug by elimination, this one should go first.
-- to use efm-langserver and eslint_d, those need to be installed globally
-- brew install efm-langserver
-- npm install -g eslint_d
lspconfig.efm.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = function()
    return vim.fn.getcwd()
  end,
  init_options = {
    documentFormatting = true,
    codeAction = true
  },
  settings = {
    lintDebounce = 500,
    languages = {
      javascript = {eslint_d},
      javascriptreact = {eslint_d},
      ["javascript.jsx"] = {eslint_d},
      typescript = {eslint_d},
      typescriptreact = {eslint_d},
      ["typescript.tsx"] = {eslint_d}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  }
}

-- treat svelte files as html files to get syntax highlighting
vim.cmd [[
au! BufNewFile,BufRead *.svelte set ft=html
]]

-- Focus mode - goyo + limelight
-- goyo is a korean word which means silence
-- key binding
buf_set_keymap("n", "<leader>gy", ":Goyo<CR>", key_binding_options)

-- Enable limelight when entering goyo mode
-- Disable limelight when leaving goyo mode
vim.cmd [[
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
]]

-- treesitter
require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false
  }
}

-- Allow passing optional flags to Rg command
-- Otherwise Rg doesn't take any other argument than the search string
-- because of shellscape or something
vim.cmd(
  [[
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)
]]
)

-- TODO
-- 1. We need some snippet action going on. Too much manual typing going on right now. As if i love typing or something.
-- https://github.com/hrsh7th/vim-vsnip
-- 2. Have a good font. Something with ligatures. Not necessary. Just for kicks.
--
--
--
