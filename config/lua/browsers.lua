local _M = {_VERSION = '0.0.1' }

local firefox_latest = 85
local firefox_ios_latest = 30
local chrome_latest = 87

function _M.is_modern(agent_name, agent_os, agent_version_major)
  if agent_name and agent_version_major and agent_version_major then
    if agent_name == 'chrome' and agent_version_major >= chrome_latest then
      return 'yes'
    end
    if agent_name == 'firefox' then
      if (agent_os == 'iphone' or agent_os == 'ipad') and agent_version_major >= firefox_ios_latest then
        return 'yes'
      elseif agent_version_major and agent_version_major >= firefox_latest then
        return 'yes'
      end
    end
  end
  return 'no'
end

function _M.is_modern_or_crawler(category, agent_name, agent_os, agent_version_major)
  if category and category == 'crawler' then
    return 'yes'
  end
  return _M.is_modern(agent_name, agent_os, agent_version_major)
end

return _M
