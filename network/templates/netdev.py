#!py

def run():
    return '\n'.join((
        '[NetDev]',
        'Name={}'.format(context['name']),
        'Kind={}'.format(context['kind']),
        ''
    ))
