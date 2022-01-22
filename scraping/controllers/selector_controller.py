from typing import List
from logging import getLogger
import pandas as pd
from scripts.shinchaku_logic import ShinchakuLogic
from utility.data_operater import DataOperater
from utility.csv_uploader import CsvUploader

logger = getLogger(__name__)

# 解説:
# 雑多な新着情報の一覧から、補助金の情報だけを抜き出すController
# 主に地方自治体サイトのお知らせ欄をスクレイピングしている

class SelectorController:
    keywords = ['補助金', '助成金' ,'支援策', '給付金','支援金']

    def __init__(self, csv_filename: str='urls-0.csv'):
        self.csv_filename = csv_filename
        self.csv_uploader = CsvUploader(csv_filename)
        base_csv = self.csv_uploader.all_csv()
        self.data_operater = DataOperater(base_csv)


    def execute(self) -> List:
        logger.info(f'Scraping Started with URLs in {self.csv_filename}')

        data = []
        warnings = []
        csv = pd.read_csv(f'master_data/{self.csv_filename}')

        for _, row in csv.iterrows():
            selector_name = row['selector_name']
            url = row['url']

            try:
                results = ShinchakuLogic.execute(url, self.keywords, selector_name)
                data.extend(results)
            except Exception as e:
                logger.warn(e)
                warnings.append(f'{e}')

        if len(data) > 0:
            df = pd.DataFrame(data)

            new_df = self.data_operater.filter_new_records(df)
            all_df = self.data_operater.merge_to_all(df)

            self.csv_uploader.upload_daily(new_df)
            self.csv_uploader.upload_all(all_df)
        else:
            message = f'No results {self.csv_filename}'
            logger.warn(message)
            warnings.append(message)

        return warnings
