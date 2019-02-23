#
# Adds a tun device to a LXC
#
# Remember to configure this in your LXC:
# 'lxc.cgroup.devices.allow': 'c 10:200 rwm'
#

tun_tap_device_script:
  file.managed:
    - name: /root/add_tun_device.sh
    - mode: 750
    - contents: |
        #!/bin/sh
        if ! [ -c /dev/net/tun ]; then
          mkdir -p /dev/net
          mknod -m 666 /dev/net/tun c 10 200
        fi
tun_tap_device_startup:
  cmd.run:
    - name: /root/add_tun_device.sh
    - creates: /dev/net/tun

rc_local:
  file.managed:
    - name: /etc/rc.local
    - contents: |
        #!/bin/sh
        /root/add_tun_device.sh
        exit 0
