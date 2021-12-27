from datetime import datetime
from logging import getLogger
from scripts.table_logic import TableLogic
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
      urls = ['https://www.pref.ibaraki.jp/shokorodo/sansei/20200408.html']

      for url in urls:
        results = TableLogic.execute(url, keywords)
        df = pd.DataFrame(results)
        logger.info(df)
