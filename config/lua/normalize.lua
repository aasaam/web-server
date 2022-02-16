local _M = { _VERSION = '0.0.1' }

function _M.parse(
  remote_addr,
  geo_country_code,
  http_user_agent,
  http_host,
  http_referer
)
  local country_code = geo_country_code or ''
  local host = http_host or ''
  local referer = http_referer or ''
  local user_agent = http_user_agent or ''

  local parsed_data = {
    ip_class='',
    client_ip_ua_hash='',
    foreign_referer_host='',

    agent_all='',
    agent_category='',
    agent_name='',
    agent_os_version_major='',
    agent_os_version='',
    agent_os='',
    agent_vendor='',
    agent_version_major='',
    agent_version='',
    user_agent_hash='',

    geo_country_currency='',
    geo_country_flag='',
    geo_default_lang_direction='',
    geo_default_lang='',
  }

  -- ip classification
  parsed_data.ip_class = utils.ip_class(remote_addr)

  -- client ip user agent hash
  parsed_data.client_ip_ua_hash = utils.md5(string.format(
    "%s:%s",
    remote_addr,
    http_user_agent
  ))

  -- countries helper
  parsed_data.geo_country_currency = locales.get_country_currency(country_code)
  parsed_data.geo_country_flag = locales.get_country_flag(country_code)
  parsed_data.geo_default_lang = locales.get_default_lang(country_code)
  parsed_data.geo_default_lang_direction = locales.get_default_direction(country_code)

  -- agent
  local r = resty_woothee.parse(user_agent)

  -- names
  parsed_data.agent_name = utils.normalize(r.name)
  parsed_data.agent_os = utils.normalize(r.os)
  parsed_data.agent_category = utils.normalize(r.category)
  parsed_data.agent_vendor = utils.normalize(r.vendor)

  -- versions
  parsed_data.agent_version = utils.normalize_version(r.version)
  parsed_data.agent_version_major = utils.normalize_version_major(r.version)
  parsed_data.agent_os_version = utils.normalize_version(r.os_version)
  parsed_data.agent_os_version_major = utils.normalize_version_major(r.os_version)

  -- all
  parsed_data.agent_all = utils.one_space(string.format(
    "%s %s %s %s %s %s",
    parsed_data.agent_name,
    parsed_data.agent_version_major,
    parsed_data.agent_os,
    parsed_data.agent_os_version_major,
    parsed_data.agent_category,
    parsed_data.agent_vendor
  ))

  -- hash
  parsed_data.user_agent_hash = utils.md5(user_agent)

  -- modern
  parsed_data.agent_is_modern = browsers.is_modern(
    parsed_data.agent_name,
    parsed_data.agent_os,
    parsed_data.agent_version_major
  )
  parsed_data.agent_is_modern_or_crawler = browsers.is_modern_or_crawler(
    parsed_data.agent_category,
    parsed_data.agent_name,
    parsed_data.agent_os,
    parsed_data.agent_version_major
  )

  -- foreign_referer_host
  if utils.is_empty(referer) == false then
    local referer_url_parsed = resty_url.parse(referer)
    if referer_url_parsed and utils.is_empty(referer_url_parsed.host) == false then
      if utils.strpos(referer_url_parsed.host, host) == false and utils.strpos(host, referer_url_parsed.host) == false then
        parsed_data.foreign_referer_host = referer_url_parsed.host
      end
    end
  end

  return parsed_data
end

return _M
