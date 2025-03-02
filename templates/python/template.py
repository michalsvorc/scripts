#!/usr/bin/env python3
#
# Python script template.
#
# Version: 1.0.0
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/pyguide

import argparse
import logging
import os
import pdb

AGE_DEFAULT = 42


def main():
    enable_debug_mode()
    args = parse_arguments()
    print_name(args.name)
    print_age(args.age)


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Basic Python script template. Prints a greeting message."
    )
    parser.add_argument(
        "name",
        type=str,
        metavar="name",
        help="specify a name for the greeting message",
    )
    parser.add_argument(
        "-a",
        "--age",
        type=int,
        default=AGE_DEFAULT,
        metavar="age",
        help=f"specify a number for age (default: {AGE_DEFAULT})",
    )
    return parser.parse_args()


def print_name(name: str) -> None:
    print(f"Hello, {name}!")


def print_age(age: int) -> None:
    print(f"Age: {age}")


def enable_debug_mode():
    debug_env = os.environ.get("DEBUG", "").lower()
    if debug_env in ["1", "true", "yes"]:
        logging.basicConfig(level=logging.DEBUG)
        logging.debug("Debug mode enabled.")
        pdb.set_trace()


if __name__ == "__main__":
    main()
