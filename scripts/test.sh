#!/bin/bash

LOG=$1

echo "=== Statistics from $LOG ==="

# --- softflowd ---
echo "--- softflowd ---"

grep softflowd "$LOG" | awk '
{
  cpu+=$8
  if($8>max_cpu) max_cpu=$8

  mem+=$7
  if($7>max_mem) max_mem=$7

  count++
}
END {
  if(count){
    printf "Avg CPU: %.2f%%\n", cpu/count
    printf "Peak CPU: %.2f%%\n", max_cpu

    printf "Avg RSS: %.0f KB (%.1f MB)\n", mem/count, (mem/count)/1024
    printf "Peak RSS: %.0f KB (%.1f MB)\n", max_mem, max_mem/1024
  } else {
    print "No softflowd data found"
  }
}'

# --- hsflowd ---
echo "--- hsflowd ---"

grep hsflowd "$LOG" | awk '
{
  cpu+=$8
  if($8>max_cpu) max_cpu=$8

  mem+=$7
  if($7>max_mem) max_mem=$7

  count++
}
END {
  if(count){
    printf "Avg CPU: %.2f%%\n", cpu/count
    printf "Peak CPU: %.2f%%\n", max_cpu

    printf "Avg RSS: %.0f KB (%.1f MB)\n", mem/count, (mem/count)/1024
    printf "Peak RSS: %.0f KB (%.1f MB)\n", max_mem, max_mem/1024
  } else {
    print "No hsflowd data found"
  }
}'
