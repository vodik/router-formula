## router-formula

Work in progress salt formula for deploying a Arch Linux based
wireless router and network.

To use, provide pillar data along the lines of:

```yaml
pppoe:
  peer: teksavvy.com
  user: XXXXXXXX
  password: XXXXXXXX

networks:
  enp2s0:
    address: 192.168.1.2/24
  bridge0:
    address: 10.3.1.1/26
    bridge:
      - enp3s0
      - enp4s0
    dhcp:
      domain: example.com
      range: 10.3.1.40 10.3.1.60
      dns: 10.3.1.1

wireless:
  wlp1s0:
    ssid: yourssid
    bridge: bridge0
    country_code: CA
    wpa_passphrase: XXXXXXXX

dns:
  zones:
    # TODO: consider a template file instead?
    example.com:
      - name: ns1
        rdtype: A
        data: 10.3.1.1
      - name: gateway
        rdtype: CNAME
        data: ns1.example.com
  forwarders:
    - 8.8.8.8
    - 8.8.4.4

ddns:
  algorithm: HMAC-MD5.SIG-ALG.REG.INT
  secret: XXXXXXXXXXXXXXXXXXXXXXXX
  zones:
    - lan.example.com
    - 1.3.10.in-addr.arpa
```

Note that while I'm working on generalizing it as much as possible,
there's still plenty that's hard coded for my particular situation.
For example, pppoe is configured for TekSavvy with IPv6 (dhcp prefix
delegation). Lots of pieces still missing from here.

### What's available

- Configure a pppoe tunnel to your ISP
- Basic networking setup (systemd-networkd) to setup a bridge with all
  specified interfaces, assign static IPs, etc.
- Wireless access point (hostapd)
- DHCP server (dhcpd4) with dynamic DNS support
- Split-horizon DNS for my domain for internal naming (and dynamic dns)

## Roadmap

There are still quite a few pieces of my router that still need to be
encoded here:

- The firewall (nftables) and a clamp-mss-to-pmtu hack for pppoe
- DNS entries. For example, ns1.vodik.xyz is currently hard coded
- IPv6 support through DHCP prefix delegation (dhcpcd-pd)
- Dynamic DNS support with a hook in pppoe to update DigitalOcean DNS
- Enabling usbnet
- Monitoring

## Why use salt?

It felt only natural since I already had a salt-master running on the
router to manage some of my own personal services on DigitalOcean.

The idea is to be able to leave all the heavy lifting to salt and be
able to configure the finer details of my router from a single text file
and have changed roll out quickly with a full audit log
