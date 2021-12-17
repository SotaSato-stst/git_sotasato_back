import time
import requests
from bs4 import BeautifulSoup

def get_soup_by_url(target_url: str) -> BeautifulSoup:
    print(f'try connect to {target_url}')
    time.sleep(1) # 瞬間大量アクセスを和らげて、サイト攻撃と思われないように
    data = requests.get(target_url, timeout=(3.0, 7.5))
    print(f'status_code {data.status_code}')
    soup = BeautifulSoup(data.content, 'html.parser')
    return soup

keywords = ['支援策', '補助金', '助成金']

def exec_scraping_for_table(target_url: str):
    soup = get_soup_by_url(target_url)

    # ページ内のtable要素をすべて取ってくる
    tables = soup.find_all('table')
    if len(tables) > 0:
      print('table要素あり')
    else:
      print('table要素なし')

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
      else:
        print(f'支援策が掲載されていないtable: {text_in_first_row}')

    print(results)

exec_scraping_for_table('https://www.pref.ibaraki.jp/shokorodo/sansei/20200408.html')
