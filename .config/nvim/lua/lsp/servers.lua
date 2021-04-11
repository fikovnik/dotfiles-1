-- Stop lsp diagnostics from showing virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        signs = true
    }
)

local nvim_lsp = require "lspconfig"

-- npm i -g bash-language-server
nvim_lsp.bashls.setup {autostart = LSP.bash}

-- npm i -g typescript typescript-language-server
nvim_lsp.tsserver.setup {autostart = LSP.tsserver}

-- npm i -g vscode-css-languageserver-bin
nvim_lsp.cssls.setup {autostart = LSP.css}

-- npm i -g pyright
nvim_lsp.pyright.setup {autostart = LSP.python}

-- npm i -g vscode-json-languageserver
nvim_lsp.jsonls.setup {autostart = LSP.json}

-- pacman -S clang
nvim_lsp.clangd.setup {autostart = LSP.clangd}

-- npm i -g emmet-ls
local configs = require "lspconfig/configs"
configs.emmet_ls = {
    default_config = {
        cmd = {"emmet-ls", "--stdio"},
        filetypes = {"html", "css"},
        root_dir = function()
            return vim.loop.cwd()
        end,
        settings = {}
    }
}
nvim_lsp.emmet_ls.setup {autostart = LSP.emmet}

-- lua  https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
-- install instructions:
-- git clone https://github.com/sumneko/lua-language-server $HOME/.local/share/nvim/lua/sumneko_lua
-- cd ~/.local/share/nvim/lua/sumneko_lua
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ninja -f ninja/linux.ninja
-- cd ../..
-- ./3rd/luamake/luamake rebuild

local luapath = "/home/" .. os.getenv("USER") .. "/.local/share/nvim/lua/sumneko_lua"
local luabin = luapath .. "/bin/Linux/lua-language-server"

nvim_lsp.sumneko_lua.setup {
    cmd = {luabin, "-E", luapath .. "/main.lua"},
    autostart = LSP.lua,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";")
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim", "use", "run", "Theming", "LSP", "Completion", "Formatting", "Treesitter"}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                },
                maxPreload = 10000
            },
            telemetry = {
                enable = false
            }
        }
    }
}

-- no need for hmtl server having emmet-ls and snippets working
-- npm i -g vscode-html-languageserver-bin
-- nvim_lsp.html.setup {}
