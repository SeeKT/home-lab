#!/bin/bash
# Execute:
# ./port-mirror.sh #{CSVPATH} #{BRIDGE}

# Check Num
if [ $# -lt 3 ]; then
    echo "[ERROR] Execute script"
    echo "./port-mirror.sh #{CSVPATH} #{BRIDGE} #{VLAN}"
    exit 1
fi

# Check the existence of CSVPATH
CSVPATH=$1
if [ ! -e "$CSVPATH" ]; then
    echo "[ERROR] $CSVPATH does not exist."
    exit 1
fi

BRIDGE=$2
VLAN=$3

# Initialize COMMAND, ID, TARGET, and OUTPUT
COMMAND="ovs-vsctl -- set bridge $BRIDGE mirrors=@$BRIDGE-m --"
ID=""
TARGETDST="select-dst-port="
TARGETSRC="select-src-port="
OP=()

PROCESS_LINE() {
    local PORT=$1
    local FLAG=$2
    EACHID="--id=@$PORT get Port $PORT --"
    ID="${ID} ${EACHID}"
    if [[ "$FLAG" == *"target"* ]]; then
        EACHTARGET="@$PORT"
        TARGETDST="${TARGETDST}${EACHTARGET},"
        TARGETSRC="${TARGETSRC}${EACHTARGET},"
    fi
    if [[ "$FLAG" == *"output"* ]]; then
        EACHOUTPUT="$PORT"
        OP+=("$EACHOUTPUT")
    fi
}

# Read CSV
while IFS=, read -r PORT FLAG EXTRA
do
    # Check the num of field
    if [ -n "$EXTRA" ]; then
        echo "[ERROR] Too many fields in line: $PORT,$FLAG,$EXTRA"
        exit 1
    fi

    PROCESS_LINE "$PORT" "$FLAG"
done < "$CSVPATH"

MIRROR="--id=@$BRIDGE-m create Mirror name=$BRIDGE-mirror"
ID="${ID} ${MIRROR}"
TARGETDST=$(echo "$TARGETDST" | sed 's/,$//')
TARGETSRC=$(echo "$TARGETSRC" | sed 's/,$//')

NUMOP=${#OP[@]}
echo "Execute the following $NUMOP commands..."
for OUT in "${OP[@]}"
do
    OUTPUT="output-port=@$OUT"
    EXECUTION="${COMMAND} ${ID} ${TARGETDST} ${TARGETSRC} ${OUTPUT} output-vlan=$VLAN"
    EXECUTION=$(echo "$EXECUTION" | sed "s/@$BRIDGE-m/@$BRIDGE-m-$OUT/g")
    EXECUTION=$(echo "$EXECUTION" | sed "s/name=$BRIDGE-mirror/name=$BRIDGE-mirror-$OUT/g")
    echo "$EXECUTION"
    echo ""
done
