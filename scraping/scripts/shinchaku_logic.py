from typing import List
from utility.bs4 import get_soup_by_url
from logging import getLogger

logger = getLogger(__name__)

class ShinchakuLogic :
    def execute(target_url: str, keywords: List, selector_name: str) -> List:
        soup = get_soup_by_url(target_url)
        new_htmls = soup.select(selector_name)

        if len(new_htmls) > 0:
            logger.info('new_htmls要素あり')
        else:
            logger.error('new_htmls要素なし')
        results = []
        for new_html in new_htmls:
            target_a = new_html.find_all('a')
            
            for link in target_a:
                text = link.get_text()
                if any(keyword in text for keyword in keywords):
                    url = link.get("href")
                    results.append({'text': text, 'url': url})

        return results