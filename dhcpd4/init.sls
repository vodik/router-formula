dhcp:
  pkg.installed: []
  file.managed:
    - name: /etc/dhcpd.conf
    - source: salt://dhcpd4/dhcpd.conf
    - template: py
  service.running:
    - name: dhcpd4.service
    - enable: true
    - watch:
      - file: dhcp
