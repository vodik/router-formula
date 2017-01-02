router:
  'roles:router':
    - match: grain
    - network
    - bind
    - dhcpd4
    - hostapd
    - pppoe
