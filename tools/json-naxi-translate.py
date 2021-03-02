#!/usr/bin/python3

import re
import json

from suspicious_list import *

helper = {}
helper['extensions'] = suspicious_list
helper['rules'] = {}

with open("./config/defaults/naxsi_core.rules") as file_in:
    lines = []
    for line in file_in:
      m = re.search('MainRule.*"msg:([^"]+)".*id:([0-9]+)', line)
      if m:
        id = m.group(2)
        message = m.group(1)
        helper['rules'][id] = message
print(json.dumps(helper, indent=2))
