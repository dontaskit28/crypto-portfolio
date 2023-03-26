import 'package:crypto_portfolio/homepage.dart';
import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chain_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ChainProvider()),
      ChangeNotifierProvider(create: (_) => BalanceProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Portfolio',
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
