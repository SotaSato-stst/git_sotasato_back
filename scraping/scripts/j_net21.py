from typing import List
from logging import getLogger
import time
from urllib.parse import urljoin
from utility.request import get_soup

logger = getLogger(__name__)

class JNet21:
    base_url = 'https://j-net21.smrj.go.jp'
    url = 'https://j-net21.smrj.go.jp/snavi/support?genre1=&genre2=&freeWord=&order=DESC&perPage=100&page=1'

    def execute(self) -> List:
        # URLのパラメータ（perPageやpageなど）を指定可能
        results = []

        soup = get_soup(self.url)
        list = soup.find('ul', class_='HL-resultList')
        detail_links = list.find_all('a')

        for detail_link in detail_links:
            time.sleep(1) # 一応間を開けて、瞬間大量アクセスを避けている
            source_url = urljoin(self.base_url, detail_link.get('href'))

            # 詳細ページへ遷移
            detail_soup = get_soup(source_url)

            # 載っている外部リンクが情報元なのでそちらを取得
            target_links = detail_soup.find('ul', class_='listLink').find_all('a')

            for target_link in target_links:
                dic = {
                    'target_url': self.url,
                    'text': ''.join(target_link.get_text().split()),
                    'url': target_link.get('href')
                }
                results.append(dic)

        return results
