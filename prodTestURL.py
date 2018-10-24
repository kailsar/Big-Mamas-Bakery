import boto3
import urllib
from jinja2 import Environment, FileSystemLoader

client = boto3.client('elbv2', region_name='eu-west-1')
response = client.describe_load_balancers(
    Names=[
        'stage-alb',
    ],
)


balancers = response['LoadBalancers']
for balancer in balancers:
    dnsName = balancer['DNSName']
print("http://" + dnsName)
try:
    html = urllib.urlopen("http://" + dnsName)
except:
    print('test failed')
    exit(1)
print(html.getcode())

if html.getcode() != 200:
    exit(1)

