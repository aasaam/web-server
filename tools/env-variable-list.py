#!/usr/bin/python3

import re, json

markdown_table = """| {name} | `{default}` |"""
docker_compose = """      {name}: ${{{name}:-{default}}}"""
env_file = """# {name}={default}"""

markdowns = []
docker_compose_vars = []
env_file_lines = []

file_data = open("./addon/gomplates/nginx.tmpl", 'r').read()

ma = re.findall('env.Getenv "([^"]+)" "([^"]+)"', file_data, re.DOTALL)
if ma:
  for m in ma:
    name = m[0]
    default = m[1]
    markdowns.append(markdown_table.format(name=name, default=default))
    docker_compose_vars.append(docker_compose.format(name=name, default=default))
    env_file_lines.append(env_file.format(name=name, default=default))

markdowns = list(set(markdowns))
markdowns.sort()
docker_compose_vars = list(set(docker_compose_vars))
docker_compose_vars.sort()
env_file_lines = list(set(env_file_lines))
env_file_lines.sort()

print("\n".join(markdowns))
print("\n")
print("\n".join(docker_compose_vars))
print("\n")
print("\n".join(env_file_lines))
