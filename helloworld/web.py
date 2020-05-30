import os
import pathlib

import aiohttp_jinja2
import jinja2

from aiohttp import web

from helloworld.routes import setup_routes
from helloworld.utils import read_input_yaml


def init_server(**kwargs):
    base_dir = pathlib.Path(__file__).parent.parent
    app = web.Application()
    setup_routes(app)
    app["config"] = read_input_yaml(
        os.path.join(base_dir, "config/helloworld.yaml")
    )
    aiohttp_jinja2.setup(
        app,
        loader=jinja2.FileSystemLoader(
            os.path.join(base_dir, "helloworld/templates")
        ),
    )
    web.run_app(app, port=kwargs["port"])
