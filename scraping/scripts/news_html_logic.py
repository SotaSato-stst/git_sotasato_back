from typing import List, Text
from utility.bs4 import get_soup_by_url
from logging import getLogger

logger = getLogger(__name__)

# https://www.town.xxx.jp/new_html.php という形式のサイト
class NewHtmlLogic:
  def execute(target_url: str, keywords: List) -> List:
      soup = get_soup_by_url(target_url)
      new_htmls = soup.select('span.text')
      results=[]
      for new_html in new_htmls:
          target_a=new_html.find_all('a')
          for link in target_a:
              text=link.get_text()
              if any(keyword in text for keyword in keywords):
                url=link.get("href")
                results.append({'text': text, 'url': url})
      if len(target_a) > 0:
        logger.info('target_a要素あり')
      else:
        logger.error('target_a要素なし')
        
      return results