from typing import List
from utility.bs4 import get_soup_by_url
from logging import getLogger

logger = getLogger(__name__)

class TableLogic:
  def execute(target_url: str, keywords: List) -> List:
      soup = get_soup_by_url(target_url)

      # ページ内のtable要素をすべて取ってくる
      tables = soup.find_all('table')
      if len(tables) > 0:
        logger.info('table要素あり')
      else:
        logger.error('table要素なし')

      results = []

      # 「支援策」が載っているtable要素のみを判定していく
      for table in tables:
        # tableの一行目にkeywordsが含まれれば、そのtableには支援策の情報が整理されていると判断
        text_in_first_row = table.find_all('td')[0].get_text()
        if any(keyword in text_in_first_row for keyword in keywords):
          # リンクのテキスト、URLを取得
          links = table.find_all('a')
          for link in links:
            text = link.get_text()
            url = link['href']
            results.append({'text': text, 'url': url})

      return results
