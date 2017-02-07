# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from atf.traces.wireshark import Wireshark
from robot.output import LOGGER

class WsWrapper():

    def __init__(self):
        # comment this block for API doc generation:
        # CUDO_BLOCK_START
        LOGGER.info('ATF initiate: Wireshark binary library')
        self._w = Wireshark()
        LOGGER.info('ATF initiate: OK')
        # CUDO_BLOCK_END
        pass

    def verify_trace_starting_at(self, new_txn, start_at, *match_attributes):
        """
        Trace Verification using regular expressions

        Verifies a parsed trace using regular expressions
        The parsed trace is in text format that is identical to the decoded packets in the Wireshark GUI
        i.e. the regular expressions can be constructed based on the GUI outputs.

        *Usage of the 'match_attributes':*
        Accepts an arbitarty number of Regular expressions as arguments, each of them must be inside the same packet/PDU,
        otherwise the verification will fail.
        The actual Regex executed is: ``^.*your_Regex.*$``  e.g. argument ``mytxt`` is executed as ``^.*mytxt.*$``
        ``!not!`` can be used as NOT-operand, e.g. ``!not!ThisTextShouldNotMatch``. This is because a "pure-RegExp"
        way of implementing NOT-operand is rather complicated.
        NOTE: be careful with the reserved RegEx characters: . ^ $ * + ? { } [ ] \ | ( )

        *Usage of the 'new_txn':*
        If set to 'new_txn=True' the first packet that matches the RegExp's is selected and the transaction ID in that
        packet is stored.
        When the 'new_txn=False' the previously stored Transaction ID is appended to the list of RegExp's i.e. only
        packets witnin that transaction are metched. For Example
        | Verify Trace Starting At  True   0  Component: invoke            localValue: sendAuthenticationInfo    TBCD digits: 123456789012345
        | Verify Trace Starting At  False  0  Component: returnResultLast

        The first line matches the first SAI for that IMSI in the trace, let's assume that it has "4fc195a3" TCAP
        transaction ID. The second line finds the response to that SAI using the stored TxnID i.e.
        the second line actually uses two RegExp's ("Component: returnResultLast" & "4fc195a3") for the match.
        If the second line would use 'new_txn=True' it would find the first "Component: returnResultLast" packet
        which is not necessarily the response to the SAI that we are interested in.
        The 'new_txn' uses TCAP transaction ID's for MAP (gsm_map) and Session ID's for DIA (diameter) to identify
        the transactions.

        *Usage of the 'start_at':*
        Sometimes it's necessary to verify the sequence of messages i.e. the matching should not always start in the
        beginning of the trace. This can be achieved with the 'start_at' argument.

        For Example: a test with successful GPRS attach, activate ODB (that triggers cancel location) and unsuccessful GPRS attach
        | ${pduInd}=  Verify Trace Starting At  True   0          Component: invoke            localValue: updateGprsLocation  TBCD digits: 123456789012345
        | ${pduInd}=  Verify Trace Starting At  False  0          Component: returnResultLast  localValue: updateGprsLocation
        | ${pduInd}=  Verify Trace Starting At  True   ${pduInd}  Component: invoke            localValue: cancelLocation      TBCD digits: 123456789012345
        | ${pduInd}=  Verify Trace Starting At  False  ${pduInd}  Component: returnResultLast
        | ${pduInd}=  Verify Trace Starting At  True   ${pduInd}  Component: invoke            localValue: updateGprsLocation  TBCD digits: 123456789012345
        | ${pduInd}=  Verify Trace Starting At  False  ${pduInd}  Component: returnError       operatorDeterminedBarring
        The above verifies that the messages are sent in the correct sequence

        - new_txn               Find a new transaction that matches the RegExp's (True/False)
        - start_at              Start verification at packet number 'start_at'
        - match_attributes      List of regular expressions that all should match the contents of a packet

        Returns the index of the packet that has matched and -1 if no matching packet has been found.
        """
        return self._w.verify_trace_starting_at(new_txn, start_at, *match_attributes)

    def verify_trace(self, new_txn, *match_attributes):
        """
        Trace Verification using regular expressions

        Wrapper method for `Verify Trace Starting At` i.e. calls that method with 'start_at=0'. For more details, please
        see `Verify Trace Starting At`
        """
        return self._w.verify_trace(new_txn, *match_attributes)

    def stop_trace(self, parse=True):
        """
        Stop traces

        Stops all started traces (i.e. tcpdumps), fetch + merge the binary traces and optionally parse the merged trace
        The used hosts and PIDs for the traces are stored in the `Start Trace` method and will be used for stopping the
        tcpdump processes.

        Parsing is mandatory for trace verification (i.e. `Verify Trace` and `Verify Trace Starting At`). If trace
        verification is not necessary it is recommended not to parse (parse=False) the traces. This makes the test
        execution faster, especially if the trace files are big. If parsing is disabled then the binary trace files
        are just downloaded and merged.

        - parse     Parse traces after stopping. Default is 'True'.
        """
        self._w.stop_trace(parse)

    def start_trace(self, hosts, interfaces=None, protocol='gsm_map'):
        """
        Starts traces on remote hosts

        Start tcpdump processes on remote hosts, use `Stop Trace` to stop tracing

        - hosts         List of connection aliases for the hosts running traces
        - interfaces    List of interfaces to trace. Default all interfaces (i.e. tcpdump's "-i any")
        - protocol      Protocol type to trace. Currently used only for parsing (i.e. everything is traced).
                        Currently supported protocols are 'tcap', 'gsm_map' and 'diameter'.
        """
        self._w.start_trace(hosts, interfaces, protocol)

    def parse_trace(self, filename, protocol, fileformat='pcap', outfile=None):
        """
        Parse binary traces into memory

        _*Should not be used directly*_ _Parsing is done automatically by the `Stop Trace`_

        Published as public method to enable overriding of default parsing, e.g. for unit testing purposes.

        - filename    The name of binary trace file
        - protocol    Protocol type to trace, passed on as tshark's "-Y" argument
        - fileformat  The type of the binary trace file (e.g. pcap)
        - outfile     The path + name of the parsed trace file

        Returns the number of packets parsed
        """
        return self._w.parse_trace(filename, protocol, fileformat, outfile)

    def delete_traces(self, hosts):
        """
        Deletes all traces on the remote trace hosts

        Deletes all trace files (e.g. /tmp/tc*.pcap) on remote trace hosts.
        Intented for Suite Teardown.

        - hosts    List of connection aliases for the hosts running traces
        """
        self._w.delete_traces(hosts)

    def parse_trace_xml(self, filename, protocol, fileformat='pcap', outfile='tmp.xml'):
        """
        not supported yet
        """
        return self._w.parse_trace_xml(filename, protocol, fileformat, outfile)

    def verify_trace_xml(self, xpath):
        """
        not supported yet
        """
        return self._w.verify_trace_xml(xpath)


