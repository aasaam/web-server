#!/usr/bin/env python3
import sys
import re

html_file_path = sys.argv[1]

f = open(html_file_path, "r")
html = f.read()

matched = re.search('(https[^"]+.mmdb.gz)', html, re.IGNORECASE)
if matched:
  print(matched.group(1))
