local _snr_table = nil

local snr_table = function(script)
  if _snr_table ~= nil then
    return _snr_table[script]
  end
  local scripts = vim.api.nvim_exec([[
    redir => scriptnames
    silent! scriptnames
    redir END
  ]], true)
  _snr_table = {}
  for snr, filename in scripts:gmatch("%s+(%d+):%s+([^%s]+)") do
    _snr_table[vim.fn.fnamemodify(filename, ":t")] = snr
  end
  return _snr_table[script]
end

local exports = {
  getScriptFunc = function(script, fn)
    return function()
      local snr = snr_table(script)
      assert(snr)
      return vim.fn['<SNR>' .. snr .. '_' .. fn]()
    end
  end
}

return exports
