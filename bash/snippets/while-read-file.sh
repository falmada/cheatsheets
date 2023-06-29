#!/bin/bash

OUTPUT_FILE="/tmp/myfile-$$"

cat <<EOF >${OUTPUT_FILE}
multi
line
text
EOF

while read LINE
do
	echo "== ${LINE} =="
done < "${OUTPUT_FILE}"