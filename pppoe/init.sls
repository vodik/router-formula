{% set pppoe = salt['pillar.get']('pppoe') -%}
ppp:
  pkg.installed: []
  file.managed:
    - names:
      - /etc/ppp/peers/{{ pppoe.peer }}:
        - source: salt://pppoe/peer.jinja
      - /etc/ppp/pap-secrets:
        - source: salt://pppoe/pap-secrets
    - template: jinja
  service.running:
    - name: ppp@{{ pppoe.peer }}
    - enable: true
    - watch:
      - file: ppp
