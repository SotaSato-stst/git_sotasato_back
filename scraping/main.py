import base64
import os
from logging import INFO, NOTSET, basicConfig, getLogger, StreamHandler
from scripts.controller import Controller
from dotenv import load_dotenv

load_dotenv()

# ログ設定
stream_handler = StreamHandler()
stream_handler.setLevel(INFO)

if os.getenv('RUNNING_ENV') == 'development':
    log_format = "%(asctime)s %(levelname)-7s %(message)s"
else:
    log_format = "%(levelname)-7s %(message)s"

basicConfig(
    level=NOTSET,
    format=log_format,
    handlers=[stream_handler],
)
logger = getLogger(__name__)


def main():
    logger.info('[DEBUG] Scraping Started')
    try:
        controller = Controller()
        controller.execute()
        logger.info('[DEBUG] Scraping Finished')
    except BaseException as e:
        logger.exception(e)
        logger.error('[DEBUG] Scraping Failed')


def cloud_function(event, context):
    if 'data' in event:
        csv_filename = base64.b64decode(event['data']).decode('utf-8')
        controller = Controller(
            csv_filename,
            context.event_id
        )

        try:
            controller.notify_start()
            controller.execute()
        except BaseException as e:
            logger.exception(e)
            controller.notify_error(e)

    else:
        logger.error('Message Not Found')

    controller.notify_finish()

if __name__ == "__main__":
    main()
