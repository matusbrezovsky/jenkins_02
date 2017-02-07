*** Settings ***
Documentation        Test Automation Demo Suite

# Test Suite & Case set up & tagging
Suite Precondition      Run Before Test Suite
Suite Postcondition     Run After Test Suite
Test Precondition       Test Setup Default
Test Postcondition      Test Teardown Default        

# Libraries
Resource                global_vars.txt
Resource                Demo.txt

Library                 Dialogs
Library                 Collections
Library                 DateTime
Library                 ATFCommons
Library                 DeviceControl
Library                 OperatingSystem
Library                 SSHLibrary                  timeout=30
Library                 Wireshark
Resource                ssh.txt
Resource                sendspml.txt
Library                 StartAp.py
*** Variables ***

# Trace host IP
${TRC_IP}                   127.0.0.1
# Trace host aliases (both use the above IP)
${TRC1_ALIAS}               hlrHost1
${TRC2_ALIAS}               hlrHost2
# Trace Host-Interface pairs
@{trace_hosts}              ${TRC1_ALIAS}   ${TRC1_ALIAS}   ${TRC2_ALIAS}   ${TRC2_ALIAS}
@{trace_ifs}                bond0.106       bond0.107       bond0.206       bond0.207
# PGW host IP
${PGW_IP}                   127.0.0.1
# PGW host alias (using the above IP)
${PGW_ALIAS}                provHost


