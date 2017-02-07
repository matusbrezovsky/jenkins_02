#!/bin/bash
#
#  Wrapper script for curl for sending SPML requests (http/https)
#
#  Usage:  sendspml [OPTIONS] SPML_FILE
#
#  Options:
#   -i IMSI                 Replace all occurrences of ##imsi## in the SPML_FILE with IMSI
#   -m MSISDN               Replace all occurrences of ##msisdn## in the SPML_FILE with MSISDN
#   -t TARGET               Possible Target systems
#                              pgw  = send req to PGW using HTTP
#                              pgws = send req to PGW using HTTPS
#                              pga  = send req to PGW Adapter using HTTP
#                              pgas = send req to PGW Adapter using HTTPS (this is the default)
#                              file = print req to stdout
#   -h HOST                 Hostname or the IP address of the target PGW node (default is localhost)
#   -p PORT                 Port of the target PGW node
#   -s                      Do not add the SOAP tags (body & envelope) to the request (per default these are added to the SPML_FILE before sending it)
#   -r                      Do not replace the "##<value>##" tags in the SPML_FILE (e.g. ##imsi## & ##msisdn##)
#   -x                      Reformat XML the output to one element/line format (good for grepping)
#                           (Requires the xmlparser.awk file in the working directory)
#   -u SOAPURN              SOAP End point URN to be used (default: /ProvisioningGateway/services/SPMLO2Subscriber10Service)
#   -z VERSIONSTRING        Replace all occurrences of ##version## in the SPML_FILE with VERSIONSTRING (default: O2_SUBSCRIBER_v10)
#   -o SUBSNAMESPACE        Replace all occurrences of ##subNs## in the SPML_FILE with SUBSNAMESPACE (default: urn:siemens:names:prov:gw:O2_SUBSCRIBER:1:0)
#   -f UID                  Replace all occurrences of ##uid## in the SPML_FILE with UID
#   -g UID                  Replace all occurrences of ##uid2## in the SPML_FILE with UID
#   -j IMSI                 Replace all occurrences of ##imsi2## in the SPML_FILE with IMSI
#   -k MSISDN               Replace all occurrences of ##msisdn2## in the SPML_FILE with MSISDN
#   -l SPMLTMPL             Replace all occurrences of ##scd## in the SPML_FILE with SPMLTMPL (= SPML Template name)
#   -a ANYTAG               Replace all occurrences of ##any## in the SPML_FILE with ANYTAG (could be used to replace any values e.g. CFU status)
#   -y                      Print the SPML request to stdout before sending it
#   -d                      Debug/verbose mode
#   -v                      Print Version
#   -?                      Display this help
#  
#  HTTPS options (when using pgws or pgas mode) 
#   -q CACRT     CA certificate file - used for the server authentication (default: ca.crt)
#   -w CLTCRT    Client certificate file - used for the client authentication (default: cl.pem)
#   -e CLTKEY    Client private key file - used for the client authentication (default: cl.key)
#   
##ENDHELP##
# 
# Version:	2.1 (20130417)
#
# Location: 
#       https://sharenet-ims.inside.nokiasiemensnetworks.com/Overview/D482877319
#       https://share.o2.com/sites/NT-PM/HLR_Evolution/Shared Documents/05_Tools and utilities/sendSpml
#
# Author:	Jari Nurminen
#
# Version History:
#   1.0 (20121017) First version /JNu
#   1.1 (20121130) Updates /JNu
#                  - made the script "thread safe" when running multiple instances each use their own tmp-file (tmp.spml.<PID>)
#                  - added "file" target (print request to stdout)
#                  - added "-x" option for XML parser
#                  - added "-uzo" options for sending request to another SOAP endpoint (i.e. application/PGW Plugin)
#   1.2 (20121207) Updates /JNu
#                  - added "f,g,j,k" options for UID, IMSI2 & MSISDN2 replacements (for Id Swaps) 
#                  - added "l" options for template name replacements (for pgwproxy) 
#   1.3 (20121213) Updates /JNu
#                  - added "a" option for ANYTAG (for replacing random tags e.g. CFU status) 
#   1.4 (20130109) Updates /JNu
#                  - changed default target: "-t pgw" ==> "-t pga" 
#                  - changed default host: "localhost" ==> "pgwtb1-601" 
#   1.5 (20130207) Updates /JNu
#                  - changed default target: "-t pga" ==> "-t pgas" 
#   1.6 (20130214) Updates /JNu
#                  - added "y" option for logging the SPML request 
#   2.0 (20130218) Updates /JNu
#                  - replaced wget with curl, due to wget problems (e.g. with HTTP error 500 wget does not print anything, curl does print the response which is usually meaningful)
#   2.1 (20130417) Updates /JNu
#                  - bug-fix: now showing error messages in case invalid parameters
#                  - bug-fix: imsi/msisdn/uid are no longer mandatory params (otherwise replacing only version-string, namespace etc. does not work)
#                  - added "batch mode" examples to the header (no changes in the sendspml.sh itself)  
#
###
# EXAMPLES
#    1) Search subs with IMSI (send request to PGW at 172.29.87.143) - security disabled:
#         ./sendspml.sh -x -t pgw -h 172.29.87.143 -i 262071234567890 searchImsi.xml
#         
#             searchImsi.xml contents:
#                 <spml:searchRequest
#                     xmlns:spml="urn:siemens:names:prov:gw:SPML:2:0"
#                     xmlns:subscriber="##subsNs##"
#                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#                     <version>##version##</version>
#                     <base>
#                         <objectclass>Subscriber</objectclass>
#                         <alias name="imsi" value="##imsi##" xsi:type="subscriber:SubscriberAliasType"/>
#                     </base>
#                 </spml:searchRequest>
# 
#             The SPML request contents:
#                  <spml:searchRequest
#                     xmlns:spml="urn:siemens:names:prov:gw:SPML:2:0"
#                     xmlns:subscriber="urn:siemens:names:prov:gw:O2_SUBSCRIBER:1:0"
#                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#                     <version>O2_SUBSCRIBER_v10</version>
#                     <base>
#                         <objectclass>Subscriber</objectclass>
#                         <alias name="imsi" value="262071234567890" xsi:type="subscriber:SubscriberAliasType"/>
#                     </base>
#                 </spml:searchRequest>
# 
#             The Result will be reformatted XML i.e. one element per line (good for grepping e.g. grep "result= success") e.g.
#                 SOAPENV:ENVELOPE/xmlns:soapenv= http://schemas.xmlsoap.org/soap/envelope/
#                 SOAPENV:ENVELOPE/xmlns:xsd= http://www.w3.org/2001/XMLSchema
#                 SOAPENV:ENVELOPE/xmlns:xsi= http://www.w3.org/2001/XMLSchema-instance
#                 ...
#                 SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:SEARCHRESPONSE/result= success
#                 ...
#             Without the -x option the Result will be pure XML e.g. 
#                 <?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ...
#                 ...
#                 </spml:searchResponse></soapenv:Body></soapenv:Envelope>
#             
# 
#   2) Create a HLR subs using the ADD_OGP_DATA_SITE_A.xml template (send request to PGW Adapter at 172.29.87.143) - security disabled:
#         ./sendspml.sh -x -t pga -h 172.29.87.143 -i 262071234567890 -m 4917912345678 -a 491793322222222 -l ADD_OGP_DATA_SITE_A.xml changeDirReq.xml
# 
#             changeDirReq.xml contents:
#                 <spml:spmlChangeDirective mode="add" identifier="##scd##">
#                     <parameter name="_IMSI" value="##imsi##"/>
#                     <parameter name="_MSISDN" value="##msisdn##"/>
#                     <parameter name="_FTN" value="##any##"/>
#                 </spml:spmlChangeDirective>
# 
#             The SPML request contents:
#                  <spml:spmlChangeDirective mode="add" identifier="ADD_OGP_DATA_SITE_A.xml">
#                     <parameter name="_IMSI" value="262071234567890"/>
#                     <parameter name="_MSISDN" value="4917912345678"/>
#                     <parameter name="_FTN" value="491793322222222"/>
#                 </spml:spmlChangeDirective>
# 
#             The Result will be reformatted XML i.e. one element per line (good for grepping e.g. grep "result= success") e.g.
#                 SOAPENV:ENVELOPE/xmlns:soapenv= http://schemas.xmlsoap.org/soap/envelope/
#                 SOAPENV:ENVELOPE/xmlns:xsd= http://www.w3.org/2001/XMLSchema
#                 SOAPENV:ENVELOPE/xmlns:xsi= http://www.w3.org/2001/XMLSchema-instance
#                 ...
#                 SOAPENV:ENVELOPE/SOAPENV:BODY/SPML:MODIFYRESPONSE/result= failure
#                 ...
#             Here also, without the -x option the Result will be pure XML
# 
#   3) "batch mode":
#        There's no native support (e.g. give an imsi-range, imsi-file as input parameter) for generating batch/bulk files in sendspml.sh. 
#        However the sendspml.sh can be used inside a "batch file creation" shell script. What is needed for batch files is:
#        a) a batch request header, from a SPML template or a fixed one (below examples use a template
#        b) a batch body, e.g. a SPML template containing one SPML request with replace tags (e.g. ##imsi##, ##msisdn##) to be replaced with sendspml.sh
#        c) a batch request footer, from a SPML template or a fixed one (below examples use a template)
#        
#        What the shell script shall do is:
#        - print a) (batch header) into a file (e.g. myBatchRequests.xml)
#        - append b) into a file (e.g. myBatchRequests.xml) - repeat this for each IMSI/MSISDN
#        - append c) into a file (e.g. myBatchRequests.xml)
#        
#        Below are a couple of examples: 
#            The batch header (batchHeader.xml) contains this:
#                    <spml:batchRequest
#                        onError="resume"
#                        processing="parallel"
#                        xmlns:spml="urn:siemens:names:prov:gw:SPML:2:0"
#                        xmlns:subscriber="##subsNs##"
#                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#                        <version>##version##</version>
#            The batch footer (batchFooter.xml) contains this:
#                    </spml:batchRequest>
#            The batch body (batchBody.xml) contains this:
#                    <request xsi:type="spml:AddRequest">
#                        <version>O2_SUBSCRIBER_v10</version>
#                        <object xsi:type="subscriber:Subscriber">
#                            <auc>
#                                <imsi>##imsi##</imsi>
#                                <encKey>2ECB13F80D944850283BCE381B68BC0C</encKey>
#                                <algoId>25</algoId>
#                                <kdbId>61</kdbId>
#                                <acsub>1</acsub>
#                            </auc>
#                        </object>
#                    </request>
#            IMSI-MSISDN file (foo.txt) contains this
#                    262070740100000 4917966100000
#                    262070740100001 4917966100001
#                    262070740100002 4917966100002
#                    262070740100003 4917966100003
#                    262070740100004 4917966100004
#        
#        "batch file creation" shell script 1: read IMSI's & MSISDN's from a file
#                #!/bin/bash
#                ./sendspml.sh -t file -s batchHeader.xml > myBatchRequest.xml
#                while read line; do imsi=$(echo "$line" | gawk '{print $1}'); msisdn=$(echo "$line" | gawk '{print $2}'); ./sendspml.sh -t file -s -i $imsi -m $msisdn batchBody.xml >> myBatchRequest.xml; done < foo.txt
#                ./sendspml.sh -t file -s batchFooter.xml >> myBatchRequest.xml
#        
#                ==> batch file (myBatchRequest.xml):
#                    <spml:batchRequest
#                        onError="resume"
#                        processing="parallel"
#                        xmlns:spml="urn:siemens:names:prov:gw:SPML:2:0"
#                        xmlns:subscriber="urn:siemens:names:prov:gw:O2_SUBSCRIBER:1:0"
#                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#                        <version>O2_SUBSCRIBER_v10</version>
#                        <request xsi:type="spml:AddRequest">
#                            <version>O2_SUBSCRIBER_v10</version>
#                            <object xsi:type="subscriber:Subscriber">
#                                <auc>
#                                    <imsi>262070740100000</imsi>
#                                    <encKey>2ECB13F80D944850283BCE381B68BC0C</encKey>
#                                    <algoId>25</algoId>
#                                    <kdbId>61</kdbId>
#                                    <acsub>1</acsub>
#                                </auc>
#                            </object>
#                        </request>
#                        ... 
#                        <request xsi:type="spml:AddRequest">
#                            <version>O2_SUBSCRIBER_v10</version>
#                            <object xsi:type="subscriber:Subscriber">
#                                <auc>
#                                    <imsi>262070740100004</imsi>
#                                    <encKey>2ECB13F80D944850283BCE381B68BC0C</encKey>
#                                    <algoId>25</algoId>
#                                    <kdbId>61</kdbId>
#                                    <acsub>1</acsub>
#                                </auc>
#                            </object>
#                        </request>
#                    </spml:batchRequest>
#        
#        "batch file creation" shell script 2: loop through an continuous IMSI- & MSISDN-range 
#                #!/bin/bash
#                ./sendspml.sh -t file -s batchHeader.xml > myBatchRequest.xml; 
#                for i in $(seq 100000 100099); do ./sendspml.sh -t file -s -i 262078888$i -m 4917688$i batchBody.xml >> myBatchRequest.xml; done;
#                ./sendspml.sh -t file -s batchFooter.xml >> myBatchRequest.xml
#        
#                ==> batch file (myBatchRequest.xml):
#                    <spml:batchRequest
#                        onError="resume"
#                        processing="parallel"
#                        xmlns:spml="urn:siemens:names:prov:gw:SPML:2:0"
#                        xmlns:subscriber="urn:siemens:names:prov:gw:O2_SUBSCRIBER:1:0"
#                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
#                        <version>O2_SUBSCRIBER_v10</version>
#                        <request xsi:type="spml:AddRequest">
#                            <version>O2_SUBSCRIBER_v10</version>
#                            <object xsi:type="subscriber:Subscriber">
#                                <auc>
#                                    <imsi>262078888100000</imsi>
#                                    <encKey>2ECB13F80D944850283BCE381B68BC0C</encKey>
#                                    <algoId>25</algoId>
#                                    <kdbId>61</kdbId>
#                                    <acsub>1</acsub>
#                                </auc>
#                            </object>
#                        </request>
#                        ...
#                        <request xsi:type="spml:AddRequest">
#                            <version>O2_SUBSCRIBER_v10</version>
#                            <object xsi:type="subscriber:Subscriber">
#                                <auc>
#                                    <imsi>262078888100099</imsi>
#                                    <encKey>2ECB13F80D944850283BCE381B68BC0C</encKey>
#                                    <algoId>25</algoId>
#                                    <kdbId>61</kdbId>
#                                    <acsub>1</acsub>
#                                </auc>
#                            </object>
#                        </request>
#                    </spml:batchRequest>
#        
#        
###
# ToDo:
#
# Nice-To-Have:
# - imsi/msisdn-file support (e.g. file with 10 imsis: 1 imsi/line, send SPML_FILE for each imsi)
# - add  batchRequest mode
# - make XMLPARSERFILE parametrizable
# - improve the cmd-line parameter validation
#    -r && -i/-m/etc. NOK
#    -t file && -h/-p/-u NOK (warn)
#    -warn when a requiested tag is not found in the file
# - implement long options parsing (e.g. -cacert=cafile.crt) with "getopt"
###

