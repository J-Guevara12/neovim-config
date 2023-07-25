vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.2',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Colorscheme: tokyo night
  use 'folke/tokyonight.nvim'

  -- TreeSitter
  use('nvim-treesitter/nvim-treesitter', {run= ':TSUpdate'})

  -- Undo Tree
  use ('mbbill/undotree')

  -- LSP
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
	    -- LSP Support
	    {'neovim/nvim-lspconfig'},             -- Required
	    {                                      -- Optional
	      'williamboman/mason.nvim',
	      run = function()
		pcall(vim.api.nvim_command, 'MasonUpdate')
	      end,
	    },
	    {'williamboman/mason-lspconfig.nvim'}, -- Optional

	    -- Autocompletion
	    {'hrsh7th/nvim-cmp'},     -- Required
	    {'hrsh7th/cmp-nvim-lsp'}, -- Required
	    {'L3MON4D3/LuaSnip'},     -- Required
	  }
    }
    use { 'ms-jpq/chadtree',
        branch= 'chad',
        run = 'python3 -m chadtree deps'
    }
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use ('nvim-tree/nvim-web-devicons')

    use {'Yggdroot/indentLine'}

    use {'norcalli/nvim-colorizer.lua'}

    use {'christoomey/vim-tmux-navigator'}

    use {'easymotion/vim-easymotion'}

    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use { 'mhinz/vim-signify' }

    use { 'psliwka/vim-smoothie' }

    use { 'mattn/emmet-vim',
        setup = function () -- load stuff before the plugin is loaded
            vim.g.user_emmet_leader_key = '<leader>z'

            vim.g.user_emmet_install_global = 1
          end
    }

    use { 'tpope/vim-surround' }

    use({
      'Wansmer/treesj',
      requires = { 'nvim-treesitter' },
      config = function()
        require('treesj').setup({--[[ your config ]]})
      end,
    })

end)
