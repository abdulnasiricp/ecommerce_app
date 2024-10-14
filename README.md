# E-Commerce Flutter App

This is a simple E-Commerce Flutter application that allows users to browse products, view product details, and add items to the cart. The app supports both online and offline modes, caching images and product data for better performance and user experience.

## Features

- **Product List**: Displays a list of available products.
- **Product Details**: Shows detailed information about each product, including images, price, and description.
- **Add to Cart**: Allows users to add products to a shopping cart.
- **Image Caching**: Caches product images for offline viewing.
- **Offline Support**: Users can access cached product data and images even when they are offline.
- **Hive for Local Storage**: Product data and cart items are stored locally using Hive.
- **Provider for State Management**: Manages app state, including products and cart, with the Provider package.

## Technologies Used

- **Flutter**: UI framework.
- **Provider**: State management.
- **Hive**: Local storage for offline support.
- **CachedNetworkImage**: Efficient image caching.
- **Sqflite**: Database plugin used by some dependencies for caching.
- **Flutter Cache Manager**: Handles caching and storing data.

## Getting Started

### Prerequisites

To run this project, you will need:

- Flutter SDK installed on your local machine. You can install Flutter from the official [Flutter website](https://flutter.dev/docs/get-started/install).
- A device or emulator to run the app.
- An internet connection to initially load the product data and images.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/abdulnasiricp/ecommerce-flutter-app.git
   cd ecommerce-flutter-app
   ```
