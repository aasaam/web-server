#!/usr/bin/python3
import argparse
import json
import os
import re
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--action', required=True)
args = parser.parse_args()

helper_path = os.path.dirname(os.path.realpath(__file__))

if args.action == "suspicious-extensions":
  # suspicious-extensions
  rule_template = 'MainRule "rx:{extensions_join}" "msg:{msg}" "mz:FILE_EXT" "s:$UPLOAD:8" id:{rule_id};'
  with open(helper_path + '/suspicious-extensions.json') as file:
    suspicious_list = json.load(file)
    extensions = list()
    rules = list()
    for incr, ident in enumerate(suspicious_list):
      extensions.extend(ident["extensions"])
      rule_id = 1500 + incr
      extensions_join = "|".join(map(lambda ex: "\." + ex.lower(), ident["extensions"]))
      msg = ident["category"]
      rules.append(rule_template.format(
        extensions_join=extensions_join,
        msg=msg,
        rule_id=rule_id,
      ))

    extensions.sort()
    extensions = list(map(lambda x:x.lower(), extensions))
    duplicates = set([x for x in extensions if extensions.count(x) > 1])
    if len(duplicates) != 0:
      raise Exception("Duplicate extensions find", duplicates)
    print("\n".join(rules))

elif args.action == "naxsi-rules":
  # naxsi-rules
  json_result = {}
  logstash_lines = [
    'dictionary => {'
  ]
  lua_lines = [
    'local naxsi_rules = {'
  ]
  with open(helper_path + "/../config/defaults/naxsi_core.rules") as file_in:
    for line in file_in:
      m = re.search('MainRule.*"msg:([^"]+)".*id:([0-9]+)', line)
      if m:
        id = m.group(2)
        message = m.group(1)
        json_result[id] = message
        logstash_lines.append("  \"{id}\" => \"{message}\",".format(id=id, message=message))
        lua_lines.append("  [\"{id}\"] = \"{message}\",".format(id=id, message=message))
  logstash_lines.append('}')
  lua_lines.append('}')

  print("JSON List:")
  print(json.dumps(json_result, indent=4))
  print("")
  print("# Logstash:")
  print("\n".join(logstash_lines))
  print("")
  print("Lua Table:")
  print("\n".join(lua_lines))

elif args.action == "mimetypes":
  # mimetypes
  found_extensions = {}
  with open(helper_path + "/../config/defaults/mime.types") as file_in:
    for line in file_in:
      m = re.search('([^\s]+)[\s]+([^"]+);', line)
      if m:
        mimetype = m.group(1)
        extensions = m.group(2).split(' ')
        for extension in extensions:
          if extension not in found_extensions:
            found_extensions[extension] = mimetype
          else:

            raise Exception('Duplicate extension: '+ extension)

  print(json.dumps(found_extensions, indent=2, sort_keys=True))

elif args.action == "env":
  template_markdown = """| {name} | `{default}` | {description} |"""
  template_docker_compose = """      {name}: ${{{name}:-{default}}}"""
  template_env_file = """# {name}={default}"""

  # env
  nginx_conf_template = open(helper_path + "/../addon/gomplates/nginx.tmpl", 'r').read()
  env = open(helper_path + "/env.json", 'r').read()
  env_data = json.loads(env)
  ma = re.findall('env.Getenv "([^"]+)" "([^"]+)"', nginx_conf_template, re.DOTALL)
  config_env_default = {}
  if ma:
    for m in ma:
      name = m[0]
      default = m[1]
      config_env_default[name] = default
      if name not in env_data:
        raise Exception('Env not found in JSON: '+ name)

  result = []
  for name, value in env_data.items():
    if name not in config_env_default:
      raise Exception('Env not found nginx template: '+ name)
    result.append({
      "name": name,
      "default": value['default'],
      "module": value['module'],
      "description": value['description'],
    })

  result = sorted(result, key=lambda k: k['module'])

  lines_markdown = {}
  lines_docker_compose = []
  lines_env_file = []

  for e in result:
    if e['module'] not in lines_markdown:
      lines_markdown[e['module']] = []
    lines_markdown[e['module']].append(template_markdown.format(name=e['name'], default=e['default'], description=e['description']))
    lines_docker_compose.append(template_docker_compose.format(name=e['name'], default=e['default'], description=e['description']))
    lines_env_file.append(template_env_file.format(name=e['name'], default=e['default'], description=e['description']))

  print("\n".join(lines_docker_compose))
  print("\n")
  print("\n".join(lines_env_file))
  print("\n")

  for module, lines in lines_markdown.items():
    print("| ⚙️ **{module}** | | |".format(module=module))
    print("\n".join(lines))

elif args.action == "server-public-cloud-arvancloud-allow":
  p = subprocess.Popen(['curl', '-Ls', '-H', 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:96.0) Gecko/20100101 Firefox/96.0', 'https://www.arvancloud.com/en/ips.txt'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  out, err = p.communicate()
  cidrs = out.decode("utf-8").strip().split("\n")
  allows = [
    '# https://www.arvancloud.com/en/ips.txt'
  ]
  real_ips = []
  for cidr in cidrs:
    allows.append("allow {cidr};".format(cidr=cidr))
    real_ips.append("set_real_ip_from {cidr};".format(cidr=cidr))

  allows.append('deny all;')
  real_ips.append('real_ip_header X-Real-IP;')

  print("\n".join(allows))
  print("\n".join(real_ips))

elif args.action == "server-public-cloud-cloudflare-allow":
  p = subprocess.Popen(['curl', '-Ls', 'https://www.cloudflare.com/ips-v4'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  out, err = p.communicate()
  cidrs = out.decode("utf-8").strip().split("\n")
  allows = [
    '# https://www.cloudflare.com/ips-v4'
  ]
  real_ips = []
  for cidr in cidrs:
    allows.append("allow {cidr};".format(cidr=cidr))
    real_ips.append("set_real_ip_from {cidr};".format(cidr=cidr))
  allows.append('deny all;')
  real_ips.append('real_ip_header CF-Connecting-IP;')
  print("\n".join(allows))
  print("\n".join(real_ips))

else:
  print("Invalid action, use following actions")
  print("- env")
  print("- mimetypes")
  print("- naxsi-rules")
  print("- server-public-cloud-arvancloud-allow")
  print("- server-public-cloud-cloudflare-allow")
  print("- suspicious-extensions")
  print("")
  parser.print_help()
  exit(1)

