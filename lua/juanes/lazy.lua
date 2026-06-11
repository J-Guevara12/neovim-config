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
  { 'folke/tokyonight.nvim' },

  -- TreeSitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Undo Tree
  { 'mbbill/undotree' },

  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
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
    },
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
    tag = '*',
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

  { 'mhinz/vim-signify' },

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
})