#
# Usage(), Help() & Version() - Helper functions -- START
#
PROGNAME=`type $0 | awk '{print $3}'`         # search for executable on path
PROGDIR=`dirname $PROGNAME`                   # extract directory of program
PROGNAME=`basename $PROGNAME`                 # base name of program
# Fully qualify directory path 
#(remove relative components and symlinks)
ORIGDIR=`pwd`                                 # original directory (builtin)
PROGDIR=`cd $PROGDIR && pwd || echo $PROGDIR` # program directory

Usage() {                              # Usage line (from above) only
    # print Usage arguments (e.g. error message)
    echo >&2 "$PROGNAME:" "$@"
    sed >&2 -n "/^##ENDHELP##/q; /^#/!q; s/^#//; s/^ *Usage:  sendspml/Usage: $PROGNAME/g; 4,5 p" "$PROGDIR/$PROGNAME"
    exit 10;
}
Error() {
    Usage "### ERROR: " $@
    if [ -f $TMP_FILE ]; then
        rm -f $TMP_FILE
    fi
    exit 10;
}
Warn() {
    Usage "### WARNING: " $@
}

Help() {                              # Full documentation i.e. until line ##ENDHELP##
    sed >&2 -n "/^##ENDHELP##/q; /^#/!q; s/^#//; s/^ //; s/^ .*sendspml/ $PROGNAME/; 2,$ p" "$PROGDIR/$PROGNAME"
    exit 0;
}
Version() {                           # Print Version
    awk '/^# Version:/' "$PROGDIR/$PROGNAME" | awk '{printf "v%s %s\n",$3,$4}' >&2 
    exit 0;
}
#
# Usage(), Help() & Version() - Helper functions -- END
#

