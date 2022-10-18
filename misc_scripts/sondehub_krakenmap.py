# Uses the SondeHub API to gather data about a sonde, and upload it to the krakenrf web mapper. It will show up on the map as a moving beacon. 
# Useful for testing tracking of a moving object
# Note that if the elevation angle between the antenna array and sonde is >45deg, direction finding  results will be poor. 

# Requires "pip install sondehub"

import sondehub
import requests

# The unique 8-digit Sonde identifier. Shown in the sondehub.org UI.
SONDE_ID = "U1140595"

API_SERVER = 'https://map.krakenrf.com:443'

# Your Kraken Pro Cloud username and password
login = {'username': 'username', 'password': 'password'}

x = requests.post(API_SERVER + '/login', json = login)
token = x.text

#print(x.text)

def on_message(message):
    beaconData = {'lat': message['lat'], 'lon': message['lon'], 'speed': 0, 'height': message['alt']}
    x = requests.post(API_SERVER + '/beacon', json = beaconData, headers = {'Authorization': token})
    #print(x.text)
    #print(message['lat'])
    #print(message['lon'])
    #print(message['alt'])

# Set sondes to whatever active sonde you want
test = sondehub.Stream(on_message=on_message, sondes=[SONDE_ID])

while 1:
    pass

