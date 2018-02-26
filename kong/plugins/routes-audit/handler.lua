local BasePlugin = require "kong.plugins.base_plugin"
local RoutesAuditHandler = BasePlugin:extend()

RoutesAuditHandler.PRIORITY = 10

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
        local api = dao.apis:find { id = data.entity.id }
        if api then
            local audit_log, err = dao.routes_audit:insert({
              api_id = api.id,
              name = api.name,
              path = api.upstream_url,
              state = "added"
            })
            ngx.log(ngx.NOTICE, "Added API:" .. cjson.encode(audit_log))
        end
      elseif data.type == events.TYPES.ENTITY_DELETED then
        -- invalidate the custom entities
        if data.entity.id then
            local audit_log, err = dao.routes_audit:insert({
              api_id = data.entity.id,
              state = "deleted"
            })
            ngx.log(ngx.NOTICE, "Deleted API:" .. cjson.encode(audit_log))
        end
      end
    end
  end

  worker_events.register(handler)
end

function RoutesAuditHandler:access(conf)
  RoutesAuditHandler.super.access(self)
end

return RoutesAuditHandler
