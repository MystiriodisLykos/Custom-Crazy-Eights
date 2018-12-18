import flask
import flask_sockets


sockets = flask_sockets.Sockets()


def create_app():

    app = flask.Flask(__name__)

    import home
    app.register_blueprint(home.mod)

    import chat
    app.register_blueprint(chat.mod, url_prefix='/chat')

    sockets.init_app(app)
    return app