#
# D E F A U L T S
#
SUBS_IMSI="##imsi##"
SUBS_MSISDN="##msisdn##"
SUBS_IMSI2="##imsi2##"
SUBS_MSISDN2="##msisdn2##"
SUBS_UID="##uid##"
SUBS_UID2="##uid2##"
SCD_TEMPL="##scd##"
ANY_TAG="##any##"
# v1.4 changed - start
#TARGETSYSTEM=pgw
#TARGETSYSTEM=pga
# v1.5 changed - start
TARGETSYSTEM=pgas
# v1.5 changed - end
HOST_ADDRESS=localhost
#HOST_ADDRESS=pgwtb3-601
# v1.4 changed - end

PORT_HTTP=8081
PORT_HTTPS=443
PORT_PGA=9081
ADDSOAP=1
# OBSOLETE, v2.0 onwards using curl
        # v1.6
        # passed on to wget
        #  -d,  --debug               print lots of debugging information.
        #  -q,  --quiet               quiet (no output).
        #  -v,  --verbose             be verbose (this is the default).
        #  -nv, --no-verbose          turn off verboseness, without being quiet.
        #LOGLEVEL=q
# passed to curl
# -s silent = do not print the progress status
# -v verbose
LOGLEVEL=s
REPLACE=1
CA_CRTFILE=ca.crt
CLIENT_CRTFILE=cl.pem
CLIENT_KEYFILE=cl.key
SOAP_URN_PGW="/ProvisioningGateway/services/SPMLO2Subscriber10Service"
SOAP_URN_PGA="/"
PARSEXML=0
LOGSPMLREQ=0
XMLPARSERFILE=xmlparser.awk
# defaults for the ##version##, ##subsNs## tags
VERSIONSTRING="O2_SUBSCRIBER_v10"
SUBSNS="urn:siemens:names:prov:gw:O2_SUBSCRIBER:1:0"

