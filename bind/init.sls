bind:
  pkg.installed: []
  file.managed:
    - name: /etc/named.conf
    - source: salt://bind/named.conf
    - template: jinja
  service.running:
    - name: named
    - enable: true
    - reload: true
    - watch:
      - file: bind

{% set dns = salt['pillar.get']('dns') -%}
{% for zone in dns.zones %}
{{ zone }}:
  file.managed:
    - name: /var/named/{{ zone }}.zone
    - source: salt://bind/zone.jinja
    - template: jinja
    - replace: false
    - context:
        zone: {{ zone }}
    - watch_in:
      - service: bind
{% endfor %}

{% set ddns = salt['pillar.get']('ddns') -%}
{% for zone in ddns.zones %}
{{ zone }}:
  file.managed:
    - name: /var/named/{{ zone }}.zone
    - source: salt://bind/zone.jinja
    - template: jinja
    - replace: false
    - context:
        zone: {{ zone }}
    - watch_in:
      - service: bind
{% endfor %}
