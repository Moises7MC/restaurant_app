import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/carrito_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarritoProvider(),
      child: MaterialApp(
        title: 'Restaurante App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}