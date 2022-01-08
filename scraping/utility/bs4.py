import time
import requests
from bs4 import BeautifulSoup
from logging import getLogger

logger = getLogger(__name__)

def get_soup_by_url(target_url: str) -> BeautifulSoup:
    logger.info(f'try connect to {target_url}')
    time.sleep(1) # 瞬間大量アクセスを和らげて、サイト攻撃と思われないように
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36'
    header = {'User-Agent': user_agent}
    data = requests.get(target_url,headers=header, timeout=(3.0, 7.5))
    logger.info(f'status_code {data.status_code}')
    if data.status_code != 200:
        logger.error(f'status_code {data.status_code}')
    soup = BeautifulSoup(data.content, 'html.parser')
    return soup
