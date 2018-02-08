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

  local cjson = require "cjson"
  local worker_events = require "resty.worker.events"
  local events = require "kong.core.events"
  local singletons = require "kong.singletons"

  local dao = singletons.dao
  local handler = function(data, event, source, pid)
    if data and data.collection == "apis" then
      if data.type == events.TYPES.ENTITY_CREATED then
        -- store to custom entities
        ngx.log(ngx.NOTICE, "Added API. ID:" .. data.entity.id)
        local rows = dao.apis.find_all({"id":data.entity.id})
        ngx.log(ngx.NOTICE, "Details:" .. cjson.encode(rows))
      elseif data.type == events.TYPES.ENTITY_DELETED then
        -- invalidate the custom entities
        ngx.log(ngx.NOTICE, "Deleted API. ID:" .. data.entity.id)
        local rows = dao.apis.find_all({"id":data.entity.id})
        ngx.log(ngx.NOTICE, "Details:" .. cjson.encode(rows))
      end
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
