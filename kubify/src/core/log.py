"""Main module."""

import logging
from logging import config

import kubify.src.core.app_constants as app_constants

# TODO fix filename in file handler
log_path = f"{app_constants.log_path}/kubify.log"
log_config = {
    "version": 1,
    "root": {"handlers": ["console", "file"], "level": "DEBUG"},
    "handlers": {
        "console": {
            "formatter": "std_out",
            "class": "logging.StreamHandler",
            "level": "DEBUG",
        },
        "file": {
            "formatter": "std_out",
            "class": "logging.FileHandler",
            "level": "INFO",
            "filename": "kubify.log",
        },
    },
    "formatters": {
        "std_out": {
            "format": """%(asctime)s : %(levelname)s : %(module)s : %(funcName)s : %(lineno)d
                : (Process Details : (%(process)d, %(processName)s), 
                Thread Details : (%(thread)d, %(threadName)s))\nLog 
                : %(message)s""",
            "datefmt": "%d-%m-%Y %I:%M:%S",
        }
    },
}

logging.config.dictConfig(log_config)
_logger = logging.getLogger()


def setup_logger():
    """_summary_"""
    _logger.info("start logging")
