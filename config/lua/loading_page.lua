local _M = { _VERSION = '0.0.1' }

local style = '<style>div{border:24px solid #e3f2fd;border-top:24px solid #1e88e5;border-radius:50%;width:128px;height:128px;margin:128px auto 0;animation:spin 2s linear infinite;-webkit-animation:spin 2s linear infinite}@-webkit-keyframes spin{0%{transform:rotate(0);-webkit-transform:rotate(0)}100%{transform:rotate(360deg);-webkit-transform:rotate(360deg)}}@keyframes spin{0%{transform:rotate(0);-webkit-transform:rotate(0)}100%{transform:rotate(360deg);-webkit-transform:rotate(360deg)}}</style>'
local html = '<!doctype html><html><head><meta charset="utf-8"><link rel="icon" href="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="><title>%s</title>%s</head><body><div></div><script>%s</script></body></html>'

function _M.get_html(title, script)
  return string.format(html, title, style, script)
end

return _M
