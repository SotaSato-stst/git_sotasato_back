import requests
from bs4 import BeautifulSoup
from logging import getLogger

logger = getLogger(__name__)

class NotFoundException(Exception):
    pass

class RequestException(Exception):
    pass

def get_soup_by_url(target_url: str) -> BeautifulSoup:
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36'
    header = {'User-Agent': user_agent}

    try:
        data = requests.get(target_url,headers=header, timeout=(3.0, 7.5))
    except requests.RequestException as e:
        logger.error(f'Faild to get {target_url}')
        logger.error(e)
        raise RequestException(f'Request failed: {e}')

    if data.status_code == 200:
        logger.info(f'{data.status_code} {target_url}')
    else:
        logger.error(f'{data.status_code} {target_url}')
        raise NotFoundException(f'URL was not found {data.status_code} {target_url}')

    soup = BeautifulSoup(data.content, 'html.parser')
    return soup
