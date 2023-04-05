import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_info.dart';
import 'topbar.dart';

class TopProfile extends StatefulWidget {
  const TopProfile({super.key});

  @override
  State<TopProfile> createState() => _TopProfileState();
}

class _TopProfileState extends State<TopProfile> {
  @override
  Widget build(BuildContext context) {
    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          const TopBar(),
          const SizedBox(
            height: 20,
          ),
          const Profile(),
          const SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff625E5E),
                      fontFamily: 'Chivo',
                    ),
                  ),
                  Text(
                    "\$${balanceProvider.getAsset("All Chains").toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Chivo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
