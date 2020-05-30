#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from io import open
from os import path

from setuptools import setup

with open(
    path.join(path.abspath(path.dirname(__file__)), "README.md"),
    encoding="utf-8",
) as f:
    LONG_DESCRIPTION = f.read()

setup(
    name="helloworld",
    version="0.0.1",
    description="Web sample app",
    long_description=LONG_DESCRIPTION,
    long_description_content_type="text/markdown",
    url="https://github.com/Smana/web-sample-app",
    author="Smana",
    author_email="smainklh@gmail.com",
    packages=["helloworld"],
    data_files=[("config", "config/helloworld.yaml")],
    install_requires=[
        "click==7.1.2",
        "pytest-cov == 2.8.1",
        "pytest == 3.8.2",
        "pylint == 2.4.4",
        "black == 18.9b0",
        "isort == 4.3.4",
        "xenon == 0.7.0",
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
