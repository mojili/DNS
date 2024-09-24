add_dns:
  file.line:
    - name: /etc/resolv.conf
    - mode: insert
    - location: start
    - content: "nameserver a.b.c.d \n nameserver a.b.c.e"
