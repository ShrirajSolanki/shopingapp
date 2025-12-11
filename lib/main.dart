import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire app with ChangeNotifierProvider for state management
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'E-Commerce Mini App',
        debugShowCheckedModeBanner: false,
        theme: appTheme, // Use the custom theme
        home: const SplashScreen(),
      ),
    );
  }
}