#!/usr/bin/env python3

from suspicious_list import *

rule_template = 'MainRule "rx:{extensions_join}" "msg:{msg}" "mz:FILE_EXT" "s:$UPLOAD:8" id:{rule_id};'

extensions = list()
rules = list()
for incr, ident in enumerate(suspicious_list):
  extensions.extend(ident["extensions"])
  rule_id = 1500 + incr
  extensions_join = "|".join(map(lambda ex: "\." + ex.lower(), ident["extensions"]))
  msg = ident["category"]
  print(rule_template.format(
    extensions_join=extensions_join,
    msg=msg,
    rule_id=rule_id,
  ))


# duplicate
extensions.sort()
extensions = list(map(lambda x:x.lower(), extensions))
duplicates = set([x for x in extensions if extensions.count(x) > 1])
if len(duplicates) != 0:
  raise Exception("Duplicate extensions find", duplicates)
