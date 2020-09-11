#!/usr/bin/python2

import re
import sys

nginx_dir = sys.argv[1]

file_path = nginx_dir + "/src/http/modules/ngx_http_auth_request_module.c"

filedata = ''
f = open(file_path,'r')
filedata = f.read()
print("==== original " + file_path)
print(filedata)
filedata = re.sub(r'ctx->status == NGX_HTTP_UNAUTHORIZED', 'ctx->status == NGX_HTTP_UNAUTHORIZED || ctx->status == 488', filedata)
f.close()
print("==== replaced " + file_path)
print(filedata)
f = open(file_path,'w')
f.write(filedata)
f.close()

file_path = nginx_dir + "/src/core/ngx_log.h"

filedata = ''
f = open(file_path,'r')
filedata = f.read()
print("==== original " + file_path)
print(filedata)
filedata = re.sub(r'#define NGX_MAX_ERROR_STR.*', '#define NGX_MAX_ERROR_STR   65536', filedata)
f.close()
print("==== replaced " + file_path)
print(filedata)
f = open(file_path,'w')
f.write(filedata)
f.close()

file_path = nginx_dir + "/src/http/ngx_http_header_filter_module.c"

filedata = ''
f = open(file_path,'r')
filedata = f.read()
print("==== original " + file_path)
print(filedata)
filedata = filedata.replace('Server: openresty', 'Server: aasaam')
f.close()


print("==== replaced " + file_path)
print(filedata)
f = open(file_path,'w')
f.write(filedata)
f.close()

file_path = nginx_dir + "/src/core/nginx.h"

filedata = ''
f = open(file_path,'r')
filedata = f.read()
print("==== original " + file_path)
print(filedata)
filedata = filedata.replace('openresty/', 'aasaam/')
f.close()

print("==== replaced " + file_path)
print(filedata)
f = open(file_path,'w')
f.write(filedata)
f.close()

file_path = nginx_dir + "/src/http/ngx_http_special_response.c"

filedata = ''
f = open(file_path,'r')
filedata = f.read()
print("==== original " + file_path)
print(filedata)
filedata = filedata.replace('<html>', '<!DOCTYPE html><html lang=\\"en\\">')
filedata = filedata.replace('<center><h1>', '<h1>')
filedata = filedata.replace('</h1></center>', '</h1>')
filedata = filedata.replace('</head>', '<style>body{font-family:monospace;text-align:center;color:#111}hr{border:none;border-bottom:1px solid #aaa;height:0;max-width:320px;margin:16px auto 8px}div.p{font-size:.8em;color:#aaa}div.p a{color:#777;text-decoration:none}</style><link rel=\\"shortcut icon\\" type=\\"image/png\\" href=\\"data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==\\"></head>')
filedata = filedata.replace('<hr><center>openresty</center>', '<hr><div class=\\"p\\">Powered by <a href=\\"https://aasaam.com\\" rel=\\"nofollow\\">aasaam</a></div>')
filedata = filedata.replace('"<hr><center>"', '"<hr><p>"')
filedata = filedata.replace('"</center>"', '"</p>"')
filedata = filedata.replace('<center>', '<p>')
filedata = filedata.replace('</center>', '</p>')
f.close()

print("==== replaced " + file_path)
print(filedata)
f = open(file_path,'w')
f.write(filedata)
f.close()
