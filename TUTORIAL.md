#### Basic Exercises

**Exercise 1: Add Product Categories**
- Add a `category` field to the Product model (choices: 'fruits', 'vegetables', 'dairy', 'bakery')
- Update the XML file to include categories for each product
- Modify the product list template to filter products by category
- Add a navigation menu to show products by category

**Exercise 2: Improve the Shopping Cart**
- Add a "Remove from Cart" button for each item
- Implement quantity adjustment (increase/decrease) directly from cart view
- Add a "Clear Cart" button to remove all items at once
- Show the total number of items in the cart in the header

**Exercise 3: Order History**
- Create a new view to display all orders
- Add a detail view to show individual order information
- Include order status (pending, paid, shipped, delivered)
- Allow customers to search for their orders by email

**Exercise 4: Product Search**
- Implement a search bar in the product list page
- Allow searching by product name or description
- Add a "Sort by" feature (price: low to high, high to low, name A-Z)
- Display the number of search results found

**Exercise 5: Enhance Payment Gateway**
- Add basic validation for credit card number format (16 digits)
- Validate expiry date (must be future date)
- Implement a loading spinner while processing payment
- Add a cancel button to return to checkout without paying

**Exercise 6: Admin Improvements**
- Register the Product, Order, and OrderItem models in Django admin
- Customize the admin interface to show relevant fields
- Add search and filter capabilities in the admin panel
- Create a custom admin action to mark orders as "shipped"

#### Intermediate Exercises

**Exercise 7: User Authentication**
- Implement user registration and login
- Associate orders with logged-in users
- Create a user profile page showing order history
- Require login before checkout

**Exercise 8: Product Inventory**
- Add a `stock` field to track product quantity
- Prevent adding out-of-stock items to cart
- Update stock after successful payment
- Show "Out of Stock" badge on products with zero stock

**Exercise 9: Email Notifications**
- Send order confirmation email after successful payment
- Include order details and total amount in the email
- Send payment receipt as PDF attachment
- Add email notifications for order status changes

**Exercise 10: Advanced Cart Features**
- Save cart to database for logged-in users
- Implement "Save for Later" functionality
- Add product recommendations based on cart items
- Create a "Recently Viewed" products section