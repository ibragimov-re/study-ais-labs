#!/bin/bash

# LAB 5 (eBPF)
# ====================================

#!/bin/bash

# Create bpftrace script to monitor process spawn statistics
cat > /tmp/spawn_stats.bt <<'EOF'
// Subscribe to kernel tracepoint for fork/vfork/clone/posix_spawn events
tracepoint:sched:sched_process_fork
{
    // Add parent process info to the map with incremented count on each spawn event
    @spawn[args->parent_pid, str(args->parent_comm)] += 1;
}

// Do when the script starts
BEGIN
{
    printf("Starting process spawn statistics monitoring...\n");
}

// Do whem interval elapses
interval:s:600
{
    printf("\n===== 10-minute spawn stats =====\n");
    print(@spawn);
    clear(@spawn);
    exit();
}
EOF

# Run the bpftrace script
bpftrace /tmp/spawn_stats.bt
