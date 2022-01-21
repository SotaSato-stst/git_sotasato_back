from logging import getLogger
import datetime
import pandas as pd
from pandas.core.frame import DataFrame
from utility.storage import Storage

logger = getLogger(__name__)

class CsvUploader:
    all_csv = 'all.csv'

    def __init__(self, filename: str):
        self.filename = filename # Cloud Storageに保存されるファイル名
        self.storage = Storage()
        t_delta = datetime.timedelta(hours=9)
        JST = datetime.timezone(t_delta, 'JST')
        self.execute_date = datetime.datetime.now(JST)
        self.uploaded_df = pd.read_csv(self.storage.download(self.all_csv))

    def upload_diff(self, current_df: DataFrame):
        uploaded_urls = self.uploaded_df['url'].to_numpy()
        current_urls = current_df['url'].to_numpy()

        # 未取得の新着情報のみを選別
        new_urls = [url for url in current_urls if url not in uploaded_urls]
        new_df = current_df[current_df['url'].isin(new_urls)]

        # Cloud Storageへ保存（Dailyのファイル）
        date_path = f'{self.execute_date.year}/{self.execute_date.month}/{self.execute_date.day}'
        self.storage.upload_after_delete(f'daily/{date_path}/{self.filename}', new_df.to_csv(index=False))

        # Slackへ新着通知
        for _, row in new_df.iterrows():
            self.slack.notify_new_content(row['text'], row['url'])


    def upload_all(self, current_df: DataFrame):
        uploaded_df = self.uploaded_df.append(current_df, ignore_index=True, sort=False)

        # 重複排除
        uploaded_df.drop_duplicates(subset='url', inplace=True)

        # Cloud Storageへ保存（累積のファイル）
        self.storage.upload_after_delete(self.all_csv, uploaded_df.to_csv(index=False))
