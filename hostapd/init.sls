# -*- coding: utf-8 -*-
{% set wireless = salt['pillar.get']('wireless') -%}

{% for interface, config in wireless.iteritems() %}
hostapd:
  pkg.installed: []
  file.managed:
    - name: /etc/hostapd/hostapd.conf
    - source: salt://hostapd/hostapd.conf
    - template: jinja
    - context:
        interface: {{ interface }}
        ssid: {{ config.ssid }}
        bridge: {{ config.bridge }}
        country_code: {{ config.country_code }}
        wpa_passphrase: {{ config.wpa_passphrase }}
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: hostapd
{% endfor %}