#
# P a r s e   c o m m a n d   l i n e   o p t i o n s
#
# unused:
# cbn
while getopts q:w:e:rt:z:u:i:o:p:a:sdf:g:h:j:k:l:yxvm:? OPT; do
    case "$OPT" in
        i)
            SUBS_IMSI=$OPTARG
            ;;
        m)
            SUBS_MSISDN=$OPTARG
            ;;
        t)
            TARGETSYSTEM=$OPTARG
            ;;
        h)
            HOST_ADDRESS=$OPTARG
            ;;
        p)
            PORT=$OPTARG
            ;;
        s)
            ADDSOAP=0
            ;;
        d)
            # v1.6
            #LOGLEVEL=d
            LOGLEVEL=v
            ;;
        r)
            REPLACE=0
            ;;
        q)
            CA_CRTFILE=$OPTARG
            ;;
        w)
            CLIENT_CRTFILE=$OPTARG
            ;;
        e)
            CLIENT_KEYFILE=$OPTARG
            ;;
        v)
            Version
            ;;
        x)
            PARSEXML=1
            ;;
        u)
            SOAP_URN_PGW=$OPTARG
            ;;
        z)
            VERSIONSTRING=$OPTARG
            ;;
        o)
            SUBSNS=$OPTARG
            ;;
        f)
            SUBS_UID=$OPTARG
            ;;
        g)
            SUBS_UID2=$OPTARG
            ;;
        j)
            SUBS_IMSI2=$OPTARG
            ;;
        k)
            SUBS_MSISDN2=$OPTARG
            ;;
        l)
            SCD_TEMPL=$OPTARG
            ;;
        a)
            ANY_TAG=$OPTARG
            ;;
        y)
            LOGSPMLREQ=1
            ;;
            
        ?)
            Help
            ;;
        \?)
            # getopts issues an error message
            Usage
            ;;
    esac
