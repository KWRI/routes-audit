package = "routes-audit"
version = "1.0-1"
source = {
  url = "git://github.com/KWRI/routes-audit",
  tag = "v1.0.0"
}
description = {
  summary = "Kong plugin that provides an audit functionalites over APIs routes (addition/deletion)",
  license = "Apache 2.0"
}
dependencies = {
  "lua ~> 5.1",
  "kong >= 0.10"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.routes-audit.handler"] = "kong/plugins/routes-audit/handler.lua",
    ["kong.plugins.routes-audit.schema"]  = "kong/plugins/routes-audit/schema.lua"
  }
}
