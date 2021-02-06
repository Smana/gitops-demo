#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from io import open
from os import path

from setuptools import setup

setup(
    name="helloworld",
    version="0.0.1",
    description="Web sample app",
    url="https://github.com/Smana/web-sample-app",
    author="Smana",
    author_email="smainklh@gmail.com",
    packages=["helloworld"],
    data_files=[("config", "config/helloworld.yaml")],
    install_requires=[
        "click==7.1.2",
        "jinja2 == 2.11.2",
        "aiohttp == 3.6.2",
        "aiohttp-jinja2 == 1.2.0",
    ],
    include_package_data=True,
    python_requires=">=3.6",
    entry_points={"console_scripts": ["helloworld=helloworld.cli:helloworld"]},
    zip_safe=False,
    license="Apache 2.0",
)
