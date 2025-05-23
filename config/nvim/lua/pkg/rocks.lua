do
  local install = vim.fs.joinpath(vim.fn.stdpath('data'), 'rocks')
  local rocks_config = {
    rocks_path = vim.fs.normalize(install),
  }
  vim.g.rocks_nvim = rocks_config
  local lua_rocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, 'share', 'lua', '5.1', '?.lua'),
    vim.fs.joinpath(rocks_config.rocks_path, 'share', 'lua', '5.1', '?', 'init.lua')
  }
  local lua_rocks_c_path = {
    vim.fs.joinpath(rocks_config.rocks_path, 'lib', 'lua', '5.1', '?.so'),
    vim.fs.joinpath(rocks_config.rocks_path, 'lib64', 'lua', '5.1', '?.so')
  }
  package.path = package.path .. ';' .. table.concat(lua_rocks_path, ';')
  package.cpath = package.cpath .. ';' .. table.concat(lua_rocks_c_path, ';')
  vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, 'lib', 'luarocks', 'rocks-5.1', 'rocks.nvim', '*'))

end

if not pcall(require, 'rocks') then
  local rocks_location = vim.fs.joinpath(vim.fn.stdpath('cache'), 'rocks.nvim')
  if not vim.uv.fs_stat(rocks_location) then
    local url = 'https://github.com/nvim-neorocks/rocks.nvim'
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', url, rocks_location })
    assert(vim.shell_error == 0, 'rocks.nvim installation failed. Try exiting and re-entering nvim')
  end
  vim.cmd.source(vim.fs.joinpath(rocks_location, 'bootstrap.lua'))
  vim.fn.delete(rocks_location, 'rf')
end
