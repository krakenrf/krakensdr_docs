
import requests
import json
import time

API_SERVER = 'https://kraken.tynet.eu:8842'

# Your Kraken Pro Cloud username and password
login = {'username': 'username', 'password': 'password'}

x = requests.post(API_SERVER + '/login', json = login)
token = x.text

print(x.text)

#beaconData = [{'id': "e80450", 'lat': -37.236809, 'lon': 171.337698, 'speed': 443, 'height': 37925, 'heading': 180},
#              {'id': "e80460", 'lat': -37.036809, 'lon': 171.137698, 'speed': 443, 'height': 37925, 'heading': 180}]
#x = requests.post(API_SERVER + '/beacons', json = beaconData, headers = {'Authorization': token})

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
