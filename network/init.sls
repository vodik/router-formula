#!pydsl

def managed_netdev(**kwargs):
    state_name = '{}.netdev'.format(kwargs['name'])
    state(state_name)\
        .file('managed',
              name='/etc/systemd/network/{}'.format(state_name),
              source='salt://network/templates/netdev.py',
              context=kwargs,
              template='py').require_in(service='systemd-networkd')


def managed_network(**kwargs):
    state_name = '{}.network'.format(kwargs['name'])
    state(state_name)\
        .file('managed',
              name='/etc/systemd/network/{}'.format(state_name),
              source='salt://network/templates/network.py',
              context=kwargs,
              template='py').require_in(service='systemd-networkd')


state('systemd-networkd').service('running', enable=True)

networks = __salt__['pillar.get']('networks', {})
for interface, network in networks.iteritems():
    bridge = network.get('bridge')
    address = network.get('address')

    if bridge:
       managed_netdev(name=interface, kind='bridge')
       managed_network(name=interface,
                       address=address,
                       ipforward=True,
                       ipv6acceptra=True)

       for brif in bridge:
           managed_network(name=brif,
                           bridge=interface,
                           ipforward=True)
    elif address:
       managed_network(name=interface,
                       address=address)


wireless = __salt__['pillar.get']('wireless', {})
for interface, config in wireless.iteritems():
    if 'bridge' in config:
       managed_network(name=interface, ipforward=True)
