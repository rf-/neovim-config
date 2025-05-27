-- [nfnl] fnl/local/plugins/nfnl.fnl
local nfnl = require("nfnl")
return nfnl.setup({["orphan-detection"] = {["auto?"] = false}})
