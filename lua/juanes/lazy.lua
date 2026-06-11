local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats   = 'transparent',
        },
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },

  -- TreeSitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(event)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))
          if ok and stats and stats.size > max_filesize then
            vim.treesitter.stop(event.buf)
          end
        end,
      })
    end,
  },

  -- Select/move by function, class, parameter
  -- af/if=function  ac/ic=class  aa/ia=parameter
  -- ]f/[f=next/prev function  ]c/[c=next/prev class
  -- <leader>sp / <leader>sP = swap parameter with next/prev
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start     = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_next_end       = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          goto_previous_end   = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        },
        swap = {
          enable = true,
          swap_next     = { ['<leader>sp'] = '@parameter.inner' },
          swap_previous = { ['<leader>sP'] = '@parameter.inner' },
        },
      })
    end,
  },

  -- Shows current function/class context pinned at top of buffer
  -- [x = jump up into the context
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup({ enable = true, max_lines = 3 })
      vim.keymap.set('n', '[x', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true })
    end,
  },

  -- Undo Tree
  { 'mbbill/undotree' },

  -- LSP base
  {
    'williamboman/mason.nvim',
    build = function()
      pcall(vim.api.nvim_command, 'MasonUpdate')
    end,
  },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-nvim-lua' },

  -- Rust: replaces generic rust-analyzer setup, adds runnables, debuggables, macro expand
  -- K=hover+actions  <leader>ca=code action  <leader>rr=runnables
  -- <leader>re=expand macro  <leader>rd=debuggables
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    init = function()
      vim.g.rustaceanvim = function()
        return {
          server = {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            on_attach = function(_, bufnr)
              local opts = { buffer = bufnr }
              vim.keymap.set('n', 'K', function()
                vim.cmd.RustLsp({ 'hover', 'actions' })
              end, opts)
              vim.keymap.set('n', '<leader>ca', function()
                vim.cmd.RustLsp('codeAction')
              end, opts)
              vim.keymap.set('n', '<leader>rr', function()
                vim.cmd.RustLsp('runnables')
              end, opts)
              vim.keymap.set('n', '<leader>re', function()
                vim.cmd.RustLsp('expandMacro')
              end, opts)
              vim.keymap.set('n', '<leader>rd', function()
                vim.cmd.RustLsp('debuggables')
              end, opts)
            end,
          },
        }
      end
    end,
  },

  -- TypeScript/JS: native tsserver client, faster than lspconfig's tsserver
  -- Uses same LSP keymaps (gd, K, <leader>vrn, etc.)
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    config = function()
      require('typescript-tools').setup({
        settings = {
          separate_diagnostic_server = true,
          jsx_close_tag = {
            enable = true,
            filetypes = { 'javascriptreact', 'typescriptreact' },
          },
        },
      })
    end,
  },

  -- Formatting: <leader>f = format buffer/selection
  -- Needs formatters installed: ruff, gofmt, goimports, prettier, rustfmt, stylua
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          python          = { 'ruff_format', 'ruff_organize_imports' },
          go              = { 'gofmt', 'goimports' },
          rust            = { 'rustfmt' },
          javascript      = { 'prettier' },
          typescript      = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          json            = { 'prettier' },
          lua             = { 'stylua' },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        require('conform').format({ async = true, lsp_fallback = true })
      end)
    end,
  },

  -- Debugger: F5=run  F10=step over  F11=step into  F12=step out
  -- <leader>b=breakpoint  <leader>B=conditional breakpoint  <leader>du=toggle UI
  -- Python needs: pip install debugpy
  -- Go uses delve (installed automatically by nvim-dap-go)
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap    = require('dap')
      local dapui  = require('dapui')

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config']     = function() dapui.close() end

      require('dap-python').setup('python')
      require('dap-go').setup()

      vim.keymap.set('n', '<F5>',       dap.continue)
      vim.keymap.set('n', '<F10>',      dap.step_over)
      vim.keymap.set('n', '<F11>',      dap.step_into)
      vim.keymap.set('n', '<F12>',      dap.step_out)
      vim.keymap.set('n', '<leader>b',  dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>B',  function()
        dap.set_breakpoint(vim.fn.input('Condition: '))
      end)
      vim.keymap.set('n', '<leader>du', dapui.toggle)
    end,
  },

  -- Java LSP
  { 'mfussenegger/nvim-jdtls' },

  { 'ray-x/lsp_signature.nvim' },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- File tree
  {
    'ms-jpq/chadtree',
    branch = 'chad',
    build = 'python3 -m chadtree deps',
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { 'nvim-tree/nvim-web-devicons' },

  { 'Yggdroot/indentLine' },

  { 'norcalli/nvim-colorizer.lua' },

  { 'christoomey/vim-tmux-navigator' },

  { 'easymotion/vim-easymotion' },

  {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end,
  },

  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- Git signs: replaces vim-signify, adds staging/blaming/diff per hunk
  -- ]h/[h=next/prev hunk  <leader>gs=stage  <leader>gr=reset  <leader>gp=preview
  -- <leader>gb=blame line  <leader>gl=toggle inline blame  <leader>gd=diff
  -- <leader>gS=stage buffer  <leader>gu=undo stage
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        on_attach = function(bufnr)
          local gs   = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set('n', ']h', gs.next_hunk, opts)
          vim.keymap.set('n', '[h', gs.prev_hunk, opts)
          vim.keymap.set('n', '<leader>gs', gs.stage_hunk, opts)
          vim.keymap.set('n', '<leader>gr', gs.reset_hunk, opts)
          vim.keymap.set('v', '<leader>gs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, opts)
          vim.keymap.set('v', '<leader>gr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, opts)
          vim.keymap.set('n', '<leader>gS', gs.stage_buffer, opts)
          vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, opts)
          vim.keymap.set('n', '<leader>gp', gs.preview_hunk, opts)
          vim.keymap.set('n', '<leader>gb', function()
            gs.blame_line({ full = true })
          end, opts)
          vim.keymap.set('n', '<leader>gl', gs.toggle_current_line_blame, opts)
          vim.keymap.set('n', '<leader>gd', gs.diffthis, opts)
        end,
      })
    end,
  },

  { 'psliwka/vim-smoothie' },

  {
    'mattn/emmet-vim',
    init = function()
      vim.g.user_emmet_leader_key = '<leader>z'
      vim.g.user_emmet_install_global = 1
    end,
  },

  {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
  },

  { 'tpope/vim-surround' },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({})
    end,
  },

  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    config = function()
      require('distant'):setup()
    end,
  },

  -- Quick navigation between pinned files
  -- <leader>ha=add file  <leader>hh=open menu  <leader>1-4=jump to slot
  -- <leader>hn / <leader>hp = next/prev in list
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end)
      vim.keymap.set('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set('n', '<leader>1',  function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<leader>2',  function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<leader>3',  function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<leader>4',  function() harpoon:list():select(4) end)
      vim.keymap.set('n', '<leader>hn', function() harpoon:list():next() end)
      vim.keymap.set('n', '<leader>hp', function() harpoon:list():prev() end)
    end,
  },
})
