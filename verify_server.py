import urllib.request
import json

try:
    r = urllib.request.urlopen('http://localhost:5000/api/dashboard')
    print(f"Status: {r.status}")
    d = json.loads(r.read())
    print(f"Products: {d['summary']['total_products']}")
    print(f"Alerts: {d['summary']['alert_count']}")
except Exception as e:
    print(f"Error: {e}")