# local example traces
${TRC_LPATH}                ${EXECDIR}${/}data${/}wireshark${/}
${TRC_GSM_MAP_000_XML}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_000.xml
${TRC_GSM_MAP_000_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_000.txt
${TRC_GSM_MAP_001_XML}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_001_ul.xml
${TRC_GSM_MAP_001_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_001_ul.txt
${TRC_GSM_MAP_002_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_002_tc_02.03.03.01Merged.txt
${TRC_GSM_MAP_003_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_003_tc_02.04.01.27Merged.txt
${TRC_GSM_MAP_004_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_004_tc_02.04.01.29Merged.txt
${TRC_GSM_MAP_005_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_gsm_map_005_tc_02.04.01.30Merged.txt
${TRC_GSM_MAP_006_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_2xMapInOneFrame_tc_02.03.01.01Merged.txt
${TRC_GSM_MAP_007_TXT}      ${EXECDIR}${/}data${/}wireshark${/}test_trace_2xMapMC_tc_02.11.04.01Merged.txt

${TRC_DIAMETER_000_TXT}     ${EXECDIR}${/}data${/}wireshark${/}test_trace_diameter_02.07.01.02Merged.txt

${TRC_GSM_MAP_000_PCAP_FILE}    trace_a.pcap
${TRC_GSM_MAP_001_PCAP_FILE}    trace_b.pcap
${TRC_GSM_MAP_002_PCAP_FILE}    tc_02.03.03.01Merged.pcap

${TRC_GSM_MAP_000_PCAP}         ${EXECDIR}${/}data${/}wireshark${/}${TRC_GSM_MAP_000_PCAP_FILE}
${TRC_GSM_MAP_001_PCAP}         ${EXECDIR}${/}data${/}wireshark${/}${TRC_GSM_MAP_001_PCAP_FILE}
${TRC_GSM_MAP_002_PCAP}         ${EXECDIR}${/}data${/}wireshark${/}${TRC_GSM_MAP_002_PCAP_FILE}

${TRC_MTC_MERGED_TXT}           ${EXECDIR}${/}results${/}last${/}tc_demo_MTC_Trace_002Merged.txt
${TRC_SMS_MERGED_TXT}           ${EXECDIR}${/}results${/}last${/}tc_SMS_Trace_001Merged.txt
${TRC_PROV_MERGED_TXT}          ${EXECDIR}${/}results${/}last${/}tc_PROV_001Merged.txt

${RESULTS_LATEST}       ${RESULTS_ROOT_PATH}${/}last

*** Test Cases ***



Attach_3G
    [documentation]  Combined CS/PS Attach 3G
    [Tags]  ${MsDemo1}_3G
    ...     Attach
    ...     3G

    ${ms_a} =           Set Variable    ${MsDemo1}

    Execute Attach      ${ms_a}    type=3G_only


PacketData_3G
    [documentation]     PDP Context Activation 3g, DL speed verification  
    [Tags]  ${MsDemo2}_3G
    ...     3G
    ...     PacketData

    ${ms_a} =           Set Variable    ${MsDemo2}

    Initiate Device     ${ms_a}     speedtest_app
    Sleep               5s
    Start Speed Tests   ${ms_a}

    ${p}  ${d}  ${u}  ${i} =    Get Speed Test Results      ${ms_a}
    Log To Console              \nPing: ${p}ms dload: ${d}kbps uload: ${u}kbps info: ${i}


PacketData_4G
    [documentation]  LTE Attach and Default Bearer establishment, DL Speed verification
    [Tags]  ${MsDemo2}_4G
    ...     4G
    ...     PacketData

    ${ms_a} =           Set Variable    ${MsDemo2}

    Initiate Device     ${ms_a}     speedtest_app
    Sleep               5s
    Start Speed Tests   ${ms_a}

    ${p}  ${d}  ${u}  ${i} =    Get Speed Test Results      ${ms_a}
    Log To Console              \nPing: ${p}ms dload: ${d}kbps uload: ${u}kbps info: ${i}

MOC_3G_PSTN
    [documentation]  Mobile Originated Call, Mobile 3G to PSTN number
    [Tags]  ${MsDemo1}_3G   ${MsFixed1}
    ...     3G
    ...     MOC
    ...     PSTN

    ${ms_a} =           Set Variable    ${MsDemo1}
    ${pstn_b} =         Set Variable    ${MsFixed1}

    Execute MOC         ${ms_a}         ${pstn_b}


MTC_3G_PSTN
    [documentation]  Mobile Terminated Call, from PSTN to Mobile 3G
    [Tags]  ${MsDemo1}_3G   ${MsFixed1}
    ...     3G
    ...     MTC
    ...     PSTN

    ${pstn_a} =         Set Variable    ${MsFixed1}
    ${ms_b} =           Set Variable    ${MsDemo1}

    Execute MTC         ${pstn_a}       ${ms_b}

MMC_3G
    [documentation]  Mobile to Mobile Call 3G
    #[Tags]  ${MsDemo1}_3G   ${MsDemo2}_3G
    #...     3G
    #...     MMC
    # stop appium  Demo3  port= 4712
    run appium  Demo1   port=4715   address=127.0.0.1   optional_args= --log-level info --bootstrap-port 4801 --command-timeout 400 
    run appium  Demo2   port=4701   optional_args= --log-level info 
    ${ms_a} =           Set Variable    ${MsDemo1}
    ${ms_b} =           Set Variable    ${MsDemo2}

    Execute MMC Call    ${ms_a}         ${ms_b}         verify_speech=False

    appium should be running   Demo1
    appium should be running   Demo2
    stop appium    Demo1
    stop appium    Demo2
    appium should not be running  Demo1
    appium should not be running  Demo2
    
SMS_3G
    [documentation]  SMS in 3G with Delivery Receipt
    [Tags]  ${MsDemo1}_3G   ${MsDemo4}_3G
    ...     3G
    ...     SMS

    ${ms_a} =       Set Variable    ${MsDemo1}
    ${ms_b} =       Set Variable    ${MsDemo4}

    Send SMS        ${ms_a}         ${ms_b}         delivery_receipt=True

Trace_MMC_3G
    [Documentation]   MTC from MsDemo1 to MsDemo2
    ...     It should be verified that the DP12 is not triggered.
    ...     *** STEPS ***
    ...     1. Check if the subscriber has correct Basic Services provisioned for MsDemo2.
    ...    ...     2. Make a Call from MsDemo1 to MsDemo2
    ...     ***  RESULTS ***
    ...     1. The subscriber should have:
    ...     at least the Basic Service TS11 in his profile:
    ...         SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/TS11/MSISDN: <MSISDN-Number>
    ...     and should have the correct TCSI-Entry:
    ...     SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/OBJECTS/HLR/TCSI/OPERATORSERVICENAME: OGP_T_S1
    ...
    ...     2. Call is established correctly.
    ...     The SRI Response including the MSRN is sent from HLR to the MSS, because the DP12 is restricted for
    ...     HPLMN (availability = VPLMN), the DP12 is not triggered.
    ...
    [Tags]  ${MsDemo1}_3G     ${MsDemo2}_3G
    ...     Trace
    ...     3G
    ...     MMC

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data      pattern=MTC_001
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Debug Log   Verifying Subscription...
    ${out}=     Display Sub     ${PGW_ALIAS}                msisdn=${Demo_ISDN}
    Should Match    ${out}      *TS11/MSISDN: ${Demo_ISDN}*
    Should Match    ${out}      *TCSI/OPERATORSERVICENAME: OGP_T_S1*

    Initiate Device             ${MsDemo1}         phone_app
    Initiate Device             ${MsDemo2}         phone_app

    Start Trace                 ${trace_hosts}  ${trace_ifs}

    # ISDN conversion: CcNdcSn --> Sn
    ${a_number}=    Demo.Reformat ISDN   ${Demo1_ISDN}     format=Sn
    # ISDN conversion: CcNdcSn --> +CcNdcSn
    ${b_number}=    Demo.Reformat ISDN   ${Demo2_ISDN}     format=PlusCc

    Dial and Call  ${MsDemo1}     ${b_number}   expect_txt=Dialling
    Answer Call    ${MsDemo2}                   expect_txt=${a_number}
    End Call       ${MsDemo1}
    Stop Trace

    Release Device     ${MsDemo1}
    Release Device     ${MsDemo2}


    ${count}=   Parse test TXT trace   gsm_map     ${TRC_MTC_MERGED_TXT}

    # SRI
    Verify Trace  True   Component: invoke              localValue: sendRoutingInfo      Address digits: ${Demo_ISDN}
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfo      routingInfo: roamingNumber    !not!termAttemptAuthorized .12.
    Verify Trace  False  end

Trace_SMS_3G
    [Documentation]   MT SMS from MsDemo1 to MsDemo2
    ...     *** STEPS ***
    ...     1. Send Short Message from MsDemo1 to MsDemo2
    ...     ***  RESULTS ***
    ...     1. Short Message is successfully delivered from MsDemo1 to SMSC.
    ...     SMSC sends SRI for SMS to HLR, HLR responds with the VLR Address of MsDemo2.
    [Tags]  ${MsDemo1}_3G     ${MsDemo2}_3G
    ...     Trace
    ...     3G
    ...     SMS

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data      pattern=SMS_001
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Initiate Device         ${MsDemo1}     smscomposer_app
    Initiate Device         ${MsDemo2}     smsreader_app

    ${tstmp}=     Get Current Date      result_format=%Y%m%d%H%M
    # ISDN conversion: CcNdcSn --> +CcNdcSn
    ${b_number}=  Demo.Reformat ISDN         ${Demo2_ISDN}   format=PlusCc

    Start Trace             ${trace_hosts}  ${trace_ifs}

    Compose SMS and Send    ${MsDemo1}     ${b_number}     ${tstmp}_${TEST NAME}
    Verify SMS              ${MsDemo2}     ${tstmp}        timeout=60s

    Stop Trace

    Release Device          ${MsDemo1}
    Release Device          ${MsDemo2}



    ${count}=   Parse test TXT trace   gsm_map     ${TRC_SMS_MERGED_TXT}

    # SRIforSM
    Verify Trace  True   Component: invoke              localValue: sendRoutingInfoForSM      Address digits: ${Demo_ISDN}
    Verify Trace  False  Component: returnResultLast    localValue: sendRoutingInfoForSM      TBCD digits: ${Demo2_IMSI}     Address digits: ${VLR_ISDN}
    Verify Trace  False  end

Trace_Attach_3G
    [Documentation]   SAI+UL (CS+PS)
    #  LU and LU GPRS 
    #
    #  Location Update was performed successfully
    #  Check that Send_Authentication_Info_Ack was sent successfully to VLR
    #  Check that no Zone Code was included in Insert_Subscriber_Data message
    #  Check that the correct Service Keys were shown in trace: OCSI=3
    #
    #  GPRS Attach was performed successfully
    #  Check that the right APN settings and QOS values are sent to the SGSN

    [Tags]  ${MsDemo1}_3G
    ...     Trace
    ...     3G
    ...     Attach

    ${ms_a} =       Set Variable    ${MsDemo1}
    
    Execute Attach  ${ms_a}         type=3G_only

    Set Test Variable   ${TRC_PROTOC}   gsm_map
    ${count}=   Parse test TXT trace   gsm_map     ${TRC_GSM_MAP_001_TXT}
#    Should Be Equal As Integers        ${count}   10    msg=Wrong number of packets (${count}) in ${TRC_GSM_MAP_001_TXT}

    # SAI - success = TCAP end
    Verify Trace  True   Component: invoke              localValue: sendAuthenticationInfo    TBCD digits: 262073900317078
    Verify Trace  False  Component: returnResultLast    end
    # CS LU
    Verify Trace  True   Component: invoke    localValue: updateLocation    TBCD digits: 262073900317078
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    o-CSI    serviceKey: 3
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    o-CSI    !not!Zon
    Verify Trace  False  Component: returnResultLast    end
    # PS LU
    Verify Trace  True   Component: invoke    localValue: updateGprsLocation    TBCD digits: 262073900317078
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    class 3
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    internet
    Verify Trace  False  Component: invoke    localValue: insertSubscriberData    surf
    Verify Trace  False  Component: returnResultLast    end

Trace_Cancelloc
    [Documentation]   Deactivate MsDemo2 - Verify Cancel Location
    ...     *** STEPS ***
    ...     1.  Deactivate Subscriber via provisioning.
    ...     ***  RESULTS ***
    ...     1.  Verify that Cancel Location has been sent
    [Tags]  ${MsDemo2}_3G
    ...     Trace
    ...     Provisioning
    ...     Cancelloc
    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Data          pattern=PROV_001
    Prepare Dummy Response      pattern=search
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    # Verify SPML
    Debug Log   Verifying Subscription...
    ${out}=     Display Sub         ${PGW_ALIAS}    imsi=${Demo2_IMSI}
    #SPML Should Match All RegEx     ${out}          ROUTINGCATEGORY: 25
    SPML Should Match All RegEx     ${out}          ROUTINGCATEGORY: 12

    Start Trace     ${trace_hosts}      ${trace_ifs}
    Debug Log   Deactivating Subscription...
    ${out}=     Execute SendSpml    ${PGW_ALIAS}    -i ${Demo2_IMSI} ${SUBS_T_DEACTIVATE}
    Should Match                    ${out}          *result= success*

    # --------------------------------------------
    # D e m o   s p e c i f i c   p a r t  - START
    # - not necessary in real environments
    Prepare Dummy Response      pattern=not_registered
    # D e m o   s p e c i f i c   p a r t  - END
    # --------------------------------------------

    Wait Until Keyword Succeeds   20s   5s   Imsi Should Not Be Registered  ${Demo2_IMSI}  host=${PGW_ALIAS}  NEs=CsPs

    Stop Trace

    ${count}=   Parse test TXT trace   gsm_map     ${TRC_PROV_MERGED_TXT}
    # Cancel Location
    #Verify Trace  True  Component: invoke   localValue: cancelLocation  TBCD digits: ${MsDemo2_IMSI}  cancellationType: updateProcedure
    Verify Trace  True  Component: invoke   localValue: cancelLocation  TBCD digits: ${Demo2_IMSI}  cancellationType: subscriptionWithdraw


*** Keywords ***
Execute Attach
    [Arguments]     ${ms_a}     ${type}

    Enable Airplane Mode    ${ms_a}     verify=False     update_with=adb
    Sleep                   5s
    Disable Airplane Mode   ${ms_a}     verify=False     update_with=adb

    Wait Until Attached In Network      ${ms_a}         type=${type}


Execute MMC Call
    [Arguments]     ${ms_a}     ${ms_b}     ${verify_speech}=False

    ${a_number} =       Demo.Reformat ISDN   ${${ms_a}_ISDN}     format=Sn
    ${b_number} =       Demo.Reformat ISDN   ${${ms_b}_ISDN}     format=PlusCc

    Initiate Device     ${ms_a}         phone_app
    Initiate Device     ${ms_b}         phone_app

    Dial And Call       ${ms_a}         ${b_number}
    Answer Call         ${ms_b}         expect_txt=${a_number}


    Run Keyword If          ${verify_speech}         Verify Speech Path      ${ms_a}     ${ms_b}
    ...         ELSE        No Operation
       
    End Call            ${ms_a}

    Release Device      ${ms_a}
    Release Device      ${ms_b}

Execute MOC
    [Arguments]     ${ms_a}     ${pstn_b}

    ${a_number} =       Demo.Reformat ISDN   ${${ms_a}_ISDN}        format=Sn
    ${b_number} =       Demo.Reformat ISDN   ${${pstn_b}_ISDN}      format=PlusCc

    Initiate Device     ${ms_a}         phone_app
    Initiate Device     ${pstn_b}       pstn_app

    Dial and Call                   ${ms_a}     ${b_number}         expect_txt=Dial
    Verify Caller                   ${pstn_b}                       expect_txt=${a_number}    timeout=60s
    Answer Call                     ${pstn_b}                       expect_txt=${a_number}    timeout=60s
    Call Should Be Connected        ${ms_a}
    Call Should Be Connected        ${pstn_b}
    End Call                        ${ms_a}

    Release Device      ${ms_a}
    Release Device      ${pstn_b}



Execute MTC
    [Arguments]     ${pstn_a}     ${ms_b}

    ${a_number} =       Demo.Reformat ISDN   ${${pstn_a}_ISDN}      format=Sn
    ${b_number} =       Demo.Reformat ISDN   ${${ms_b}_ISDN}        format=PlusCc

    Initiate Device     ${ms_b}         phone_app
    Initiate Device     ${pstn_a}       pstn_app

    Dial and Call                   ${pstn_a}           ${b_number}                 expect_txt=Dial
    Verify Caller                   ${ms_b}             expect_txt=${a_number}      timeout=60s
    Answer Call                     ${ms_b}             expect_txt=${a_number}      timeout=60s
    Call Should Be Connected        ${pstn_a}
    Call Should Be Connected        ${ms_b}
    End Call                        ${pstn_a}

    Release Device                  ${ms_b}
    Release Device                  ${pstn_a}


Go To Website
    [Arguments]     ${ms_a}     ${web_address}      ${text}

    Initiate Device         ${ms_a}         browser_app
    Go To URL               ${web_address}
    Wait Until Text Is Displayed   ${text}
    Release Device                  ${ms_a}



Send SMS
    [Arguments]     ${ms_a}     ${ms_b}     ${delivery_receipt}=False

    ${a_number} =       Demo.Reformat ISDN       ${${ms_a}_ISDN}     format=Sn
    ${b_number} =       Demo.Reformat ISDN       ${${ms_b}_ISDN}     format=PlusCc
    ${tstamp}=          Get Current Date    result_format=%Y%m%d%H%M%S


    Initiate Device                 ${ms_a}         smsreader_app
    Initiate Device                 ${ms_b}         smsreader_app

    Run Keyword If                  ${delivery_receipt}     Enable SMS Delivery Receipts    ${ms_a}
    ...         ELSE                                        Disable SMS Delivery Receipts   ${ms_a}

    Delete SMS Conversations        ${ms_a}
    Delete SMS Conversations        ${ms_b}

    Release Device                  ${ms_a}
    Initiate Device                 ${ms_a}         smscomposer_app

    Compose SMS and Send            ${ms_a}         ${b_number}         ${tstamp}
    Sms Should Be Received          ${ms_b}         ${tstamp}
    Verify SMS Delivery Status      ${ms_a}         ${tstamp}       delivery_receipt=${delivery_receipt}

    Release Device                  ${ms_a}
    Release Device                  ${ms_b}


Verify Speech Path
    [Arguments]     ${ms_a}     ${ms_b}
    Start DTMF Decoder      ${ms_b}
    Send DTMF               ${ms_a}        123
    Verify DTMF             ${ms_b}        123
    Stop DTMF Decoder       ${ms_b}

    Start DTMF Decoder      ${ms_a}
    Send DTMF               ${ms_b}        123
    Verify DTMF             ${ms_a}        123
    Stop DTMF Decoder       ${ms_a}


Parse test TXT trace
    [arguments]     ${proto}    ${file}
    ${count}=       Parse Trace         this_is_ignored.pcap   ${proto}    fileformat=txt   outfile=${file}
    [return]        ${count}

Open Dummy Ssh Connections
    Open Connection         ${TRC_IP}   prompt=${SSHPROMPT}  alias=${TRC_HOST1}
    Login                   ${user}   ${passwd}
    Open Connection         ${TRC_IP}   prompt=${SSHPROMPT}  alias=${TRC_HOST2}
    Login                   ${user}   ${passwd}

Upload Example Traces
    Open Connection         ${TRC_IP}   prompt=${SSHPROMPT}  alias=${TRC_HOST1}
    Login                   ${user}   ${passwd}
    ${sout}  ${serr}  ${rc}=    Execute Command   rm -f ${TRC_SSH_USR_PATH}*    return_rc=True   return_stdout=True   return_stderr=True
    #Should Be Equal As Integers     ${rc}    0
    Put Directory       ${TRC_LPATH}     ${TRC_SSH_USR_PATH}     mode=0755   recursive=True
    Close Connection

Copy Dummy Default Traces
    # copy traces from ~/ta/trace to /tmp/ta/trace ((${TRC_SSH_USR_PATH} --> ${TRC_PATH}
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

Copy Dummy MAP Traces
    # copy traces from ~/ta/trace to /tmp/ta/trace ((${TRC_SSH_USR_PATH} --> ${TRC_PATH}
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs_map}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs_map}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs_map}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs_map}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

Copy Dummy DIA Traces
    # copy traces from ~/ta/trace to /tmp/ta/trace ((${TRC_SSH_USR_PATH} --> ${TRC_PATH}
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs_dia}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs_dia}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_000_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs_dia}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}${TRC_GSM_MAP_001_PCAP_FILE} ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs_dia}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

