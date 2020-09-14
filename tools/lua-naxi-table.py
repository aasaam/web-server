#!/usr/bin/python3

import re

print("local naxsi_id_to_msg = {")
with open("./config/defaults/naxsi_core.rules") as file_in:
    lines = []
    for line in file_in:
      m = re.search('MainRule.*"msg:([^"]+)".*id:([0-9]+)', line)
      if m:
        id = m.group(2)
        message = m.group(1)
        print("  [\"{id}\"] = \"{message}\",".format(id=id, message=message))
print("}")
