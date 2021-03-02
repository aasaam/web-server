#!/usr/bin/python3

import re, json

markdown_table = """| {name} | `{default}` |"""
docker_compose = """      # {name}: ${{{name}:-{default}}}"""
env_file = """{name}={default}"""

markdowns = []
docker_compose_vars = []
env_file_lines = []
markdowns.append("| Name | Default |")
markdowns.append("| ---- | ------- |")

with open("./addon/gomplates/nginx.tmpl") as file_in:
    lines = []
    for line in file_in:
      m = re.search('env.Getenv "(ASM_[^"]+)" "([^"]+)"', line)
      if m:
        name = m.group(1)
        default = m.group(2)
        markdowns.append(markdown_table.format(name=name, default=default))
        docker_compose_vars.append(docker_compose.format(name=name, default=default))
        env_file_lines.append(env_file.format(name=name, default=default))

print("\n".join(markdowns))
print("\n")
print("\n".join(docker_compose_vars))
print("\n")
print("\n".join(env_file_lines))
