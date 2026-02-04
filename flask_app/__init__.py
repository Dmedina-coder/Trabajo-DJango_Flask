from flask import Flask

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'tu_clave_secreta'
    
    @app.route('/')
    def home():
        return "¡Hola desde Flask!"
    
    return app