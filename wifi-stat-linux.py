import subprocess
import time

while True:
    # Run iwconfig command and capture its output
    output = subprocess.check_output(['iwconfig', 'wlp2s0'])

    # Decode output from bytes to string
    output = output.decode('utf-8')

    # Extract SSID, signal strength, transmit rate, receive rate, band, channel, and BSSID
    ssid = output.split('ESSID:"')[1].split('"')[0]
    signal_level = output.split('Signal level=')[1].split(' ')[0]
    signal_strength = int(signal_level) * -100 // 70  # Convert signal level to percentage and round down to an integer
    bit_rate = output.split('Bit Rate=')[1].split(' ')[0]
    band = output.split('Frequency:')[1].split(' ')[0]
    channel = output.split('Frequency:')[1].split(' ')[1].split('GHz')[0]
    bssid = output.split('Access Point: ')[1].split(' ')[0]

    # Print results
    print(f'SSID: {ssid} | Signal strength: {signal_strength}% | Bit rate: {bit_rate} Mbps | Band: {band} | Channel: {channel} | BSSID: {bssid}')

    # Wait for 1 second before running the script again
    time.sleep(1)
