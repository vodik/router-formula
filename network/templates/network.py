#!py

def run():
    match_config = [
        '[Match]',
        'Name={}'.format(context['name']),
    ]

    network_config = ['[Network]']

    address = context.get('address')
    if address:
        network_config.append('Address={}'.format(address))

    bridge = context.get('bridge')
    if bridge:
        network_config.append('Bridge={}'.format(bridge))

    ipforward = context.get('ipforward')
    if ipforward:
        network_config.append('IPForward=yes')

    ipv6acceptra = context.get('ipv6acceptra')
    if ipv6acceptra:
        network_config.append('IPv6AcceptRA=yes')

    return '\n'.join((
        '\n'.join(match_config),
        '',
        '\n'.join(network_config),
        ''
    ))
