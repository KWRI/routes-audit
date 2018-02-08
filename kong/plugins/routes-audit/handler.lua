local BasePlugin = require "kong.plugins.base_plugin"

local RoutesAuditHandler = BasePlugin:extend()

RoutesAuditHandler.PRIORITY = 10

-- Extend string functionalites
string.startswith = function(self, str)
    return self:find('^' .. str) ~= nil
end

function RoutesAuditHandler:new()
  RoutesAuditHandler.super.new(self, "routes-audit")
end

function RoutesAuditHandler:access(conf)
  RoutesAuditHandler.super.access(self)

  local path = ngx.var.request_uri
  ngx.log(ngx.NOTICE, "Auditing " .. path)
  if path.startswith('apis') then
      -- Our hooks will pick it up
      ngx.log(ngx.NOTICE, "Skipping apis path")
  else
      -- We may need to hit url for notify
      -- if we encounter missing routes
      ngx.log(ngx.NOTICE, "Checking non apis path")
  end
end

return RoutesAuditHandler
