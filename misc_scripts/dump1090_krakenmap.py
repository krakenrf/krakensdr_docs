# Uploads ADS-B data from dump1090 to the Kraken Pro Mapping server.
# Must run dump1090 with "--write-json" and have it write aircraft.json to the same directory as this script 
# e.g. ~/dump1090/package-bullseye/dump1090 --interactive --write-json .

import requests
import json
import time

API_SERVER = 'https://kraken.tynet.eu:8842'

# Your Kraken Pro Cloud username email and password
login = {'email': 'email', 'password': 'password'}

x = requests.post(API_SERVER + '/login', json = login)
token = x.text

print(x.text)

while True:
    f = open('aircraft.json')
    data = json.load(f)

    beaconData = []
    for aircraft in data['aircraft']:
        try:
            beaconData.append({'id': str(aircraft['flight']), 'lat': aircraft['lat'], 'lon': aircraft['lon'], 'speed': int(aircraft['gs']), 'height': aircraft['alt_geom'], 'heading': aircraft['mag_heading']})

            #print (aircraft['flight'])
            #print (aircraft['lat'])
            #print (aircraft['lon'])
            #print (aircraft['gs'])
            #print (aircraft['alt_geom'])

        except:
            #print('excepted')
            pass # probably lat/lon missing

    x = requests.post(API_SERVER + '/beacons', json = beaconData, headers = {'Authorization': token})
    time.sleep(1)
