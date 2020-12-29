#!/usr/bin/python3

import re, json

found_extensions = {}

with open("./config/defaults/mime.types") as file_in:
    lines = []
    for line in file_in:
      m = re.search('([^\s]+)[\s]+([^"]+);', line)
      if m:
        mimetype = m.group(1)
        extensions = m.group(2).split(' ')
        for extension in extensions:
          if extension not in found_extensions:
            found_extensions[extension] = mimetype
          else:
            print(extension)
            raise Exception('Duplicate extension')

print(json.dumps(found_extensions, indent=2, sort_keys=True))
