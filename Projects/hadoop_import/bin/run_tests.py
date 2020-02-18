#!/usr/bin/env python
import argparse
import os
import sys

from teamcity import is_running_under_teamcity
from teamcity.unittestpy import TeamcityTestRunner
from unittest import defaultTestLoader as loader, TextTestRunner


def main(file_pattern):
    root_dir = os.path.dirname(os.path.abspath(__file__)) + '/../'
    sys.path.insert(0, root_dir)

    suite = loader.discover(root_dir, file_pattern)

    if is_running_under_teamcity():
        print('Running tests with TeamcityTestRunner')
        runner = TeamcityTestRunner()
    else:
        print('Running tests with TextTestRunner')
        runner = TextTestRunner()

    ret = not runner.run(suite).wasSuccessful()
    sys.exit(ret)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(
        description="Run tests discovering a file pattern")
    parser.add_argument("--file_pattern", default="test*.py", help="The file pattern")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())