Copy Dummy Traces
    [arguments]         ${protocol}=default
    Run Keyword If      '${protocol}' == 'default'      Copy Dummy Default Traces
    Run Keyword If      '${protocol}' == 'gsm_map'      Copy Dummy MAP Traces
    Run Keyword If      '${protocol}' == 'diameter'     Copy Dummy DIA Traces


Create Results Directory
    [Documentation]   Create local directories for the logs and traces
    ...
    ...     Creates the results directory for the later steps that'll download the traces and SPML logs into this directory.
    ...     The directory name depends on the execution mode (i.e. the value of the DEVELOPMENT_MODE global variable)
    ...     If the DEVELOPMENT_MODE=True then the directory will be "./results/last" (NOTE: results in this directory will be overwritten)
    ...     If the DEVELOPMENT_MODE=False then the directory will be "./results/<timestamp>_<test suite name>"
    
    #get default directory 
    ${resultspath}=     Get Variable Value  ${RESULTS_ROOT_PATH}    ${EXECDIR}${/}results
    #generate result directory name - SUITE NAME needs some parsing for the scenarios where >1 suite is executed at once
    ${tstmp}=           Get Current Date    result_format=%Y%m%d%H%M
    ${str}=             Replace String      ${SUITE NAME}   ${SPACE}    _    
    ${str}=             Replace String      ${str}          &           and    
    ${strl}=            Split String        ${str}          .
    ${str}=             Set Variable        @{strl}[0]
    ${suitedir}=        Catenate            ${tstmp}_${str}

    # are we running in development mode
    ${inDevMode}=       _skip_suite_step    \${DEVELOPMENT_MODE}    Running in DEVELOPMENT_MODE - overwriting results in directory ${resultspath}${/}last
    Run Keyword If      ${inDevMode}        Set Suite Variable      ${RESULTS_LATEST}       ${resultspath}${/}last
    ...       ELSE                          Set Suite Variable      ${RESULTS_LATEST}       ${resultspath}${/}${suitedir}

    Create directory   ${RESULTS_LATEST}
    Create directory   ${RESULTS_LATEST}${/}pgwproxy

