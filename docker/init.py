#!/usr/bin/env python

from subprocess import call

call(["/root/symfony/symfony.sh"])
call(["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"])
