#!/usr/bin/env python3
#
# Python script snippet to prompt user for an answer.
#
# Author: Michal Svorc <dev@michalsvorc.com>
# License: MIT license (https://opensource.org/licenses/MIT)
# Guidelines: https://google.github.io/styleguide/pyguide


def prompt_user_yes_no(question="Are you sure?") -> bool:
    positive_answer = "y"
    negative_answer = "N"
    print(f"{question} [{positive_answer}/{negative_answer}] ")

    answer = input().strip().lower()
    return answer == positive_answer
