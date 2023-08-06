# Uses an attached USB GPS and GPSd to get location data, and then upload it as a marker to the Kraken Cloud Mapper.

import gpsd
import time
import requests

gpsd.connect()
time.sleep(2)

API_SERVER = 'https://map.krakenrf.com:443'
login = {'email': 'email', 'password': 'password'}

while(1):
    try:
        x = requests.post(API_SERVER + '/login', json = login)
        break
    except:
        time.sleep(1)
        pass

token = x.text

while(1):
    try:
        packet = gpsd.get_current()
        lat, lon = packet.position()
        print("lat: " + str(lat))
        print("lon: " + str(lon))

        beaconData = {'lat': lat, 'lon': lon, 'speed': 0, 'height': 0}
        x = requests.post(API_SERVER + '/beacon', json = beaconData, headers = {'Authorization': token})

    except (gpsd.NoFixError, UserWarning):
        print("waiting for fix")
    time.sleep(1)
