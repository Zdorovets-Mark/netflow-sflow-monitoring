#!/bin/bash
LOG=$1
echo "=== Statistics from $LOG ==="

# Строки CPU: 11 полей, %CPU на 9-м месте
grep -v 'UID' "$LOG" | awk 'NF==11 && !/^$/ {sum+=$9; count++; if($9>max) max=$9} END {if(count) printf "Avg CPU: %.2f%%\nPeak CPU: %.2f%%\n", sum/count, max; else print "No CPU data"}'

# Строки памяти: 10 полей, RSS на 8-м месте
grep -v 'UID' "$LOG" | awk 'NF==10 && !/^$/ {sum+=$8; count++; if($8>max_rss) max_rss=$8} END {if(count) printf "Avg RSS: %.0f KB (%.1f MB)\nPeak RSS: %.0f KB (%.1f MB)\n", sum/count, (sum/count)/1024, max_rss, max_rss/1024; else print "No memory data"}'
