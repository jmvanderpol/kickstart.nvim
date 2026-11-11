local M = {}
local startup_ms

function M.setup(started)
  startup_ms = nil
  local group = vim.api.nvim_create_augroup('ConfigStartupStats', { clear = true })
  vim.api.nvim_create_autocmd('UIEnter', {
    group = group,
    once = true,
    desc = 'Capture configuration startup duration once',
    callback = function()
      startup_ms = (vim.uv.hrtime() - started) / 1e6
    end,
  })
end

function M.get()
  local loaded, total = 0, 0
  for _, entry in pairs(require('leanpack.state').get_all_entries()) do
    if entry.merged_spec and entry.load_status ~= 'skipped' then
      total = total + 1
      if entry.load_status == 'loaded' then
        loaded = loaded + 1
      end
    end
  end
  return { loaded = loaded, total = total, startup_ms = startup_ms }
end

return M
