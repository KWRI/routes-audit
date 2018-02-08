local BasePlugin = require "kong.plugins.base_plugin"
local RoutesAuditHandler = BasePlugin:extend()

RoutesAuditHandler.PRIORITY = 10

-- Extend string functionalites
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function RoutesAuditHandler:new()
  RoutesAuditHandler.super.new(self, "routes-audit")
end

function RoutesAuditHandler:init_worker()
  RoutesAuditHandler.super.init_worker(self)

  local worker_events = require "resty.worker.events"
  local cjson = require("cjson")

  local handler = function(data, event, source, pid)
    if data and data.collection == "apis" then
      ngx.log(ngx.NOTICE, "APIs changed. Details: " .. cjson:encode(data))
    end
  end

  worker_events.register(handler)
end

function RoutesAuditHandler:access(conf)
  RoutesAuditHandler.super.access(self)

  -- local path = ngx.var.request_uri
  -- ngx.log(ngx.NOTICE, "Auditing " .. path)
  -- if string.starts(path, '/apis') then
      -- Our hooks will pick it up
    --   ngx.log(ngx.NOTICE, "Skipping apis path")
  -- else
      -- We may need to hit url for notify
      -- if we encounter missing routes
    --   ngx.log(ngx.NOTICE, "Checking non apis path")
  -- end
end

return RoutesAuditHandler
