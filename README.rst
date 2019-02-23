LXC
===
Install and configure linux containers.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``lxc``
-----------

Installs the ``lxc`` package.

``lxc.containers``
-----------

Manages Linux containers.

See ``pillar.example`` for further details.

``lxc.tun_device``
-----------

Prepare the containers so TUN and TAP devices can be created.

Need to install a package inside the LXC?
=========================================

.. code:: jinja

    {{ install_on_debian_lxc(CONTAINER_NAME, PKG_NAME) }}
  
