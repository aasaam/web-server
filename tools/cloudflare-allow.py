#!/usr/bin/python3

import subprocess

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
print("\n")
print("\n".join(real_ips))
