vim.notify = require("notify")

-- https://www.reddit.com/r/neovim/comments/17qdqkt/get_a_handy_tip_when_you_launch_neovim/ thx <3
local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- show vim tip on startup
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup 'vimtip',
  callback = function()
    local job = require 'plenary.job'
    job
      :new({
        command = 'curl',
        args = { 'https://vtip.43z.one' },
        on_exit = function(j, exit_code)
          local res = table.concat(j:result())
          if exit_code ~= 0 then
            res = 'Error fetching tip: ' .. res
          end
          vim.notify(res, 2, { title = 'Tip!' })
        end,
      })
      :start()
  end,
})

