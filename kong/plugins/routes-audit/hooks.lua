local events = require "kong.core.events"

local function invalidate(message_t)
  if message_t.collection == "apis" then
    ngx.log(ngx.NOTICE, "Received APIS event")
  elseif message_t.collection == "routes_audit" then
    ngx.log(ngx.NOTICE, "Received Routes Audit event")
  end
end

return {
  [events.TYPES.ENTITY_CREATED] = function(message_t)
     invalidate(message_t)
  end,
  [events.TYPES.ENTITY_UPDATED] = function(message_t)
    invalidate(message_t)
  end,
  [events.TYPES.ENTITY_DELETED] = function(message_t)
    invalidate(message_t)
  end
}
