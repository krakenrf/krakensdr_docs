import requests
import json
import time

# The unique ICAO ID of the aircraft in HEX. Ensure it is LOWERCASE.
HEX_ID = "c822ed"

API_SERVER = 'https://map.krakenrf.com:443'

# Your Kraken Pro Cloud username and password
login = {'username': 'username', 'password': 'password'}

x = requests.post(API_SERVER + '/login', json = login)
token = x.text

print(x.text)

while True:
    f = open('aircraft.json')
    data = json.load(f)

    for aircraft in data['aircraft']:
#        print(aircraft['hex'])
        if aircraft['hex'] == HEX_ID:
            try:
                beaconData = {'lat': aircraft['lat'], 'lon': aircraft['lon'], 'speed': aircraft['gs'], 'height': aircraft['alt_geom']}
                x = requests.post(API_SERVER + '/beacon', json = beaconData, headers = {'Authorization': token})

                print (aircraft['lat'])
                print (aircraft['lon'])
            except:
                print('EXCEPTION: Probably out of range')
                pass # 

    time.sleep(1)
