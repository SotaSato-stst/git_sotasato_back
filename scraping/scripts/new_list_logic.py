from typing import List
from utility.bs4 import get_soup_by_url
from logging import getLogger

logger = getLogger(__name__)

# https://www.town.xxx.jp/new_list.php という形式のサイト
class NewListLogic:
  def execute(target_url: str, keywords: List) -> List:
      soup = get_soup_by_url(target_url)
      new_lists = soup.select('div.new_lst')
      if len(new_lists) > 0:
        logger.info('new_list要素あり')
      else:
        logger.error('new_list要素なし')

      results = []
      for new_list in new_lists:
        links = new_list.find_all('a')
        for link in links:
          text = link.get_text()
          if any(keyword in text for keyword in keywords):
            url = link['href']
            results.append({'text': text, 'url': url})

      return results
