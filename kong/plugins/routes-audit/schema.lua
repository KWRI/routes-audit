return {
  no_consumer = true, -- this plugin will only be API-wide,
  fields = {
      missing_api_callback = { type = "string", required = true, default = "https://.accept-hook-endpoint" } -- can be slack hook
  }
}
