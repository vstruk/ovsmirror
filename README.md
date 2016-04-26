# ovsmirror

A small script to create & delete Open vSwitch port mirrors with a single command.

Open vSwitch does not allow to dump traffic directly from it's ports. The only way is to mirror the traffic to a dummy linux interface and run tcpdump on it.
Raw OVS commands are tricky at first glance, so I decided to make it easier.


Usage:


      ./ovsmirror.sh (create|delete) <ifsnoop> <port> <bridge>

      <ifsnoop> - Dummy interface to create.
                  Most likely thing you're going to do next is 'tcpdump -i <ifsnoop>'

      <port>    - OVS port to mirror from.
      <bridge>  - OVS bridge the <port> connected to.
