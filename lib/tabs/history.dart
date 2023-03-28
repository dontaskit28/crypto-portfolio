import 'package:crypto_portfolio/models/history_model.dart';
import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:crypto_portfolio/utils/constants.dart';
import 'package:crypto_portfolio/utils/get_data.dart';
import 'package:crypto_portfolio/widgets/history_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History>
    with AutomaticKeepAliveClientMixin<History> {
  @override
  bool get wantKeepAlive => true;

  late HistoryModel history;
  List<Result> result = [];
  int loadMore = 1;
  List<String> nftChains = [
    'Ethereum',
    'Polygon',
    'Binance',
    'Avalanche',
    'Fantom',
    'Arbitrum'
  ];
  String currentChain = 'Ethereum';
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    ChainProvider chainProvider = Provider.of(context, listen: false);
    fetchHistory("", chainProvider.address);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (loadMore == 0) return;
        fetchHistory(history.cursor!, chainProvider.address);
      }
    });
    super.initState();
  }

  fetchHistory(String cursor, String address) async {
    HistoryModel data = await getHistory(
      cursor: cursor,
      chain: symbols[currentChain],
      address: address,
    );
    setState(() {
      loadMore = data.cursor == null ? 0 : 1;
      history = data;
      for (int i = 0; i < data.result!.length; i++) {
        result.add(data.result![i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ChainProvider chainProvider =
        Provider.of<ChainProvider>(context, listen: true);
    super.build(context);
    return SingleChildScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    showBottom(context, chainProvider);
                  },
                  child: Row(
                    children: [
                      Text(
                        currentChain,
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
            height: 10,
          ),
          ListView.builder(
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, index) {
              if (index == result.length) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: HistoryCard(data: result[index]),
              );
            },
            itemCount: result.length + loadMore,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }

  showBottom(
    BuildContext context,
    ChainProvider chainProvider,
  ) {
    showBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 60),
        child: SizedBox(
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
            ),
            itemCount: nftChains.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentChain = nftChains[index];
                      result = [];
                      fetchHistory("", chainProvider.address);
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xff262D34),
                      border: Border.all(
                        color: Colors.grey[700]!,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(CupertinoIcons.circle_fill),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          nftChains[index],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
