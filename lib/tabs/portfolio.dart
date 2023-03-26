import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:crypto_portfolio/widgets/assests_card.dart';
import 'package:crypto_portfolio/widgets/protocols.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../widgets/bottom.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio>
    with AutomaticKeepAliveClientMixin<Portfolio> {
  String chain = 'All Chains';
  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ChainProvider chainProvider =
        Provider.of<ChainProvider>(context, listen: true);

    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'By Chains',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showBottom(chainProvider, context);
                    },
                    child: Row(
                      children: [
                        Text(
                          chainProvider.chain,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 9,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            chainProvider.chain == "All Chains"
                ? SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chains.length - 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AssestsCard(chain: chains[index + 1]),
                        );
                      },
                    ),
                  )
                : Text(
                    "\$${((balanceProvider.getBalance(chainProvider.chain)) * balanceProvider.getUsdBalance(chainProvider.chain)).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                Text(
                  'By Protocols',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const ProtocolsWidget(),
          ],
        ),
      ),
    );
  }
}
