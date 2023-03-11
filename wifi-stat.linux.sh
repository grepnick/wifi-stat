#!/bin/bash

# A script to show wifi stats ifstat style on Linux.

echo -e "\n\nWireless statistics (press CTRL+C to stop):\n\n"

interface=$(ip route | awk '/^default/{print $5; exit}')

if [ -z "$interface" ]; then
  echo "Error: Could not determine active network interface"
  exit 1
fi

while true; do

  output=$(iw $interface station dump)
  freq_str=$(iwconfig $interface | grep "Frequency:" | awk '{print $2}' | sed 's/Frequency://g')
  channel_str=$(iw $interface info | grep "channel" | awk '{print $2}')
  station=$(echo "$output" | grep "Station" | awk '{print $2}')
  tx_bitrate=$(echo "$output" | grep "tx bitrate" | awk '{print $3}')
  rx_bitrate=$(echo "$output" | grep "rx bitrate" | awk '{print $3}')
  signal_dBm=$(echo "$output" | grep "signal:" | awk '{print $2}')
  signal_percentage=$(echo "(${signal_dBm} * -1 ) * 100 / 70" | bc)

  echo "Signal Strength: $signal_percentage% | TX Rate: $tx_bitrate Mbps | RX Rate: $rx_bitrate Mbps | Band: $freq_str | Channel: $channel_str | AP: $station"
  sleep 1
done
