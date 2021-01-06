#!/usr/bin/env python3

suspicious_list = [
  {
    "category": "ios",
    "extensions": [
      "hqx",
      "ipa",
    ],
  },
  {
    "category": "android",
    "extensions": [
      "apk",
      "apkm",
      "apks",
      "xapk",
    ],
  },
  {
    "category": "windows phone",
    "extensions": [
      "xap",
    ],
  },
  {
    "category": "security",
    "extensions": [
      "ca-bundle",
      "cer",
      "crt",
      "der",
      "p12",
      "p7b",
      "p7s",
      "pem",
      "pfx",
      "yara",
    ],
  },
  {
    "category": "apache httpd",
    "extensions": [
      "htaccess",
      "htpasswd",
    ],
  },
  {
    "category": "configuration",
    "extensions": [
      "conf",
      "ini",
      "json",
      "toml",
      "xml",
      "yml",
    ],
  },
  {
    "category": "windows",
    "extensions": [
      "application",
      "appx",
      "appxbundle",
      "bat",
      "bin",
      "cmd",
      "com",
      "cpl",
      "dll",
      "exe",
      "gadget",
      "hta",
      "inf",
      "inf1",
      "ins",
      "inx",
      "isu",
      "job",
      "jse",
      "lnk",
      "msc",
      "msh",
      "msh1",
      "msh1xml",
      "msh2",
      "msh2xml",
      "mshxml",
      "msi",
      "msp",
      "mst",
      "paf",
      "pif",
      "ps1",
      "ps1xml",
      "ps2",
      "ps2xml",
      "psc1",
      "psc2",
      "psd1",
      "psm1",
      "reg",
      "rgs",
      "run",
      "scf",
      "scr",
      "sct",
      "sfx",
      "shb",
      "shs",
      "u3p",
      "vb",
      "vbe",
      "vbs",
      "vbscript",
      "ws",
      "wsc",
      "wsf",
      "wsh",
    ],
  },
  {
    "category": "linux",
    "extensions": [
      "bash",
      "deb",
      "rpm",
      "sh",
      "so",
    ],
  },
  {
    "category": "php",
    "extensions": [
      "ctp",
      "php",
      "php3",
      "php4",
      "php5",
      "php6",
      "php7",
      "php8",
      "phtml",
      "twig",
    ],
  },
  {
    "category": "asp",
    "extensions": [
      "asa",
      "asax",
      "ascx",
      "ashx",
      "asmx",
      "asp",
      "aspx",
      "axd",
      "browser",
      "cd",
      "cdx",
      "compile",
      "config",
      "cs",
      "csproj",
      "disco",
      "dsdgm",
      "dsprototype",
      "idc",
      "jsl",
      "ldb",
      "licx",
      "master",
      "mdb",
      "mdf",
      "msgx",
      "rem",
      "resources",
      "resx",
      "sdm",
      "sdmDocument",
      "shtm",
      "shtml",
      "sitemap",
      "skin",
      "sln",
      "soap",
      "stm",
      "svc",
      "vbproj",
      "vjsproj",
      "vsdisco",
      "webinfo",
    ],
  },
  {
    "category": "java",
    "extensions": [
      "ear",
      "jad",
      "jar",
      "war",
    ],
  },
  {
    "category": "python",
    "extensions": [
      "py",
      "py3",
      "pyc",
      "pyo",
      "pyw",
    ],
  },
  {
    "category": "perl",
    "extensions": [
      "pl",
      "pm",
    ],
  },
  {
    "category": "ruby",
    "extensions": [
      "rb",
    ],
  },
  {
    "category": "documents contain macro",
    "extensions": [
      "docm",
      "dotm",
      "potm",
      "ppam",
      "ppsm",
      "pptm",
      "sldm",
      "xlam",
      "xlsm",
      "xltm",
    ],
  },
  {
    "category": "documents pdf",
    "extensions": [
      "eps",
      "pdf",
      "ps",
    ],
  },
  {
    "category": "legacy documents",
    "extensions": [
      "doc",
      "ppt",
      "xls",
    ],
  },
  {
    "category": "web asset",
    "extensions": [
      "appcache",
      "css",
      "eot",
      "htm",
      "html",
      "js",
      "mjs",
      "otf",
      "swf",
      "ttc",
      "ttf",
      "wasm",
      "webapp",
      "webmanifest",
      "woff",
      "woff2",
    ],
  },
]

rule_template = 'MainRule "rx:{extensions_join}" "msg:{msg}" "mz:FILE_EXT" "s:$UPLOAD:8" id:{rule_id};'

extensions = list()
rules = list()
for incr, ident in enumerate(suspicious_list):
  extensions.extend(ident["extensions"])
  rule_id = 1500 + incr
  extensions_join = "|".join(map(lambda ex: "\." + ex.lower(), ident["extensions"]))
  msg = ident["category"] + " extensions"
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
