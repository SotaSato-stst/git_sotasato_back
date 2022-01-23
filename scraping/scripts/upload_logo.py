from logging import getLogger
from urllib.parse import urljoin
from utility.public_storge import PublicStorage
from utility.request import get_soup, request_response
import pandas as pd

logger = getLogger(__name__)

# wikipediaから市町区村のマークを抜き出し、Cloud Storageに保存する
# 例 https://ja.wikipedia.org/wiki/%E5%8C%97%E6%B5%B7%E9%81%93%E3%81%AE%E5%B8%82%E7%94%BA%E6%9D%91%E7%AB%A0%E4%B8%80%E8%A6%A7
class UploadLogo:
    def city_logo(self):
        storage = PublicStorage()
        path = 'logo_images'
        prefectures = pd.read_csv('master_data/prefecture.csv')
        prefecture_names = prefectures['name'].to_numpy()

        for prefecture_name in prefecture_names:
            target_url = self.get_city_url(prefecture_name)
            soup = get_soup(target_url)
            tables = soup.find_all('table', class_='wikitable')
            for table in tables:
                trs = table.find_all('tr')
                del trs[0]

                for tr in trs:
                    tds = tr.find_all('td')
                    city_link = tds[0].find('a')
                    img = tds[1].find('img')

                    if city_link == None or img == None:
                        city_link = tds[1].find('a')
                        img = tds[2].find('img')
                    if city_link == None or img == None:
                        break

                    city_name = city_link.get_text()
                    src = img.get('src')
                    src_url = urljoin('https://ja.wikipedia.org', src)
                    content = request_response(src_url).content
                    storage.upload_after_delete(f'{path}/{city_name}.png', content)

    def get_city_url(self, prefecture_name) -> str:
        if prefecture_name == '東京都':
            return 'https://ja.wikipedia.org/wiki/%E6%9D%B1%E4%BA%AC%E9%83%BD%E3%81%AE%E5%8C%BA%E5%B8%82%E7%94%BA%E6%9D%91%E7%AB%A0%E4%B8%80%E8%A6%A7'
        else:
            return f'https://ja.wikipedia.org/wiki/{prefecture_name}%E3%81%AE%E5%B8%82%E7%94%BA%E6%9D%91%E7%AB%A0%E4%B8%80%E8%A6%A7'
