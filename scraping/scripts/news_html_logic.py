from typing import List
from utility.bs4 import get_soup_by_url
from logging import getLogger

logger = getLogger(__name__)

# https://www.town.xxx.jp/new_html.php という形式のサイト
class NewHtmlLogic:
  def execute(target_url: str, keywords: List) -> List:
      soup = get_soup_by_url(target_url)
      new_htmls = soup.select('a.newPageLink')
      if len(new_htmls) > 0:
        logger.info('new_html要素あり')
      else:
        logger.error('new_html要素なし')

      results = []
      for new_html in new_htmls:
        links = new_html.find_all('a')
        for link in links:
          text = link.get_text()
          if any(keyword in text for keyword in keywords):
            url = link['href']
          results.append({'text': text, 'url': url})

      return results
