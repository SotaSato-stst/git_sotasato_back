import time
import requests
from bs4 import BeautifulSoup
from logging import getLogger

logger = getLogger(__name__)

def get_soup_by_url(target_url: str) -> BeautifulSoup:
    logger.info(f'try connect to {target_url}')
    time.sleep(1) # 瞬間大量アクセスを和らげて、サイト攻撃と思われないように
    data = requests.get(target_url, timeout=(3.0, 7.5))
    logger.info(f'status_code {data.status_code}')
    if data.status_code != 200:
        logger.error(f'status_code {data.status_code}')
    soup = BeautifulSoup(data.content, 'html.parser')
    return soup
