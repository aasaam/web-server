local _M = {_VERSION = '0.0.1' }

local firefox_latest = 80
local chrome_latest = 85

function _M.is_modern(agent_name, agent_version_major)
  if agent_name == 'chrome' and agent_version_major >= chrome_latest then
    return '1'
  end
  if agent_name == 'firefox' and agent_version_major >= firefox_latest then
    return '1'
  end
  return '0'
end

function _M.is_modern_or_crawler(category, agent_name, agent_version_major)
  if category == 'crawler' then
    return '1'
  end
  return _M.is_modern(agent_name, agent_version_major)
end

return _M
