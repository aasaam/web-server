local _M = { _VERSION = '0.0.1' }

function _M.ip_class(ip)
  local sec = string.match(ip, '^172.(%d+).%d+%.%d+$')
  if sec then
    local secnum = tonumber(sec)
    if secnum >= 16 and secnum <= 31 then
      return '172'
    end
  end
  if string.match(ip, '^192.168.%d+%.%d+$') then
    return '192'
  end
  if string.match(ip, '^127.%d+%.%d+%.%d+$') then
    return '127'
  end
  if string.match(ip, '^10.%d+%.%d+%.%d+$') then
    return '10'
  end
  return '0'
end

function _M.md5(s)
  local md5 = resty_md5:new()
  if md5 then
    local ok = md5:update(s)
    if ok then
      local digest = md5:final()
      return string.sub(str.to_hex(digest), 0, 16)
    end
  end
  return ''
end

function _M.hash_list(lst)
  local len = #lst
  local s = lst[1]
  for i = 2, len do
    s = s .. ':' .. lst[i]
  end
  return _M.md5(s)
end

function _M.escape_pattern(s)
  return s:gsub("([^%w])", "%%%1")
end

function _M.strpos(haystack, needle, offset)
  if _M.is_empty(haystack) or _M.is_empty(needle) then
    return false
  end

  local pattern = string.format("(%s)", needle)
  local i = string.find(haystack, pattern, (offset or 0))

  return (i ~= nil and i or false)
end

function _M.is_empty(s)
  return s == nil or s == '' or s == 'UNKNOWN'
end

function _M.normalize_version(s)
  if _M.is_empty(s) then
    return ''
  end

  local m1, m2 = string.match(s, '(%d+).(%d+)')

  if m1 and m2 then
    if m2 == '0' then
      return m1
    end
    return m1 .. '.' .. m2
  else
    local m3 = string.match(s, '%d+')
    if m3 then
      return m3
    end
  end

  return ''
end

function _M.normalize_version_major(s)
  if _M.is_empty(s) then
    return 0
  end

  local m1 = string.match(s, '%d+')
  if m1 then
    return tonumber(m1)
  end
  return 0
end

function _M.normalize(s)
  if _M.is_empty(s) then
    return ''
  end
  return string.gsub(s, '[^a-zA-Z0-9]+', ''):lower()
end

function _M.all_trim(s)
  return s:match"^%s*(.*)":match"(.-)%s*$"
end

function _M.one_space(s)
  local st = string.gsub(s, "[ ]+", " ")
  return _M.all_trim(st)
end

return _M
