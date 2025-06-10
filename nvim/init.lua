local path = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('<sfile>:p')), ':h')

vim.g.python3_host_prog = path .. "/py/.venv/bin/python"
vim.g.clipboard = "osc52"
