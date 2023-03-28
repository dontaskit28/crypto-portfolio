import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:crypto_portfolio/utils/constants.dart';
import 'package:crypto_portfolio/utils/get_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../nft_detail.dart';

class NFTs extends StatefulWidget {
  const NFTs({super.key});

  @override
  State<NFTs> createState() => _NFTsState();
}

class _NFTsState extends State<NFTs> with AutomaticKeepAliveClientMixin<NFTs> {
  @override
  bool get wantKeepAlive => true;

  ScrollController scrollController = ScrollController();

  late final Future result;
  List<String> nftChains = [
    'Ethereum',
    'Polygon',
    'Binance',
    'Avalanche',
    'Fantom',
    'Arbitrum'
  ];
  String currentChain = 'Ethereum';

  fetchNFTs(String cursor, String chain, String address) async {
    var data = await getAllNFTCollections(
      cursor: cursor,
      chain: symbols[chain],
      address: address,
    );
    return data;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ChainProvider chainProvider = Provider.of(context, listen: true);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
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
                    showBottom(context);
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
          FutureBuilder(
            future: getAllNFTCollections(
              cursor: '',
              chain: symbols[currentChain],
              address: chainProvider.address,
            ),
            builder: (context, dynamic snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else if (snapshot.data.isEmpty) {
                return Column(
                  children: const [
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Text('No NFTs Found'),
                    ),
                  ],
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NFTCollectionImages(
                              data: snapshot.data[index],
                              chain: symbols[currentChain],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff262D34),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: MediaQuery.of(context).size.width * 0.45,
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: FutureBuilder(
                                future: getNFTCollectionData(
                                  tokenAddress: snapshot.data[index]
                                          ['token_address']
                                      .toString(),
                                  chain: snapshot.data[index]['chain'],
                                  address: chainProvider.address,
                                  needImage: true,
                                ),
                                builder: (context, dynamic snapshot2) {
                                  if (snapshot2.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot2.hasError) {
                                    return Center(
                                      child: Text(
                                        '${snapshot.data[index]['name']}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }
                                  return Image.network(
                                    snapshot2.data.toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) {
                                      return Center(
                                        child: Text(
                                          '${snapshot.data[index]['name']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Text(
                              '${snapshot.data[index]['name']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              );
            },
          ),
        ],
      ),
    );
  }

  showBottom(
    BuildContext context,
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
