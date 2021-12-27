from logging import DEBUG, INFO, NOTSET, basicConfig, getLogger, StreamHandler

from controller import Controller

# ログ設定
stream_handler = StreamHandler()
stream_handler.setLevel(INFO)

basicConfig(
    level=NOTSET,
    format="%(asctime)s %(levelname)-7s %(message)s",
    handlers=[stream_handler],
)
logger = getLogger(__name__)


def main():
    controller = Controller()
    controller.execute()


if __name__ == "__main__":
    logger.info("[Notification] Scraping started")
    try:
        main()
        logger.info("[Notification] Scraping finished")
    except BaseException as e:
        logger.exception(e)
        logger.info("[Notification] Scraping failed")
