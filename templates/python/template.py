#!/usr/bin/env python3
#
# Python script template.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/pyguide

import argparse
import sys


VERSION = "%(prog)s 1.0.0"
DEFAULT_AGE = 42


def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Basic Python script template. Prints a greeting message."
    )
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version=VERSION,
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
        default=DEFAULT_AGE,
        help=f"specify a number for age (default: {DEFAULT_AGE})",
    )
    args = parser.parse_args()
    return args


def print_error(message: str) -> None:
    sys.stderr.write(f"Error: {message}\n\n")


def terminate_execution(message: str) -> None:
    exit_code: int = 1
    print_error(message)
    sys.exit(exit_code)


def print_name(name: str) -> None:
    print(f"Hello, {name}!")


def print_age(age: int) -> None:
    print(f"Age: {age}")


def main():
    args = parse_arguments()
    print_name(args.name)
    print_age(args.age)


if __name__ == "__main__":
    main()
