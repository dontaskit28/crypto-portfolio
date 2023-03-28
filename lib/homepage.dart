import 'dart:async';

import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:crypto_portfolio/widgets/top_profile.dart';
import 'package:crypto_portfolio/utils/get_data.dart';
import 'package:crypto_portfolio/tabs/history.dart';
import 'package:crypto_portfolio/tabs/nfts.dart';
import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_portfolio/tabs/portfolio.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// Home Page with 3 tabs (Portfolio, NFTs, History)
class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    ChainProvider chainProvider =
        Provider.of<ChainProvider>(context, listen: false);

    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: false);

    updateUsdPrice(
      balanceProvider: balanceProvider,
      address: chainProvider.address,
    );
    Timer.periodic(const Duration(seconds: 5), (timer) {
      updateUsdPrice(
        balanceProvider: balanceProvider,
        address: chainProvider.address,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              const SliverAppBar(
                collapsedHeight: 240,
                expandedHeight: 240,
                backgroundColor: Colors.black,
                flexibleSpace: TopProfile(),
                pinned: true,
              ),
              SliverPersistentHeader(
                delegate: MyDelegate(
                  const TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    dividerColor: Colors.black,
                    indicatorColor: Color(0xff338BAA),
                    indicatorPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelColor: Color(0xff338BAA),
                    tabs: [
                      Tab(
                        child: Text(
                          'Portfolio',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'NFTs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'History',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                // floating: true,
                pinned: true,
              ),
            ];
          },
          body: const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: TabBarView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Portfolio(),
                NFTs(),
                History(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;
}
