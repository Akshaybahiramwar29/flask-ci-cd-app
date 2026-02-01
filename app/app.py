from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello Akshay! CI/CD is working"