done
## Remove the switches we parsed above.
shift `expr $OPTIND - 1`

## Validate argument count - we need at least one (SPML_FILE)
if [ $# -lt 1 ]; then
    Error "Not enough arguments"
fi

## Access additional arguments as usual through 
## variables $@, $*, $1, $2, etc. or using this loop:
#for PARAM; do
#    echo $PARAM
#done

# validate command line parameters
# commented out in v2.1 - prevents using replace only for version string, namespace etc.
#if [ $REPLACE -eq 1 ]; then
#    if [ $SUBS_IMSI = "##imsi##" ]; then
#        if [ $SUBS_MSISDN = "##msisdn##" ]; then
#            if [ $SUBS_UID = "##uid##" ]; then
#                Error "Imsi (-i), Msisdn (-m) and/or Uid (-f) must be provided"
#            fi
#        fi
#    fi
#fi


## verify SPML file existence
SPML_FILE=$1
if [ ! -f $SPML_FILE ];then
    Error "The file $SPML_FILE does not exist"
fi

## replace imsi & msisdn tags in the SPML_FILE if necessary
# use the PID in the tmp-file name to make the script "thread safe"
TMP_FILE=tmp.spml.$$
if [ $REPLACE -eq 1 ]; then
#    sed 's/##imsi##/$SUBS_IMSI/g' $SPML_FILE | sed 's/##msisdn##/$SUBS_MSISDN/g' > $TMP_FILE
    sed -e "s/##imsi##/$SUBS_IMSI/g" \
        -e "s/##msisdn##/$SUBS_MSISDN/g" \
        -e "s/##version##/$VERSIONSTRING/g" \
        -e "s/##subsNs##/$SUBSNS/g" \
        -e "s/##imsi2##/$SUBS_IMSI2/g" \
        -e "s/##msisdn2##/$SUBS_MSISDN2/g" \
        -e "s/##uid##/$SUBS_UID/g" \
        -e "s/##uid2##/$SUBS_UID2/g" \
        -e "s/##scd##/$SCD_TEMPL/g" \
        -e "s/##any##/$ANY_TAG/g" \
        $SPML_FILE > $TMP_FILE
elif [ $REPLACE -eq 0 ]; then
    cat $SPML_FILE > $TMP_FILE
fi

## Add SOAP headers to the SPML_FILE if necessary
SOAP_HEAD="<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><soapenv:Body>"
SOAP_TAIL="</soapenv:Body></soapenv:Envelope>"
if [ $ADDSOAP -eq 1 ]; then
    echo -e  "$SOAP_HEAD\n $(cat $TMP_FILE)\n$SOAP_TAIL" > $TMP_FILE
fi

## Verify that the SPML file does not have unreplaced "##<something>##" tags
TAG=$(egrep "##.*##" $TMP_FILE)
RESULT=$?
if [ $RESULT -eq 0 ]; then
    # Print warning, do not abort
    Warn  "Unreplaced tag(s) [$TAG] in SPML_FILE"
    # Print error and exit
    #Error "Unreplaced tag(s) [$TAG] in SPML_FILE"
fi

## Send output to XML parser if necessary
if [ $PARSEXML -eq 1 ]; then
    if [ ! -f $XMLPARSERFILE ]; then
        Error "The file $XMLPARSERFILE does not exist"
    else
        # create XML parser command
        # must be executed with eval, because of the piping in the string variable
        XMLPARSERCMD="| gawk -f $XMLPARSERFILE";
    fi
else
        XMLPARSERCMD="";
fi

# enables printing the SPML request before sending it
# "-t file" only prints the request, but does not send it 
if [ $LOGSPMLREQ -eq 1 ]; then
    eval cat $TMP_FILE $XMLPARSERCMD
fi

case "$TARGETSYSTEM" in

    pgw)
        #v1.6
        #eval wget -$LOGLEVEL -O - --header 'SOAPAction: ""' --post-file $TMP_FILE "http://$HOST_ADDRESS:${PORT:-$PORT_HTTP}$SOAP_URN_PGW" $XMLPARSERCMD
        #v2.0
        eval curl  -$LOGLEVEL      -H \'SOAPAction: \"\"\'          -d @$TMP_FILE         -X POST "http://$HOST_ADDRESS:${PORT:-$PORT_HTTP}$SOAP_URN_PGW" $XMLPARSERCMD
        ;;
    pgws)
        #v1.6
        #eval wget -$LOGLEVEL -O - --header 'SOAPAction: ""' --post-file $TMP_FILE --ca-certificate=$CA_CRTFILE --certificate=$CLIENT_CRTFILE --private-key=$CLIENT_KEYFILE  "https://$HOST_ADDRESS:${PORT:-$PORT_HTTPS}$SOAP_URN_PGW" $XMLPARSERCMD
        #v2.0
        eval curl  -$LOGLEVEL      -H \'SOAPAction: \"\"\'          -d @$TMP_FILE         --cacert $CA_CRTFILE         --cert $CLIENT_CRTFILE        --key $CLIENT_KEYFILE          -X POST "https://$HOST_ADDRESS:${PORT:-$PORT_HTTPS}$SOAP_URN_PGW" $XMLPARSERCMD
        ;;
    pga)
        #v1.6
        #eval wget -$LOGLEVEL -O - --header 'SOAPAction: ""' --post-file $TMP_FILE "http://$HOST_ADDRESS:${PORT:-$PORT_PGA}$SOAP_URN_PGA" $XMLPARSERCMD
        #v2.0
        eval curl  -$LOGLEVEL      -H \'SOAPAction: \"\"\'          -d @$TMP_FILE         -X POST "http://$HOST_ADDRESS:${PORT:-$PORT_PGA}$SOAP_URN_PGA" $XMLPARSERCMD
        ;;
    pgas)
        #v1.6
        #eval wget -$LOGLEVEL -O - --header 'SOAPAction: ""' --post-file $TMP_FILE --ca-certificate=$CA_CRTFILE --certificate=$CLIENT_CRTFILE --private-key=$CLIENT_KEYFILE  "https://$HOST_ADDRESS:${PORT:-$PORT_PGA}$SOAP_URN_PGA" $XMLPARSERCMD
        #v2.0
        eval curl  -$LOGLEVEL      -H \'SOAPAction: \"\"\'          -d @$TMP_FILE         --cacert $CA_CRTFILE         --cert $CLIENT_CRTFILE        --key $CLIENT_KEYFILE          -X POST "https://$HOST_ADDRESS:${PORT:-$PORT_PGA}$SOAP_URN_PGA" $XMLPARSERCMD
        ;;
    file)
        eval cat $TMP_FILE $XMLPARSERCMD
        ;;
    *)
        Error "Unknown Target System"
        # echo -Default- $SUBS_IMSI $SUBS_MSISDN $TARGETSYSTEM $HOST_ADDRESS $PORT_HTTP $PORT_HTTPS $PORT_PGA \
        #               $ADDSOAP $LOGLEVEL $REPLACE $CA_CRTFILE $CLIENT_CRTFILE $CLIENT_KEYFILE 
        ;;
esac

rm -f $TMP_FILE
    
# EOF
