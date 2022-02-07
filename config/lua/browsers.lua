local _M = {_VERSION = '0.0.1' }

local firefox_latest = 96
local chrome_latest = 98

function _M.is_modern(agent_name, agent_os, agent_version_major)
  if agent_name and agent_version_major then
    if agent_name == 'chrome' and agent_version_major >= chrome_latest then
      return '1'
    end
    if agent_name == 'firefox' and agent_version_major >= firefox_latest then
      return '1'
    end
  end
  return '0'
end

function _M.is_modern_or_crawler(category, agent_name, agent_os, agent_version_major)
  if category and category == 'crawler' then
    return '1'
  end
  return _M.is_modern(agent_name, agent_os, agent_version_major)
end

return _M
