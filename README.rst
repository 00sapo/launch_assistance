============================================================
A simple method to assist remote computers for Linux newbies
============================================================

Usage
-----

#. create a wireguard configuration for your assisted machine
#. execute ``make_desktop_app.sh <path to conf>``
#. give the newly generated ``new_launch_assistance.desktop`` to your assisted machine
#. when assisting, tell the assisted machine to execute the launcher (they can
   just double-click it from a file manager or the desktop)
#. enter the vpn and connect via vnc to the assisted machine

How it works
------------

The desktop launcher contains 3 parts separated by 2 tags:

* the launcher itself
* first tag: ``#__SCRIPT__#``
* a shell script
* second tag: ``#__WIREGUARD_CONF__#``
* the wireguard configuration (addresses, keys, etc.)

The desktop launcher executes a command which reads the launcher itself and
strips everything under the first tag into a temporary shell script named as
``/tmp/TIMESTAMP.sh``, where ``TIMESTAMP`` is the timestamp at the moment of
running; the shell script actually contains the wireguard configuration.
Finally, the desktop launcher executes the script.

The script itself strips away everything under the secondtag of its on code and
puts it in a ``.conf`` file; it also checks that all dependencies are installed
(wireguard and x11vnc) and if not, it tries to install them. Finally, the
script removes all temporary file, including itself.

Discussion
----------

In general, the self-contained desktop launcher should start with ``rm $0`` to
make sure that the temporary script is removed; the approach should be to pass
the path to the desktop laucher to the script and the script should use this,
instead.

However, this approach allows to leave everything like in a regular script
except for the ``rm $0`` that the temporary script should include; it it doesn't
include it, it;s impossible from the desktop launcher to remove the script in
case of errors during the execution.

Credits
-------

#. `Federico Simonetta <https://federicosimonetta.eu.org>`_

License
-------

    Federico Simonetta <federicosimonetta at disroot.org>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
