#!/bin/bash

dump_zone() {
    local domain=$1
    local outfile=$2

    drill CDS "$domain" @10.0.38.10 | grep "^$domain." | sed 's/CDS/DS/' > "$outfile"
}


mkdir -p /home/teacher

dump_zone sraierv.una /home/teacher/una.ds
dump_zone 38.0.10.in-addr.arpa /home/teacher/ptr.ds
dump_zone 138.0.10.in-addr.arpa /home/teacher/ptr2.ds

chmod -R 0644 /home/teacher

