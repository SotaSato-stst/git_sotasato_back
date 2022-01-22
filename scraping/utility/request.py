import requests
from requests import Response
from bs4 import BeautifulSoup
from logging import getLogger

logger = getLogger(__name__)

class NotFoundException(Exception):
    pass


class RequestException(Exception):
    pass

USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36'

def get_soup(url: str) -> BeautifulSoup:
    response = request_response(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    return soup


def request_response(url: str) -> Response:
    header = {'User-Agent': USER_AGENT}

    try:
        response = requests.get(url,headers=header, timeout=(3.0, 7.5))
    except requests.RequestException as e:
        logger.error(f'Faild to get {url}')
        logger.error(e)
        raise RequestException(f'Request failed: {e}')

    if response.status_code == 200:
        logger.info(f'{response.status_code} {url}')
    else:
        logger.warn(f'{response.status_code} {url}')
        raise NotFoundException(f'URL was not found {response.status_code} {url}')

    return response
