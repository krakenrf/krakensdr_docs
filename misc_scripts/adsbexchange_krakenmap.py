# Uses the ADS-B Exchange RapidAPI service to get live data from ADS-B exchange
# Note RapidAPI requires a subscription at $10 a month, and you only get 10,000 requests per month.
# You may wish to limit your 

RAPID_API_KEY: "MY_RAPID_API_KEY"

KRAKEN_PRO_USERNAME: "username"
KRAKEN_PRO_PASSWORD: "password"

# You may wish to limit your request rate more to avoid going over the limit of your account
REQUEST_RATE = 10

KRAKEN_RPO_API_SERVER = 'https://kraken.tynet.eu:8842'


import requests
import time

# Enter your RapidAPI URL here
url = "https://adsbexchange-com1.p.rapidapi.com/v2/lat/-36.2/lon/174.3/dist/250/"

headers = {
        "X-RapidAPI-Key": RAPID_API_KEY,
        "X-RapidAPI-Host": "adsbexchange-com1.p.rapidapi.com"
}

#response = requests.request("GET", url, headers=headers)
#print(response.text)


# Your Kraken Pro Cloud username and password
login = {'username': KRAKEN_PRO_USERNAME, 'password': KRAKEN_PRO_PASSWORD}

x = requests.post(KRAKEN_RPO_API_SERVER + '/login', json = login)
token = x.text
print(x.text)

run = True
while run:
    response = requests.request("GET", url, headers=headers)
    data = response.json()

    beaconData = []
    for aircraft in data['ac']:
        try:
            beaconData.append({'id': str(aircraft['flight']), 'lat': aircraft['lat'], 'lon': aircraft['lon'], 'speed': int(aircraft['gs']), 'height': aircraft['alt_geom'], 'heading': aircraft['track']})

            #print (aircraft['flight'])
            #print (aircraft['lat'])
            #print (aircraft['lon'])
            #print (aircraft['gs'])
            #print (aircraft['alt_geom'])
        except:
            #print('excepted')
            pass # probably lat/lon missing

    x = requests.post(API_SERVER + '/beacons', json = beaconData, headers = {'Authorization': token})
    #print(x)
    time.sleep(REQUEST_RATE) 
