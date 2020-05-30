# -*- coding: utf-8 -*-

"""Utility functions."""

import sys

import yaml


def read_input_yaml(yaml_file, multiple=False):
    try:
        with open(yaml_file, "r") as yfile:
            if multiple:
                data = list()
                for obj in yaml.load_all(yfile):
                    data.append(obj)
            else:
                data = yaml.load(yfile, Loader=yaml.FullLoader)
    except (IOError, OSError) as err:
        print("Can't read input yaml: {0}".format(err))
        sys.exit(1)
    return data
