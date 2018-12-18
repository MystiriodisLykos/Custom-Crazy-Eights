import flask

mod = flask.Blueprint('home', __name__)

@mod.route('/')
@mod.route('/home/')
def index():
    return flask.render_template('home.html')
