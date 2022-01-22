from typing import List
from logging import getLogger
import pandas as pd
from scripts.j_net21_logic import JNet21Logic
from scripts.mirasapo_logic import MirasapoLogic
from utility.data_operater import DataOperater
from utility.csv_uploader import CsvUploader

logger = getLogger(__name__)

class CurationController:
    def __init__(self, event_id: str=''):
        self.event_id = event_id
        self.csv_uploader = CsvUploader('curation-site.csv')
        base_csv = self.csv_uploader.all_csv()
        self.data_operater = DataOperater(base_csv)


    def execute(self) -> List:
        data = []
        warnings = []

        try:
            data.extend(JNet21Logic().execute())
        except Exception as e:
            logger.warn(e)
            warnings.append(e)

        try:
            data.extend(MirasapoLogic().execute())
        except Exception as e:
            logger.warn(e)
            warnings.append(f'{e}')

        df = pd.DataFrame(data)

        new_df = self.data_operater.filter_new_records(df)
        all_f = self.data_operater.merge_to_all(df)

        self.csv_uploader.upload_daily(new_df)
        self.csv_uploader.upload_all(all_f)

        return warnings
