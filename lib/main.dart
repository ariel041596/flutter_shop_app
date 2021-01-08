import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth_provider.dart';

import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (context, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.userID,
            previousProducts == null ? [] : previousProducts.itemsProvider,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (context, auth, previousOrders) => OrdersProvider(
            auth.token,
            auth.userID,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopilore',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Color.fromRGBO(53, 122, 172, 1),
            errorColor: Colors.red,
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            // canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Raleway',
            // fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                body2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                title: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 20,
                ),
                button: TextStyle(
                  color: Colors.white,
                )),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Reserve Code for routing
          // initialRoute: '/',
          home: auth.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, dataSnapshot) =>
                      dataSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),

            // CategoryMeals.routeName: (ctx) => CategoryMeals(_availableMeals),
          },
          // or this code
          // home: ProductOverViewScreen(),
        ),
      ),
    );
  }
}
