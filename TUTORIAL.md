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