Prepare Dummy Data
    [arguments]         ${pattern}=default

    # create ${TRC_PATH_VAL} (/tmp/ta/trace) - just in case, it might not be there
    ${sout}  ${serr}  ${rc}=    Execute Command   mkdir -m 777 -p ${TRC_PATH}   return_rc=True   return_stdout=True   return_stderr=True

    # copy dummy traces
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_a.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[0]_@{trace_ifs}[0]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_b.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[1]_@{trace_ifs}[1]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_c.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[2]_@{trace_ifs}[2]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${TRC_SSH_USR_PATH}demo_${pattern}_d.pcap ${TRC_PATH}${TRC_FILEPREFIX}${TEST_NAME}_@{trace_hosts}[3]_@{trace_ifs}[3]${TRC_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True

    Set Test Variable   ${DUMMY_FILE_PATTERN}    ${pattern}
    # copy dummy SPML outputs
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_${pattern}_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0

Prepare Dummy Response
    [arguments]         ${pattern}=default
    # copy dummy SPML outputs
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_${pattern}_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0

Revert Dummy Response
    [arguments]         ${pattern}=Default
    # copy dummy SPML outputs
    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_${DUMMY_FILE_PATTERN}_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
    Should Be Equal As Integers     ${rc}    0


Upload Dummy Data
    Switch Connection   ${PGW_ALIAS}

    ${sout}  ${serr}  ${rc}=    Execute Command   rm -f ${DUMMY_SPML_SSH_USR_PATH}*    return_rc=True   return_stdout=True   return_stderr=True
    Put Directory       ${DUMMY_SPML_LPATH}     ${DUMMY_SPML_SSH_USR_PATH}     mode=0755   recursive=True

    Switch Connection   ${TRC1_ALIAS}

    ${sout}  ${serr}  ${rc}=    Execute Command   rm -f ${TRC_SSH_USR_PATH}*    return_rc=True   return_stdout=True   return_stderr=True
    #Should Be Equal As Integers     ${rc}    0
    Put Directory       ${TRC_LPATH}     ${TRC_SSH_USR_PATH}     mode=0755   recursive=True


Run Before Test Suite
    [Documentation]   Test Suite set-up/precondition
    ...
    ...     Test Suite preparation subroutine, executed once for the test suite i.e. once before
    ...     the test case execution starts.

    #Create Results Directory

    # Create an empty dictionary to store the current NW setting (e.g. 4G Auto, 3G only etc.) for each device
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_PREFERRED_NETWORK}    ${tmp_dict}

    # Create an empty dictionary to store the current Supplementary Services (CFU, CFB etc.)
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFU_STATUS}       ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFU_FTN}          ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFB_STATUS}       ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFB_FTN}          ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFNRY_STATUS}     ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFNRY_FTN}        ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFNRC_STATUS}     ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CFNRC_FTN}        ${tmp_dict}

    # Create an empty dictionary to store the current Call Barring Settings
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_BAIC_STATUS}      ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_BAOC_STATUS}      ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_BOIC_STATUS}      ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_BICROAM_STATUS}   ${tmp_dict}

    # Create an empty dictionary to store the current CLIP/CLIR Settings
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CLIR_STATUS}      ${tmp_dict}
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CLIP_STATUS}      ${tmp_dict}

    # Create an empty dictionary to store the current Call Waiting Settings
    ${tmp_dict} =   Create Dictionary
    Set Global Variable     ${DEV_CAW_STATUS}        ${tmp_dict}
    create device aliases

