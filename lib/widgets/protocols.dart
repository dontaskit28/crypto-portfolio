import 'dart:math';
import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tokens_model.dart';
import '../utils/get_data.dart';

class ProtocolsWidget extends StatefulWidget {
  const ProtocolsWidget({super.key});

  @override
  State<ProtocolsWidget> createState() => _ProtocolsWidgetState();
}

class _ProtocolsWidgetState extends State<ProtocolsWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ChainProvider chainProvider =
        Provider.of<ChainProvider>(context, listen: true);

    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.wallet,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Wallet'),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "\$${balanceProvider.getAsset(chainProvider.chain).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isExpanded
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff16141A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // height: MediaQuery.of(context).size.height * 0.5,
                  child: FutureBuilder<List<Tokens>>(
                    future: getAssetsByChain(
                      chain: chainProvider.chain,
                      address: chainProvider.address,
                    ),
                    builder: (context, AsyncSnapshot<List<Tokens>> snapshot) {
                      if (snapshot.hasError) {
                        if (snapshot.error.toString() == "All Chains") {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: const Center(
                              child: Text("Select Chain"),
                            ),
                          );
                        }
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Image(
                                              image: NetworkImage(
                                                  '${snapshot.data![index].logo}'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${(BigInt.parse(snapshot.data![index].balance ?? '0') / BigInt.from(pow(10, snapshot.data![index].decimals ?? 0))).toStringAsPrecision(2)} ${snapshot.data![index].symbol ?? ''}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Text(
                                                  snapshot.data![index].name ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white70,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                          "\$${((snapshot.data![index].usdPrice)! * ((BigInt.parse(snapshot.data![index].balance ?? '0')) / (BigInt.from(pow(10, snapshot.data![index].decimals ?? 0))))).toStringAsPrecision(3)}"),
                                    ],
                                  ),
                                  index != snapshot.data!.length - 1
                                      ? const Divider(
                                          color: Colors.grey,
                                          thickness: 0.5,
                                        )
                                      : const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 100,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                )
              : Divider(
                  color: Colors.grey.shade200,
                  thickness: 0.2,
                ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade300,
                      radius: 15,
                      child: const Icon(
                        Icons.email,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Maker'),
                  ],
                ),
                const Text(
                  "\$766",
                  style: TextStyle(
                    color: Color(0xff2F89A6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
            thickness: 0.2,
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.horizontal_distribute,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('UniswapV3'),
                  ],
                ),
                const Text(
                  "\$863",
                  style: TextStyle(
                    color: Color(0xff2F89A6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
