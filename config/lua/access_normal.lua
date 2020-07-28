local parsed = normalize.parse(
  ngx.var.request_ip,
  ngx.var.client_uid,
  ngx.var.uid_set,
  ngx.var.geo_country_code,
  ngx.var.http_user_agent,
  ngx.var.http_host,
  ngx.var.http_referrer
)

ngx.var.ip_class                    = parsed.ip_class
ngx.var.client_new                  = parsed.client_new
ngx.var.client_uid                  = parsed.client_uid
ngx.var.foreign_referrer_host       = parsed.foreign_referrer_host

ngx.var.agent_all                   = parsed.agent_all
ngx.var.agent_category              = parsed.agent_category
ngx.var.agent_hash                  = parsed.agent_hash
ngx.var.agent_is_modern             = parsed.agent_is_modern
ngx.var.agent_is_modern_or_crawler  = parsed.agent_is_modern_or_crawler
ngx.var.agent_name                  = parsed.agent_name
ngx.var.agent_os                    = parsed.agent_os
ngx.var.agent_os_version            = parsed.agent_os_version
ngx.var.agent_vendor                = parsed.agent_vendor
ngx.var.agent_version               = parsed.agent_version
ngx.var.agent_version_major         = parsed.agent_version_major

ngx.var.geo_country_currency        = parsed.geo_country_currency
ngx.var.geo_country_flag            = parsed.geo_country_flag
ngx.var.geo_default_lang            = parsed.geo_default_lang
ngx.var.geo_default_lang_direction  = parsed.geo_default_lang_direction