#    Create Results Directory
    
#    Open Ssh Connection     ${TRC_IP}                 ${TRC1_ALIAS}     ${user}    ${passwd}
#    Open Ssh Connection     ${TRC_IP}                 ${TRC2_ALIAS}     ${user}    ${passwd}
#    Open Ssh Connection     ${PGW_IP}                 ${PGW_ALIAS}      ${user}    ${passwd}

#    Upload sendspml tool    ${PGW_ALIAS}

#    Upload Example Traces
#    Upload Dummy Data


Run After Test Suite
    [Documentation]   Test Suite tear-down/postcondition
    ...
    ...     Test Suite tear-down subroutine, executed once for the test suite i.e. once after
    ...     test case execution has ended.

    no operation

Test Setup Default
    [Documentation]   Default Test Case set-up/precondition
    ...
    ...     Test case preparation subroutine, executed before each test case.
    ...     Executed for each TC, if not overridden in the TC itselt

    Device Setup
#    Device Setup
#    ${sout}  ${serr}  ${rc}=    Execute Command   cp ${DUMMY_SPML_SSH_USR_PATH}demo_default_spml.txt ${SPML_LOG_PATH}/${SPML_LOG_FILEPREFIX}${TEST_NAME}${SPML_LOG_FILEPOSTFIX}  return_rc=True   return_stdout=True   return_stderr=True
#    Should Be Equal As Integers     ${rc}    0
    Demo.prepare subs and devices

Test Teardown Default
    [Documentation]   Default Test Case tear-down/postcondition
    ...
    ...     Test case tear-down subroutine, executed after each test case.
    ...     Executed for each TC, if not overridden in the TC itselt
    Device Cleanup



