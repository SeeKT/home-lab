#!/bin/bash
# Execute:
# ./create-dir.sh <base dir> <dir name> <title>

# Check Num
if [ $# -lt 3 ]; then
    echo "[ERROR] Execute script"
    echo "./create-dir.sh <base dir> <dir name> <title>"
    exit 1
fi

# Check the existence of base dir
BASEDIR=$1
if [ ! -d "$BASEDIR" ]; then
    echo "[ERROR] $BASEDIR does not exist."
    exit 1
fi

# Create new dir
DIRNAME=$2
DIRPATH="$BASEDIR"/"$DIRNAME"
mkdir -p "$DIRPATH"/fig

# Create README
TITLE=$3
BASE=$(basename $BASEDIR)
README="$DIRPATH"/README.md
{
    echo "# $TITLE"
    echo ""
    echo "---"
    echo ""
    echo "[$BASE](../README.md)"
} >> $README
