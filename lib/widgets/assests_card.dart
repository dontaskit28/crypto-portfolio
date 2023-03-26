import 'dart:async';
import 'dart:math';

import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:crypto_portfolio/utils/get_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssestsCard extends StatefulWidget {
  final String chain;
  const AssestsCard({super.key, required this.chain});

  @override
  State<AssestsCard> createState() => _AssestsCardState();
}

class _AssestsCardState extends State<AssestsCard>
    with AutomaticKeepAliveClientMixin<AssestsCard> {
  late Future getPriceData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getPriceData = getUsdPrice(widget.chain);
  }

  @override
  Widget build(BuildContext context) {
    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);

    var balance = balanceProvider.getBalance(widget.chain) *
        balanceProvider.getUsdBalance(widget.chain);

    super.build(context);
    return FutureBuilder(
      future: getPriceData,
      builder: (context, dynamic snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? const SizedBox(
                width: 100,
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (snapshot.hasError)
                ? const Center(
                    child: Text('Error'),
                  )
                : (snapshot.hasData)
                    ? Center(
                        child: Container(
                          width: 170,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff262D34),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Assets on ${widget.chain}",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '\$${balance.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Image.network(
                                    snapshot.data[0]['image'],
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${balanceProvider.getChange24(widget.chain).toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      snapshot.data[0]['symbol']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: Text('Unable to Fetch Data'),
                      );
      },
    );
  }
}
