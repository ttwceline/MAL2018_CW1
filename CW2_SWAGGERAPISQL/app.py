# app.py

from flask import render_template

import config
from models import Trail


app = config.connex_app
app.add_api(config.basedir / "swagger.yml")

@app.route("/")
def home():
    trails = Trail.query.all()
    return render_template("home.html", trails=trails)

if __name__ == "__main__":
    app.run(host="localhost", port=8000)