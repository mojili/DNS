add_dns:
  file.line:
    - name: /etc/resolv.conf
    - mode: insert
    - location: start
    - content: "nameserver 172.30.70.12 \n nameserver 172.30.70.14"
