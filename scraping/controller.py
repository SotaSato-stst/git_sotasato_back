from datetime import datetime
from logging import getLogger
from scripts.table_logic import TableLogic
from scripts.new_list_logic import NewListLogic
from scripts.news_html_logic import NewHtmlLogic
import pandas as pd

logger = getLogger(__name__)

def debug(func):
    def wrapper(*args, **kwargs):
        func_name = func.__name__
        logger.info("Start " + func_name)
        rtn = func(*args, **kwargs)
        logger.info("End " + func_name)
        return rtn

    return wrapper


class Controller:
    def __init__(self, retry_max=3):
        self.exec_date = datetime.now().strftime("%Y/%m/%d")
        self.retry_max = retry_max

    def execute(self):
        keywords = ['支援策', '補助金', '助成金']
        mappings = [
            {
                'class_name': TableLogic,
                'urls': [
                    'https://www.pref.ibaraki.jp/shokorodo/sansei/20200408.html',
                ]
            },
            {
                'class_name': NewListLogic,
                'urls': [
                    'https://www.town.toin.lg.jp/new_list.php',
                    'https://www.city.aisai.lg.jp/new_list.php',
                    'http://www.town.agui.lg.jp/new_list.php',
                    'http://www.town.taketoyo.lg.jp/new_list.php',
                    'https://www.city.owase.lg.jp/new_list.php',
                    'https://www.town.kisosaki.lg.jp/new_list.php',
                    'https://www.town.toin.lg.jp/new_list.php',
                    'http://www.town.watarai.lg.jp/new_list.php',
                    'http://www.town.shiga-hino.lg.jp/new_list.php',
                    'https://www.town.taga.lg.jp/new_list.php',
                    'http://www.town.kumiyama.lg.jp/new_list.php',
                    'http://www.town.kasagi.lg.jp/new_list.php',
                    'http://www.town.ando.nara.jp/new_list.php',
                    'https://www.town.nara-kawanishi.lg.jp/new_list.php',
                    'http://www.town.takatori.nara.jp/new_list.php',
                    'http://www.town.koryo.nara.jp/new_list.php',
                    'http://www.town.oyodo.lg.jp/new_list.php',
                    'http://www.town.wakayama-inami.lg.jp/new_list.php',
                    'http://www.vill.ookuwa.nagano.jp/news_list.html',
                ]
            },
            {
                'class_name': NewHtmlLogic,
                'urls': [
                    'https://www.city.kitakami.iwate.jp/news.html',
                    'https://www.city.rikuzentakata.iwate.jp/news.html',
                    'https://www.town.shiwa.iwate.jp/news.html',
                    'https://www.town.nishiwaga.lg.jp/news.html',
                    'https://www.town.ichinohe.iwate.jp/news.html',
                    'https://www.kesennuma.miyagi.jp/news.html',
                    'https://www.kuriharacity.jp/news.html',
                    'https://www.town.shikama.miyagi.jp/news.html',
                    'https://www.town.kami.miyagi.jp/news.html',
                    'https://www.city.akita.lg.jp/news.html',
                    'https://www.city.oga.akita.jp/news.html',
                    'https://www.city.kazuno.akita.jp/news.html',
                    'https://www.city.katagami.lg.jp/news.html',
                    'https://www.town.hachirogata.akita.jp/news.html',
                    'https://www.city.nagai.yamagata.jp/news.html',
                    'https://www.town.asahi.yamagata.jp/news.html',
                    'https://www.town.kaneyama.yamagata.jp/news.html',
                    'https://www.town.funagata.yamagata.jp/news.html',
                    'https://www.town.takahata.yamagata.jp/news.html',
                    'https://www.city.soma.fukushima.jp/news.html',
                    'https://www.city.minamisoma.lg.jp/news.html',
                    'https://www.town.shimogo.fukushima.jp/news.html',
                    'https://www.town.shiranuka.lg.jp/news.html',
                ]
            }
        ]

        for mapping in mappings:
            klass = mapping['class_name']
            urls = mapping['urls']
            for url in urls:
                results = klass.execute(url, keywords)
                df = pd.DataFrame(results)
                logger.info(df)
