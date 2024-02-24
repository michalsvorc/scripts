#!/usr/bin/env python3
#
# Python script template.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/pyguide

import argparse
import sys

import logging

VERSION = "1.0.0"
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
        "-v",
        "--version",
        action="version",
        version=f"%(prog)s {VERSION}",
        help="show program version and exit",
    )
    parser.add_argument(
        "name",
        metavar="name",
        type=str,
        help="specify a name for the greeting message",
    )
    parser.add_argument(
        "-a",
        "--age",
        metavar="age",
        type=int,
        default=AGE_DEFAULT,
        help=f"specify a number for age (default: {AGE_DEFAULT})",
    )
    return parser.parse_args()


def print_name(name: str) -> None:
    print(f"Hello, {name}!")


def print_age(age: int) -> None:
    print(f"Age: {age}")




if __name__ == "__main__":
    main()
