from typing import List
from urllib.parse import urljoin
from utility.request import get_soup
from logging import getLogger

logger = getLogger(__name__)

class SelectorNameException(Exception):
    pass


class Shinchaku :
    def execute(target_url: str, keywords: List, selector_name: str) -> List:
        soup = get_soup(target_url)
        new_htmls = soup.select(selector_name)

        if len(new_htmls) < 0:
            error_message = f'Not Found selector_name {selector_name} in url {target_url}'
            logger.warn(error_message)
            raise SelectorNameException(error_message)

        results = []
        for new_html in new_htmls:
            target_a = new_html.find_all('a')
            
            for link in target_a:
                text: str = link.get_text()

                if any(keyword in text for keyword in keywords):
                    url = link.get("href")
                    information_url = urljoin(target_url, url) # static pathを取得したいので
                    dic = {
                        'target_url': target_url,
                        'text': ''.join(text.split()),
                        'url': information_url
                    }
                    results.append(dic)

        return results
