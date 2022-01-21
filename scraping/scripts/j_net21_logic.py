from typing import List
from logging import getLogger
# from selenium import webdriver
# from selenium.webdriver.support import select
# from selenium.webdriver.common.by import By
# from selenium.webdriver.support.ui import WebDriverWait
# import chromedriver_binary
import time
from urllib.parse import urljoin
from utility.bs4 import get_soup_by_url

logger = getLogger(__name__)

class JNet21Logic :
    def __init__(self) -> None:
        self.page_numbers = [1]

    def execute(self) -> List:
        url = 'https://j-net21.smrj.go.jp/snavi/support?genre1=&genre2=&freeWord=&order=DESC&perPage=100&page=1'
        results = []

        soup = get_soup_by_url(url)
        list = soup.find('ul', class_='HL-resultList')
        detail_links = list.find_all('a')

        for detail_link in detail_links:
            time.sleep(1)
            source_url = urljoin('https://j-net21.smrj.go.jp', detail_link.get('href'))
            detail_soup = get_soup_by_url(source_url)
            target_links = detail_soup.find('ul', class_='listLink').find_all('a')

            for target_link in target_links:
                dic = {
                    'target_url': url,
                    'text': ''.join(target_link.get_text().split()),
                    'url': target_link.get('href')
                }
                results.append(dic)

        return results
