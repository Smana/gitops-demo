import os
import platform

import aiohttp_jinja2


@aiohttp_jinja2.template("index.html")
async def index():
    return {
        "system": {
            "os_name": os.name,
            "system": platform.system(),
            "release": platform.release(),
        }
    }
