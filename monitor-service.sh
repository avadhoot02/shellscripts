#!/bin/bash

# List of service names to monitor and potentially restart
services=("x11vnc" "pulseaudio" "smbd")
# Function to start a service based on its name
path="/etc/rc.d/service/"

# Function to start a service based on its name
start_service() {
    local service_name="$1"
    case "$service_name" in
        "x11vnc")
            "$path"X11vnc start
            ;;
        "pulseaudio")
             "$path"PulseAudio start
            ;;
        "smbd")
              "$path"samba start

            ;;
        *)
            echo "Unknown service: $service_name"
            ;;
    esac
}

# while true; do
    for service_name in "${services[@]}"; do
        # Check if the service is running
        if pgrep -i "$service_name" > /dev/null; then
            echo "Service $service_name is running with PID: $(pgrep -o "$service_name")"
        else
           
            echo "Service $service_name is not running. Starting..."
            start_service "$service_name"
        fi
    done

    #  Sleep for a specified interval (e.g., 1 minute)
    # sleep 60
# done &

