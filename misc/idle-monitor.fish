
#!/usr/bin/env fish

# Set the idle time in seconds (300 seconds = 5 minutes)
set idle_time 300

function run_pipes_on_idle
    echo "Monitoring for inactivity..."
    
    while true
        # Wait for input with a timeout
        read -t $idle_time -P "Press any key to continue..."
        
        # Check if the read command timed out
        if test $status -eq 142
            # If no input, run the pipes.sh script
            clear
            ~/path/to/pipes.sh
            echo "Returning to terminal..."
        end
    end
end

# Run the function in the background
run_pipes_on_idle &
