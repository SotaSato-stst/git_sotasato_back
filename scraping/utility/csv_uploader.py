from io import StringIO
from logging import getLogger
import datetime
from pandas.core.frame import DataFrame
from utility.storage import Storage

logger = getLogger(__name__)

class CsvUploader:
    all_csv_filename = 'all.csv'

    def __init__(self, filename: str):
        self.filename = filename # Cloud Storageに保存されるファイル名
        self.storage = Storage()
        t_delta = datetime.timedelta(hours=9)
        JST = datetime.timezone(t_delta, 'JST')
        self.execute_date = datetime.datetime.now(JST)


    def upload_daily(self, df: DataFrame):
        # Cloud Storageへ保存（Dailyのファイル）
        date_path = f'{self.execute_date.year}/{self.execute_date.month}/{self.execute_date.day}'
        self.storage.upload_after_delete(f'daily/{date_path}/{self.filename}', df.to_csv(index=False))


    def upload_all(self, df: DataFrame):
        # Cloud Storageへ保存（累積のファイル）
        self.storage.upload_after_delete(self.all_csv_filename, df.to_csv(index=False))


    def all_csv(self) -> StringIO:
        return self.storage.download(self.all_csv_filename)
