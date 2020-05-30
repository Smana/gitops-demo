#!/usr/bin/env python3
"""
Module Docstring
"""

__author__ = "Smana"
__version__ = "0.0.1"
__license__ = "APACHE 2"

import sys

import click

from helloworld.web import init_server

CONTEXT_SETTINGS = dict(help_option_names=["-h", "--help"])


@click.group(context_settings=CONTEXT_SETTINGS)
@click.version_option(version=__version__)
def helloworld():
    pass


@helloworld.command()
@click.option("--port", default="8080", help="TCP port to listen on")
def serve(**kwargs):
    print("TCP port: {0}".format(kwargs["port"]))
    init_server(**kwargs)


if __name__ == "__main__":
    sys.exit(helloworld())
