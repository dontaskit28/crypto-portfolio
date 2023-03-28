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

// Widget folder contains all the widgets used in the app
// Providers folder contains all the providers used in the app
// Tabs folder contains the 3 tabs used in the app (Portfolio, NFTs, History)
// Utils folder contains all the helper functions and constants used in the app
// Models folder contains all the models for the api data used in the app
// NFT Detailed Page is the page that opens when you click on a NFT in the NFTs tab
// Homepage is the main page of the app

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
