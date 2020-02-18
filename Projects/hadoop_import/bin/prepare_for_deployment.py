#!/usr/bin/env python

import argparse
import os

from os import listdir
from subprocess import Popen, PIPE

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROJECT_CONFIG_FOLDER = os.path.join(PROJECT_ROOT, "config")
HADOOPIMPORT_FOLDER = os.path.join(PROJECT_ROOT, "hadoopimport")


def execute_shell_command(cmd):
    p = Popen(cmd, stdin=PIPE, stdout=PIPE, shell=True)
    output, err = p.communicate()
    return output, err


def print_output(out, err):
    if out is not None and out != '':
        print(out)

    if err is not None and out != '':
        print(err)


def copy_env_file(src_file, target_folder):
    src_file_name, src_file_ext = os.path.splitext(os.path.basename(src_file))
    target_file = os.path.join(target_folder, src_file_name)

    copy_cmd = "cp %s %s" % (src_file, target_file)
    out, err = execute_shell_command(copy_cmd)
    print_output(out, err)


def is_env_file(env_name, file_name):
    return file_name.endswith(env_name)


def copy_all_env_files(env_name):
    for entry_name in listdir(PROJECT_CONFIG_FOLDER):
        entry_path = os.path.join(PROJECT_CONFIG_FOLDER, entry_name)

        if os.path.isfile(entry_path) and is_env_file(env_name, entry_name):
            copy_env_file(entry_path, HADOOPIMPORT_FOLDER)


def main(env_name):
    copy_all_env_files(env_name)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(
        description="Prepares the current project for deployment. Copy files, package, etc")
    parser.add_argument("env_name", choices=["dr", "las", "stg", "dev"],
                        help="The environment to where this will be deployed")

    return vars(parser.parse_args())

if __name__ == "__main__":
    main(**parse_command_line_arguments())
