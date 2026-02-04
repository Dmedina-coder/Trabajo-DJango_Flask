# Makefile para gestionar el proyecto Flask y Django

# Variables
FLASK_APP=flask_app/app.py
DJANGO_MANAGE=django_app/manage.py

# Reglas
.PHONY: flask django run_all install clean

# Arrancar la aplicación Flask
flask:
	@echo "Iniciando la aplicación Flask..."
	python $(FLASK_APP)

# Arrancar la aplicación Django
django:
	@echo "Iniciando la aplicación Django..."
	python $(DJANGO_MANAGE) runserver

# Arrancar ambas aplicaciones
run_all:
	@echo "Iniciando Flask y Django..."
	@make flask & make django

# Instalar dependencias
install:
	@echo "Instalando dependencias..."
	pip install -r requirements.txt

# Limpiar archivos temporales
clean:
	@echo "Limpiando archivos temporales..."
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete