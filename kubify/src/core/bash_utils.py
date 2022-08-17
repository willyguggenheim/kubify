from subprocess import Popen, PIPE, STDOUT

import logging

_logger = logging.getLogger()


def log_subprocess_output(name, pipe):
    for line in iter(pipe.readline, b""):  # b'\n'-separated lines
        logging.debug(
            f"{name}: {line}",
        )


def subprocess_run(name, command):
    process = Popen(command, stdout=PIPE, stderr=STDOUT, shell=True)
    with process.stdout:
        log_subprocess_output(name, process.stdout)
    exitcode = process.wait()
    return exitcode
