local config = vim.deepcopy(require 'config.languages')
local path = vim.env.NVIM_MACHINE_CONFIG or (vim.fn.stdpath 'config' .. '/environment.json')

-- JSON keeps machine preferences separate from executable/shared configuration.
if vim.fn.filereadable(path) == 1 then
  local ok, overrides = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
  if not ok or type(overrides) ~= 'table' or vim.islist(overrides) then
    error('Invalid machine configuration in ' .. path .. ': expected a JSON object')
  end

  for key, values in pairs(overrides) do
    if config[key] == nil then
      error('Unknown machine configuration key in ' .. path .. ': ' .. tostring(key))
    end
    if type(values) ~= 'table' or not vim.islist(values) then
      error('Invalid ' .. key .. ' in ' .. path .. ': expected an array of non-empty strings')
    end
    for _, value in ipairs(values) do
      if type(value) ~= 'string' or value == '' then
        error('Invalid ' .. key .. ' in ' .. path .. ': expected an array of non-empty strings')
      end
    end
    -- Replace lists rather than merging array indices; [] disables a category.
    config[key] = values
  end
elseif vim.env.NVIM_MACHINE_CONFIG then
  error('Cannot read NVIM_MACHINE_CONFIG: ' .. path)
end

return config
