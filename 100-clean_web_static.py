#!/usr/bin/python3
"""
    this fabric script will delete out-of-date archives.
"""
from fabric.api import cd, env, lcd, local, run

env.hosts = ['100.26.219.124', '52.91.146.220']


def do_clean(number=0):
    """ This Function deletes outdated archives. """

    try:
        number = int(number)
        number >= 0

    except:
        return None

    number = 2 if number <= 1 else number + 1

    with lcd("./versions"):
        local('ls -t | tail -n +{} | xargs rm -rf'.format(number))
    with cd("/data/web_static/releases"):
        run('ls -t | tail -n +{} | xargs rm -rf'.format(number))
