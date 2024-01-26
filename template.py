#!/usr/bin/env python3

import argparse
import sys


VERSION = "%(prog)s 1.0.0"
DEFAULT_AGE = 42


def print_error(message):
    sys.stderr.write(f"Error: {message}\n\n")


def terminate_execution(message):
    exit_code = 1
    print_error(message)
    sys.exit(exit_code)


def print_name(name):
    print(f"Hello, {name}!")


def print_age(age):
    print(f"Age: {age}")


def parse_parameters():
    parser = argparse.ArgumentParser(
        description="Basic Python script template. Prints a greeting message."
    )
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version=VERSION,
        help="Show program version and exit.",
    )
    parser.add_argument(
        "name",
        metavar="name",
        type=str,
        help="Specify a name for greeting message.",
    )

    parser.add_argument(
        "-a",
        "--age",
        metavar="age",
        type=int,
        default=DEFAULT_AGE,
        help=f"Specify a number for age (default: {DEFAULT_AGE})",
    )

    args = parser.parse_args()
    return args


def main():
    args = parse_parameters()
    print_name(args.name)
    print_age(args.age)


if __name__ == "__main__":
    main()

