import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/chain_provider.dart';
import '../utils/constants.dart';

showBottom(ChainProvider chainProvider, BuildContext context,
    {bool isNFT = false}) {
  int value = isNFT ? 1 : 0;
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
          itemCount: chains.length - value,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  if (isNFT) {
                    chainProvider.setNftChain(chains[index + value]);
                  } else {
                    chainProvider.setChain(chains[index + value]);
                  }
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
                      Text(chains[index + value]),
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
