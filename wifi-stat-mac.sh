#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "Please run the script with the sudo command to see the BSSID (AP MAC Address)."
fi

echo -e "\n\nWireless statistics (press CTRL+C to stop):\n\n"

while true
do

    airport_output=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)

    # extract SSID and BSSID values
    ssid=$(echo "$airport_output" | grep -E "^ +SSID: " | awk '{print $2}')
    bssid=$(echo "$airport_output" | grep -E "^ +BSSID: " | awk '{print $2}')
    rssi=$(echo "$airport_output" | grep -E "^ +agrCtlRSSI: " | awk '{print $2}')
    noise=$(echo "$airport_output" | grep -E "^ +agrCtlNoise: " | awk '{print $2}')
    channel=$(echo "$airport_output" | grep -E "^ +channel: " | awk '{print $2}')
    txrate=$(echo "$airport_output" | grep -E "^ +lastTxRate: " | awk '{print $2}')
    maxrate=$(echo "$airport_output" | grep -E "^ +maxRate: " | awk '{print $2}')
    rssi_pct=$(awk "BEGIN {printf \"%.0f\",(($rssi + 100) * 100) / 70}")
    noise_pct=$(awk "BEGIN {printf \"%.0f\",(($noise + 100) * 100) / 70}")

    # set wirelessBand based on channel value
    if [[ $channel -ge 1 && $channel -le 11 ]]; then
        wirelessBand="2.4 GHz"
    else
        wirelessBand="5 GHz"
    fi

    echo "Signal Strength: $rssi_pct% | Noise: $noise_pct% | TX Rate: $txrate/$maxrate Mbps | Band: $wirelessBand | Channel: $channel | AP: $bssid"
    sleep 1
done
