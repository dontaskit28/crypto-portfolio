import 'dart:math';
import 'package:crypto_portfolio/models/history_model.dart';
import 'package:crypto_portfolio/providers/balnace_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';

class HistoryCard extends StatelessWidget {
  final Result data;
  const HistoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);
    var sent = data.fromAddress == "0xbdfa4f4492dd7b7cf211209c4791af8d52bf5c50"
        ? true
        : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 2),
          child: Text(
            DateFormat('dd MMMM yyyy').format(
              DateTime.parse(data.blockTimestamp!),
            ),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.88,
          decoration: BoxDecoration(
            color: const Color(0xff16141A),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: data.input == null || data.input == "0x"
                              ? (sent ? const Color(0xff219EBC) : Colors.green)
                              : Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          data.input == null || data.input == "0x"
                              ? (sent
                                  ? CupertinoIcons.arrow_up
                                  : CupertinoIcons.arrow_down)
                              : Icons.assignment_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Account Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text:
                                      sent ? data.toAddress : data.fromAddress,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  sent
                                      ? '${data.toAddress?.substring(0, 5)}...${data.toAddress?.substring(data.toAddress!.length - 5)}'
                                      : '${data.fromAddress?.substring(0, 5)}...${data.fromAddress?.substring(data.fromAddress!.length - 5)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.copy,
                                  color: Colors.white70,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "${(BigInt.parse(data.value ?? '0') / BigInt.parse(pow(10, 18).toString())).toStringAsFixed(3)} ${data.chain.toString().toUpperCase()}"),
                      Text(
                        "\$${((BigInt.parse(data.value ?? '0') / BigInt.parse(pow(10, 18).toString())) * balanceProvider.getUsdBalance(symbols.keys.firstWhere((element) => symbols[element] == data.chain!))).toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      sent ? "Sent" : "Received",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(
                      DateTime.parse(data.blockTimestamp.toString()),
                    ),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
