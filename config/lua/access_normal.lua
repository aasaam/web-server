local parsed = normalize.parse(
  ngx.var.remote_addr,
  ngx.var.geo_country_code,
  ngx.var.http_user_agent,
  ngx.var.http_host,
  ngx.var.http_referer
)

ngx.var.ip_class                    = parsed.ip_class
ngx.var.foreign_referer_host        = parsed.foreign_referer_host

ngx.var.agent_all                   = parsed.agent_all
ngx.var.agent_category              = parsed.agent_category
ngx.var.agent_hash                  = parsed.agent_hash
ngx.var.agent_name                  = parsed.agent_name
ngx.var.agent_os                    = parsed.agent_os
ngx.var.agent_os_version            = parsed.agent_os_version
ngx.var.agent_os_version_major      = parsed.agent_os_version_major
ngx.var.agent_vendor                = parsed.agent_vendor
ngx.var.agent_version               = parsed.agent_version
ngx.var.agent_version_major         = parsed.agent_version_major
ngx.var.agent_is_modern             = parsed.agent_is_modern
ngx.var.agent_is_modern_or_crawler  = parsed.agent_is_modern_or_crawler

ngx.var.geo_country_currency        = parsed.geo_country_currency
ngx.var.geo_country_flag            = parsed.geo_country_flag
ngx.var.geo_default_lang            = parsed.geo_default_lang
ngx.var.geo_default_lang_direction  = parsed.geo_default_lang_direction

if string.match(ngx.var.request_uri, "^%/%.well%-known.*") == nil then
  if ngx.var.agent_check_is_modern == "on" and ngx.var.agent_is_modern == "no" then
    ngx.redirect("/.well-known/aasaam/status/437")
  elseif ngx.var.agent_check_is_modern_or_crawler == "on" and ngx.var.agent_is_modern_or_crawler == "no" then
    ngx.redirect("/.well-known/aasaam/status/437")
  end
end
