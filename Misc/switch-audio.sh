#!/usr/bin/env bash

# This script toggles between available PulseAudio/Pipewire-Pulse sinks (audio outputs).
# It sets the next sink as the default and moves all current audio streams to it.

# Get list of sink names
sinks=($(pactl list short sinks | awk '{print $2}'))

# Get the current default sink
current_sink=$(pactl get-default-sink)

# Find the index of the current sink in the array
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current_sink" ]]; then
        current_index=$i
        break
    fi
done

# Compute the next sink index (loop back if at end)
next_index=$(( (current_index + 1) % ${#sinks[@]} ))
next_sink="${sinks[$next_index]}"

# Set the new default sink
pactl set-default-sink "$next_sink"

# Move all currently playing streams to the new sink
for input in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$input" "$next_sink"
done

# Show feedback
notify-send -u low -t 1000 -a "switch-audio" "🔊 Audio Output Switched" "Now using: $next_sink" 2>/dev/null || echo "Now using: $next_sink"
