import requests
from bs4 import BeautifulSoup
import pandas as pd
import os
url = r"https://www.corrections.govt.nz/resources/statistics/quarterly_prison_statistics"
response = requests.get(url)
if response.status_code != 200:
    print("Unable to open the webpage")
    exit()

scrape = BeautifulSoup(response.content, 'html.parser')

div = scrape.find('div', {'class': 'test'}) 
link1 = div.find('a')["href"]
print(link1)

response = requests.get(link1)
scrape = BeautifulSoup(response.content, 'html.parser')
a_tag = scrape.find('a', href = lambda x: x and "Quarterly" in x)
link2 = a_tag["href"] 
print(link2)

filename = os.path.basename(link2)
response = requests.get(link2)
with open(filename, "wb") as f:
    f.write(response.content)