## Overview

This tutorial demonstrates how to build a complete supermarket web application using **Django** for the main e-commerce platform and **Flask** for the payment gateway. This step-by-step guide is designed for university students learning web development with Python.

**Important**: This tutorial uses a pre-configured base project available on GitHub. You will clone the repository and then follow along to understand and modify the existing code. This approach allows you to focus on learning Django and Flask concepts rather than initial setup.

**GitHub Repository**: https://github.com/Dmedina-coder/Trabajo-DJango_Flask
### Project Architecture
- **Django Application**: Product catalog, shopping cart, and order management
- **Flask Application**: Payment processing gateway
- **Data Storage**: XML database for products, SQLite for Django models

---
## Table of Contents

1. [Quick Start](#quick-start)
2. [Prerequisites](#prerequisites)
3. [Project Setup](#project-setup)
4. [Part 1: Flask Payment Gateway](#part-1-flask-payment-gateway)
5. [Part 2: Django Supermarket](#part-2-django-supermarket)
6. [Part 3: Integration](#part-3-integration)
7. [Part 4: Testing](#part-4-testing)
8. [Conclusion](#conclusion)

---

## Quick Start

**For students who want to run the project immediately:**

```bash
# 1. Clone the repository
git clone https://github.com/Dmedina-coder/Trabajo-DJango_Flask.git
cd Trabajo-DJango_Flask

# 2. Install dependencies
pip install -r requirements.txt

# 3. Run Django migrations (first time only)
cd django_app
python manage.py migrate
cd ..

# 4. Start Flask (in one terminal)
make flask

# 5. Start Django (in another terminal)
make django
```

Then visit:
- **Django Supermarket**: http://127.0.0.1:8000/
- **Flask Payment Gateway**: http://127.0.0.1:5000/payment

---

## Prerequisites

### Required Software
- Python 3.8 or higher
- pip (Python package manager)
- A code editor (VS Code, PyCharm, etc.)
- Basic knowledge of Python
- Basic understanding of HTML/CSS

### Required Python Packages

```plaintext
Flask==2.3.3
Django==4.2.5
```
  
---

## Project Setup

### Step 1: Clone the Repository

The project base is already configured and available on GitHub. Clone it to your local machine:

```bash
git clone https://github.com/Dmedina-coder/Trabajo-DJango_Flask.git
cd Trabajo-DJango_Flask
```

**What's already included in the repository:**
- ✅ Complete project structure
- ✅ Flask application (`flask_app/`)
- ✅ Django application (`django_app/`)
- ✅ Product database in XML format (`data/products.xml`)
- ✅ Makefile for easy command execution
- ✅ Requirements file with dependencies

### Step 2: Verify Project Structure

After cloning, you should have the following structure:

```
Trabajo-DJango_Flask/
├── data/
│   └── products.xml          # Product database (10 supermarket items)
├── django_app/
│   ├── manage.py
│   ├── db.sqlite3
│   └── django_app/
│       ├── __init__.py
│       ├── settings.py
│       ├── urls.py
│       ├── wsgi.py
│       └── asgi.py
├── flask_app/
│   ├── __init__.py
│   └── app.py
├── Makefile
├── requirements.txt
├── TUTORIAL.md              # This file
└── README.md
```

### Step 3: Install Dependencies

Install the required Python packages:

```bash

pip install -r requirements.txt

```

This will install:

```plaintext
Flask==2.3.3
Django==4.2.5
```

### Step 4: Verify the XML Product Database

Open `data/products.xml` to see the pre-configured products. The file contains 10 supermarket items with real image URLs from a Spanish supermarket chain:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<products>
    <product id="1">
        <name>Manzana</name>
        <description>Manzanas rojas frescas, crujientes.</description>
        <price currency="EUR">0.65</price>
        <image>https://www.dia.es/product_images/69/69_ISO_0_ES.jpg</image>
    </product>
    <!-- ... 9 more products -->
</products>
```

**Note**: This file is already complete. You won't need to create it from scratch.

---
## Part 1: Flask Payment Gateway

### Understanding the Existing Flask Application

The Flask application is already configured in the repository. Let's explore what's already set up and how it works.

### Step 1.1: Review Flask Application Structure

Open `flask_app/__init__.py` to see the existing configuration:

```python
from flask import Flask

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'tu_clave_secreta'
    
    @app.route('/')
    def home():
        return "¡Hola desde Flask!"
    return app
```

**What this does:**
- Creates a Flask application factory
- Sets a secret key for session management
- Defines a basic home route

### Step 1.2: Review Flask Runner

Check `flask_app/app.py`:

```python
from . import create_app

app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
```

**What this does:**
- Imports the app factory
- Creates the app instance
- Runs the development server with debug mode

### Step 1.3: Add Payment Routes (Modification Exercise)

Now you'll modify the existing Flask application to add payment functionality. Update `flask_app/__init__.py`:

```python
from flask import Flask, request, jsonify, render_template_string

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'tu_clave_secreta'

    @app.route('/')
    def home():
        return "Flask Payment Gateway"

    @app.route('/payment', methods=['GET', 'POST'])
    def payment():
        if request.method == 'POST':

            # Get payment data
            data = request.get_json()
            amount = data.get('amount')
            order_id = data.get('order_id')

            # Simulate payment processing

            # In a real application, you would integrate with Stripe, PayPal, etc.
            response = {
                'status': 'success',
                'message': 'Payment processed successfully',
                'order_id': order_id,
                'amount': amount,
                'transaction_id': f'TXN-{order_id}-{amount}'
            }
            return jsonify(response), 200

        # GET request - show payment form
        html = '''
        <!DOCTYPE html>
        <html>
        <head>
            <title>Payment Gateway</title>
            <style>
                body { font-family: Arial; max-width: 500px; margin: 50px auto; padding: 20px; }
                input { width: 100%; padding: 10px; margin: 10px 0; }
                button { width: 100%; padding: 15px; background: #4CAF50; color: white; border: none; cursor: pointer; }
                button:hover { background: #45a049; }
            </style>
        </head>
        <body>
            <h2>Payment Gateway</h2>
            <form id="paymentForm">
                <label>Card Number:</label>
                <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456" required>
                <label>Cardholder Name:</label>
                <input type="text" id="cardName" placeholder="John Doe" required>
                <label>Expiry Date:</label>
                <input type="text" id="expiry" placeholder="MM/YY" required>
                <label>CVV:</label>
                <input type="text" id="cvv" placeholder="123" required>
                <label>Amount (EUR):</label>
                <input type="number" id="amount" step="0.01" required>
                <button type="submit">Process Payment</button>
            </form>
            <div id="result" style="margin-top: 20px;"></div>
            <script>
                document.getElementById('paymentForm').addEventListener('submit', async (e) => {
                    e.preventDefault();
                    const amount = document.getElementById('amount').value;
                    const response = await fetch('/api/process-payment', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            amount: amount,
                            order_id: 'ORD-' + Date.now()
                        })
                    });
                    const result = await response.json();
                    document.getElementById('result').innerHTML =
                        '<p style="color: green;">✓ ' + result.message + '</p>' +
                        '<p>Transaction ID: ' + result.transaction_id + '</p>';
                });
            </script>
        </body>
        </html>
        '''
        return render_template_string(html)
    
    @app.route('/api/process-payment', methods=['POST'])
    def process_payment():
        data = request.get_json()
        amount = data.get('amount')
        order_id = data.get('order_id')

        # Simulate payment processing
        response = {
            'status': 'success',
            'message': 'Payment processed successfully',
            'order_id': order_id,
            'amount': amount,
            'transaction_id': f'TXN-{order_id}-{amount}'
        }
        return jsonify(response), 200
    return app
```
### Step 1.4: Test Flask Application

The repository includes a Makefile for easy execution. Run the Flask app:

```bash

make flask

```

Alternative method:

```bash

python3 -m flask_app.app

```


Visit `http://127.0.0.1:5000/payment` to see the payment form.

---
## Part 2: Django Supermarket

### Understanding the Existing Django Application

The Django project structure is already set up in the repository. Now you'll create the products app and add functionality step by step.

### Step 2.1: Create Django Product App

Navigate to the Django project directory and create a new app:

```bash
cd django_app
python manage.py startapp products
cd ..
```

### Step 2.2: Define Product Model

Create `django_app/products/models.py`:

```python
from django.db import models
  
class Product(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image_url = models.URLField(max_length=500)

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['name']

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('paid', 'Paid'),
        ('shipped', 'Shipped'),
        ('delivered', 'Delivered'),
    ]
    order_id = models.CharField(max_length=100, unique=True)
    customer_name = models.CharField(max_length=200)
    customer_email = models.EmailField()
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return f"Order {self.order_id}"

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    def __str__(self):
        return f"{self.quantity}x {self.product.name}"
```

### Step 2.3: Update Django Settings

The Django settings file already exists. Now you need to modify `django_app/django_app/settings.py` to add the products app:

Find the `INSTALLED_APPS` list and add `'products'` to it:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'products',  # Add this line
]
```

### Step 2.4: Create Product Views

Create `django_app/products/views.py`:

```python

from django.shortcuts import render, get_object_or_404, redirect

from django.http import JsonResponse

from .models import Product, Order, OrderItem

import xml.etree.ElementTree as ET

import os

  

def load_products_from_xml():
    """Load products from XML file into database"""
    xml_path = os.path.join(os.path.dirname(__file__), '..', '..', 'data', 'products.xml')

    # Clear existing products
    Product.objects.all().delete()

    # Parse XML
    tree = ET.parse(xml_path)
    root = tree.getroot()
    for product_elem in root.findall('product'):
        Product.objects.create(
            name=product_elem.find('name').text,
            description=product_elem.find('description').text,
            price=float(product_elem.find('price').text),
            image_url=product_elem.find('image').text
        )

def product_list(request):
    """Display all products"""
    # Load products from XML if database is empty
    if Product.objects.count() == 0:
        load_products_from_xml()
    products = Product.objects.all()
    return render(request, 'products/product_list.html', {'products': products})

def product_detail(request, product_id):
    """Display single product details"""
    product = get_object_or_404(Product, id=product_id)
    return render(request, 'products/product_detail.html', {'product': product})

def add_to_cart(request, product_id):
    """Add product to cart (stored in session)"""
    product = get_object_or_404(Product, id=product_id)

    # Get or create cart in session
    cart = request.session.get('cart', {})

    # Add product to cart
    product_id_str = str(product_id)
    if product_id_str in cart:
        cart[product_id_str]['quantity'] += 1
    else:
        cart[product_id_str] = {
            'name': product.name,
            'price': str(product.price),
            'quantity': 1,
            'image': product.image_url
        }
    request.session['cart'] = cart
    return redirect('cart_view')
def cart_view(request):

    """Display shopping cart"""
    cart = request.session.get('cart', {})

    # Calculate total
    total = sum(float(item['price']) * item['quantity'] for item in cart.values())
    return render(request, 'products/cart.html', {
        'cart': cart,
        'total': total
    })

def checkout(request):
    """Checkout page - prepare order for payment"""
    cart = request.session.get('cart', {})
    if not cart:
        return redirect('product_list')

    # Calculate total
    total = sum(float(item['price']) * item['quantity'] for item in cart.values())
    if request.method == 'POST':

        # Create order
        import random
        order_id = f"ORD-{random.randint(10000, 99999)}"
        order = Order.objects.create(
            order_id=order_id,
            customer_name=request.POST.get('name'),
            customer_email=request.POST.get('email'),
            total_amount=total
        )

        # Create order items
        for product_id, item in cart.items():
            product = Product.objects.get(id=int(product_id))
            OrderItem.objects.create(
                order=order,
                product=product,
                quantity=item['quantity'],
                price=item['price']
            )

        # Clear cart
        request.session['cart'] = {}

        # Redirect to Flask payment gateway
        return redirect(f'http://127.0.0.1:5000/payment?order_id={order_id}&amount={total}')
    return render(request, 'products/checkout.html', {
        'cart': cart,
        'total': total
    })
```

### Step 2.5: Create URL Patterns

Create a new file `django_app/products/urls.py`:

```python
from django.urls import path
from . import views

urlpatterns = [
    path('', views.product_list, name='product_list'),
    path('product/<int:product_id>/', views.product_detail, name='product_detail'),
    path('add-to-cart/<int:product_id>/', views.add_to_cart, name='add_to_cart'),
    path('cart/', views.cart_view, name='cart_view'),
    path('checkout/', views.checkout, name='checkout'),
]
```

Update the existing `django_app/django_app/urls.py` to include the products URLs:

```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('products.urls')),
]
```

### Step 2.6: Create Templates

Create directory structure:

```

django_app/products/templates/products/

```

Create `django_app/products/templates/products/base.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}Supermarket{% endblock %}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; line-height: 1.6; }
        header { background: #4CAF50; color: white; padding: 1rem; }
        header h1 { display: inline-block; }
        nav { float: right; margin-top: 10px; }
        nav a { color: white; text-decoration: none; margin-left: 20px; }
        nav a:hover { text-decoration: underline; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 20px; }
        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; margin-top: 20px; }
        .product-card { border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
        .product-card img { width: 100%; height: 200px; object-fit: cover; border-radius: 5px; }
        .product-card h3 { margin: 10px 0; }
        .product-card .price { color: #4CAF50; font-size: 1.5em; font-weight: bold; }
        .product-card button { width: 100%; padding: 10px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; margin-top: 10px; }
        .product-card button:hover { background: #45a049; }
        .cart-item { border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .cart-total { font-size: 1.5em; font-weight: bold; text-align: right; margin-top: 20px; }
        .btn { padding: 10px 20px; background: #4CAF50; color: white; text-decoration: none; border-radius: 5px; display: inline-block; border: none; cursor: pointer; }
        .btn:hover { background: #45a049; }
        footer { background: #333; color: white; text-align: center; padding: 20px; margin-top: 40px; }
    </style>
</head>
<body>
    <header>
        <h1>🛒 Supermarket</h1>
        <nav>
            <a href="{% url 'product_list' %}">Products</a>
            <a href="{% url 'cart_view' %}">Cart</a>
        </nav>
    </header>
    <div class="container">
        {% block content %}{% endblock %}
    </div>
    <footer>
        <p>© 2026 Supermarket - Django & Flask Tutorial</p>
    </footer>
</body>
</html>
```


Create `django_app/products/templates/products/product_list.html`

```html
{% extends 'products/base.html' %}

{% block title %}Products - Supermarket{% endblock %}

{% block content %}

<h2>Our Products</h2>
<div class="products-grid">
    {% for product in products %}
    <div class="product-card">
        <img src="{{ product.image_url }}" alt="{{ product.name }}">
        <h3>{{ product.name }}</h3>
        <p>{{ product.description }}</p>
        <p class="price">€{{ product.price }}</p>
        <form method="post" action="{% url 'add_to_cart' product.id %}">
            {% csrf_token %}
            <button type="submit">Add to Cart</button>
        </form>
    </div>
    {% empty %}
    <p>No products available.</p>
    {% endfor %}
</div>
{% endblock %}
```

Create `django_app/products/templates/products/cart.html`:

```html
{% extends 'products/base.html' %}

{% block title %}Shopping Cart{% endblock %}

{% block content %}

<h2>Shopping Cart</h2>
{% if cart %}
    {% for product_id, item in cart.items %}
    <div class="cart-item">
        <img src="{{ item.image }}" alt="{{ item.name }}" style="width: 100px; float: left; margin-right: 20px;">
        <h3>{{ item.name }}</h3>
        <p>Price: €{{ item.price }}</p>
        <p>Quantity: {{ item.quantity }}</p>
        <p><strong>Subtotal: €{{ item.price|floatformat:2 }}</strong></p>
        <div style="clear: both;"></div>
    </div>
    {% endfor %}
    <div class="cart-total">
        <p>Total: €{{ total|floatformat:2 }}</p>
    </div>
    <a href="{% url 'checkout' %}" class="btn">Proceed to Checkout</a>
{% else %}
    <p>Your cart is empty.</p>
    <a href="{% url 'product_list' %}" class="btn">Continue Shopping</a>
{% endif %}
{% endblock %}
```

Create `django_app/products/templates/products/checkout.html`:

```html
{% extends 'products/base.html' %}

{% block title %}Checkout{% endblock %}

{% block content %}
<h2>Checkout</h2>
<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
    <div>
        <h3>Order Summary</h3>
        {% for product_id, item in cart.items %}
        <div class="cart-item">
            <p><strong>{{ item.name }}</strong></p>
            <p>€{{ item.price }} x {{ item.quantity }}</p>
        </div>
        {% endfor %}
        <div class="cart-total">
            <p>Total: €{{ total|floatformat:2 }}</p>
        </div>
    </div>
    <div>
        <h3>Customer Information</h3>
        <form method="post">
            {% csrf_token %}
            <div style="margin: 15px 0;">
                <label>Full Name:</label><br>
                <input type="text" name="name" required style="width: 100%; padding: 10px;">
            </div>
            <div style="margin: 15px 0;">
                <label>Email:</label><br>
                <input type="email" name="email" required style="width: 100%; padding: 10px;">
            </div>
            <button type="submit" class="btn" style="width: 100%; margin-top: 20px;">
                Proceed to Payment (€{{ total|floatformat:2 }})
            </button>
        </form>
    </div>
</div>
{% endblock %}
```

### Step 2.7: Run Migrations

```bash
cd django_app
python manage.py makemigrations
python manage.py migrate
cd ..
```

### Step 2.8: Create Admin User (Optional)

```bash
cd django_app
python manage.py createsuperuser
cd ..
```

### Step 2.9: Test Django Application

Use the Makefile to run the Django server:

```bash

make django

```

Alternative method:

```bash

python django_app/manage.py runserver

```

Visit `http://127.0.0.1:8000/` to see the product catalog (it will automatically load products from the XML file).

---

## Part 3: Integration

### Step 3.1: Update Flask Payment Gateway

Modify `flask_app/__init__.py` to accept order information from Django:

```python
from flask import Flask, request, jsonify, render_template_string, redirect

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'your_secret_key_here'

    @app.route('/')
    def home():
        return "Flask Payment Gateway - Ready"

    @app.route('/payment', methods=['GET', 'POST'])
    def payment():

        # Get order information from URL parameters
        order_id = request.args.get('order_id', 'N/A')
        amount = request.args.get('amount', '0.00')
        if request.method == 'POST':

            # Process payment
            data = request.get_json()
            response = {
                'status': 'success',
                'message': 'Payment processed successfully',
                'order_id': order_id,
                'amount': amount,
                'transaction_id': f'TXN-{order_id}'
            }
            return jsonify(response), 200

        # GET request - show payment form with order info
        html = f'''
        <!DOCTYPE html>
        <html>
        <head>
            <title>Payment Gateway</title>
            <style>
                body {{ font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; background: #f5f5f5; }}
                .payment-container {{ background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
                h2 {{ color: #333; }}
                .order-info {{ background: #e8f5e9; padding: 15px; border-radius: 5px; margin-bottom: 20px; }}
                input {{ width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; }}
                button {{ width: 100%; padding: 15px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }}
                button:hover {{ background: #45a049; }}
                .success {{ color: green; padding: 15px; background: #e8f5e9; border-radius: 5px; margin-top: 20px; }}
            </style>
        </head>
        <body>
            <div class="payment-container">
                <h2>🔒 Secure Payment</h2>
                <div class="order-info">
                    <p><strong>Order ID:</strong> {order_id}</p>
                    <p><strong>Amount to Pay:</strong> €{amount}</p>
                </div>
                <form id="paymentForm">
                    <label><strong>Card Number:</strong></label>
                    <input type="text" id="cardNumber" placeholder="1234 5678 9012 3456" required>
                    <label><strong>Cardholder Name:</strong></label>
                    <input type="text" id="cardName" placeholder="John Doe" required>
                    <label><strong>Expiry Date:</strong></label>
                    <input type="text" id="expiry" placeholder="MM/YY" required>
                    <label><strong>CVV:</strong></label>
                    <input type="text" id="cvv" placeholder="123" maxlength="3" required>
                    <button type="submit">Pay €{amount}</button>
                </form>
                <div id="result"></div>
            </div>
            <script>
                document.getElementById('paymentForm').addEventListener('submit', async (e) => {{
                    e.preventDefault();
                    const response = await fetch('/api/process-payment', {{
                        method: 'POST',
                        headers: {{ 'Content-Type': 'application/json' }},
                        body: JSON.stringify({{
                            amount: '{amount}',
                            order_id: '{order_id}'
                        }})
                    }});
                    const result = await response.json();
                    document.getElementById('result').innerHTML =
                        '<div class="success">' +
                        '<p>✓ ' + result.message + '</p>' +
                        '<p><strong>Transaction ID:</strong> ' + result.transaction_id + '</p>' +
                        '<p><strong>Order ID:</strong> ' + result.order_id + '</p>' +
                        '</div>';
                    // Redirect back to Django after 3 seconds
                    setTimeout(() => {{
                        window.location.href = 'http://127.0.0.1:8000/?payment=success';
                    }}, 3000);
                }});
            </script>
        </body>
        </html>
        '''

        return render_template_string(html)

    @app.route('/api/process-payment', methods=['POST'])

    def process_payment():
        data = request.get_json()
        amount = data.get('amount')
        order_id = data.get('order_id')

        # For this tutorial, we simulate a successful payment
        response = {
            'status': 'success',
            'message': 'Payment processed successfully',
            'order_id': order_id,
            'amount': amount,
            'transaction_id': f'TXN-{order_id}'
        }
        return jsonify(response), 200
    return app
```

### Step 3.2: Handle Payment Success in Django

Update `django_app/products/views.py` to add a payment success handler at the end of the file:

```python
def payment_success(request):
    """Handle successful payment callback"""
    payment_status = request.GET.get('payment')
    if payment_status == 'success':
        message = "Payment successful! Thank you for your order."
    else:
        message = "Payment status unknown."
    return render(request, 'products/payment_success.html', {
        'message': message
    })
```

Add the new route to `django_app/products/urls.py`:

```python

path('payment-success/', views.payment_success, name='payment_success'),

```

Create `django_app/products/templates/products/payment_success.html`:

```html

{% extends 'products/base.html' %}

  

{% block title %}Payment Success{% endblock %}

  

{% block content %}

<div style="text-align: center; padding: 50px;">
    <h2 style="color: #4CAF50;">✓ {{ message }}</h2>
    <p>Your order has been processed successfully.</p>
    <a href="{% url 'product_list' %}" class="btn">Continue Shopping</a>
</div>

{% endblock %}
```

---
## Part 4: Test Complete Flow

1. **Start Flask** (in terminal 1):

   ```bash
   
   make flask
   
   ```

2. **Start Django** (in terminal 2):

   ```bash
   
   make django
   
   ```

3. **Test the workflow**:
   - Visit `http://127.0.0.1:8000/`
   - Browse products
   - Add items to cart
   - Proceed to checkout
   - Fill in customer information
   - Complete payment in Flask gateway
   - Verify redirect to success page
  
---
## Makefile Commands

The project includes a pre-configured Makefile for easy command execution. These commands are already set up in the repository:


```makefile
# Start Flask application
make flask

# Start Django application
make django

# Install all dependencies
make install

# Clean temporary files
make clean
```


**How to use them:**
- Open a terminal in the project root directory
- Run any of the commands above
- The Makefile handles the correct paths and execution

---
## Conclusion

### What You've Learned

1. **Git and Project Setup**
   - Cloning a repository from GitHub
   - Understanding existing project structure
   - Installing dependencies from requirements.txt

2. **Flask Basics**
   - Understanding Flask application with routing
   - Handling POST/GET requests
   - JSON responses and form processing
   - Building a payment gateway interface

3. **Django Fundamentals**
   - Creating models and migrations
   - Building views and URL patterns
   - Template system and inheritance
   - Session management for shopping cart
   - Admin interface

4. **Integration Techniques**
   - Communication between Flask and Django
   - URL parameter passing
   - Redirects between applications
   - Data synchronization

4. **Best Practices**
   - Project structure organization
   - Separation of concerns
   - Environment configuration
   - Data persistence (XML and SQLite)
   - Using Makefiles for automation

### Next Steps

To enhance this project, consider:

1. **Add User Authentication**
   - Django login/registration system
   - User profiles and order history

2. **Improve Payment Gateway**
   - Integrate real payment processors (Stripe, PayPal)
   - Add payment validation
   - Handle failed payments

3. **Enhance UI/UX**
   - Add Bootstrap or Tailwind CSS
   - Implement AJAX for cart updates
   - Add product search and filtering
  
4. **Deploy to Production**
   - Configure PostgreSQL database
   - Set up Nginx as reverse proxy
   - Deploy on AWS, Heroku, or DigitalOcean

### Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Python XML Processing](https://docs.python.org/3/library/xml.etree.elementtree.html)
- [Project Repository](https://github.com/Dmedina-coder/Trabajo-DJango_Flask)

---
## Project Repository Structure

```
Trabajo-DJango_Flask/
├── data/
│   └── products.xml              # XML product database
├── django_app/
│   ├── manage.py                 # Django management script
│   ├── db.sqlite3                # SQLite database
│   ├── django_app/
│   │   ├── settings.py           # Django configuration
│   │   ├── urls.py               # Main URL routing
│   │   └── ...
│   └── products/
│       ├── models.py             # Product, Order models
│       ├── views.py              # View functions
│       ├── urls.py               # App URL routing
│       └── templates/            # HTML templates
├── flask_app/
│   ├── __init__.py               # Flask app factory
│   └── app.py                    # Flask runner
├── Makefile                      # Build automation
├── requirements.txt              # Python dependencies
├── TUTORIAL.md                   # This tutorial
└── README.md                     # Project overview
```
