# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from atfwrappers.traces import WsWrapper
from atf.utils.list import AtfListener

class Wireshark(AtfListener, WsWrapper):
#class Wireshark(AtfListener, WsWrapper):
    """
    Library for Wireshark operations

    == Overview ==
    The trace analysis has always the following steps:
    - the traces are started on the target hosts (one tcpdump process per interface)
    - the traces are stopped on the target hosts
    - the trace files (one pcap-file per interface) are downloaded to the local results directory
    - the trace files are merged into one pcap file
    - the merged pcap file parsed (i.e. converted to text and read into memory)
    - the parsed trace is analysed

    === Starting traces ===
    The traces (i.e. tcpdumps) are started with the `Start Trace` method. This method expects two Lists as arguments:
    - list of hosts (i.e. connection aliases)
    - list of interfaces
    The host and interface lists are processed in "pairs" i.e. the following will start tcpdumps on ``host-A`` for
    interfaces ``bond0.206`` & ``bond0.207``.
    | ${trc_hosts} =  Create List    host-A      host-A
    | ${trc_ifs} =    Create List    bond0.206   bond0.207
    | Start Trace     ${trc_hosts}   ${trc_ifs}
    The default host and interface lists are defined in the global variable file ``global_vars.txt`` and
    each test case should use the global variables when starting traces. This way it'll be easy to update the target
    hosts, for example when one target host is taken down for maintenance.

    Examples using the global variables:
    - start traces on MAP interfaces
    | Start Trace     ${trace_hosts}    ${trace_ifs_map}
    - start traces on DIAMETER interfaces
    | Start Trace     ${trace_hosts}    ${trace_dia_map}

    === Stopping and parsing traces ===
    The traces are stopped with the `Stop Trace` method. It is not necessary to provide the target hosts etc. because
    the wireshark library "remembers" on which hosts and interfaces it has started the tcpdumps. After the tcpdump
    processes are terminated the trace files are downloaded and merged.

    The optional argument ``parse`` controls whether the merged traces are read into memory.

    Parsing is mandatory for trace verification (i.e. `Verify Trace` and `Verify Trace Starting At`).
    If trace verification is not necessary it is recommended not to parse (parse=False) the traces. This makes the test
    execution faster, especially if the trace files are big. If parsing is disabled then the binary trace files are
    just downloaded and merged.

    === Analysing traces ===
    After a trace is parsed into memory it can be analysed with `Verify Trace` and `Verify Trace Starting At` methods.
    The `Verify Trace` ignores the sequence of the analysed messages i.e. it always starts the analysis in the beginning
    of the trace and stops when a matching message is found (or fails is none of the messages match).
    `Verify Trace Starting At` can be used to analyse a specific sequence of messages.

    Both methods support protocol (e.g. TCAP or Diameter) specific transactions, i.e. it is possible to follow a
    certain transaction and analyse the messages that specfic to the transaction is question.

    For more details see the method specific documentation.
    ----
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '2.1-dev'
    ROBOT_LIBRARY_BUILD = '' + '1124Wed_96b08d0_201610141226'
    def __init__(self):
        for base in Wireshark.__bases__:
            base.__init__(self)
        #CommonsImpl.__init__(self)

