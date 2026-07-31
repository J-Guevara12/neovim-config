local luasnip = require('luasnip')
local cmp = require('cmp')

require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = {} })

-- Completion
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local opts = { buffer = event.buf, remap = false }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- rustaceanvim sets its own K with hover+actions; skip here to avoid conflict
    if not client or client.name ~= 'rust_analyzer' then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    end
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '{d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '}d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>gr',  vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN]  = '▲',
      [vim.diagnostic.severity.HINT]  = '⚑',
      [vim.diagnostic.severity.INFO]  = '»',
    },
  },
})

require('lsp_signature').setup({})

-- Lua LS (nvim workspace)
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      diagnostics = { globals = { 'vim' } },
    },
  },
})
vim.lsp.enable('lua_ls')

-- Python
vim.lsp.config('pylsp', {
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { maxLineLength = 120 },
        rope_autoimport = { enabled = true },
      },
    },
  },
})
vim.lsp.enable('pylsp')

vim.lsp.config('ruff', {
  capabilities = capabilities,
  init_options = {
    settings = { args = {} },
  },
})
vim.lsp.enable('ruff')

-- Sass
vim.lsp.config('somesass_ls', {
  capabilities = capabilities,
  root_markers = { 'package.json', 'angular.json', '.git' },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scss', 'sass' },
  callback = function(ev)
    local root = vim.fs.root(ev.buf, { 'package.json', 'angular.json', '.git' })
    vim.lsp.start(vim.tbl_extend('force', vim.lsp.config['somesass_ls'], {
      root_dir = root,
    }), { bufnr = ev.buf })
  end,
})

-- Angular Language Server: template type checking for .html files in Angular projects.
-- typescript-tools.nvim handles .ts; angularls handles templates.
local mason_ang = vim.fn.stdpath('data') .. '/mason/packages/angular-language-server/node_modules'
vim.lsp.config('angularls', {
  cmd = {
    'ngserver', '--stdio',
    '--tsProbeLocations', mason_ang,
    '--ngProbeLocations', mason_ang,
  },
  capabilities = capabilities,
  filetypes = { 'html', 'htmlangular' },
  root_dir = function(fname)
    return vim.fs.root(fname, { 'angular.json', 'project.json' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'htmlangular' },
  callback = function(ev)
    local root = vim.fs.root(ev.buf, { 'angular.json', 'project.json' })
    if not root then return end
    vim.lsp.start(vim.tbl_extend('force', vim.lsp.config['angularls'], {
      root_dir = root,
    }), { bufnr = ev.buf })
  end,
})
