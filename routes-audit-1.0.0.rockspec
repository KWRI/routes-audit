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
    ["kong.plugins.jwt-claim-headers.handler"] = "handler.lua",
    ["kong.plugins.jwt-claim-headers.schema"]  = "schema.lua",
    ["kong.plugins.jwt-claim-headers.claim_headers"]  = "claim_headers.lua"
  }
}
