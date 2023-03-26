import 'package:crypto_portfolio/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    ChainProvider chainProvider =
        Provider.of<ChainProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: const Image(
              image: AssetImage(
                'assets/images/profile.png',
              ),
              height: 65,
              width: 65,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  Text(
                    '${chainProvider.address.substring(0, 6)}...${chainProvider.address.substring(chainProvider.address.length - 4, chainProvider.address.length)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: chainProvider.address,
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      color: Colors.grey,
                      iconSize: 12,
                      padding: const EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     SizedBox(
              //       height: 25,
              //       child: TextButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all(const Color(0xff308CAB)),
              //           padding: MaterialStateProperty.all(
              //             const EdgeInsets.symmetric(
              //               horizontal: 20,
              //             ),
              //           ),
              //         ),
              //         onPressed: () {},
              //         child: const Text(
              //           'Follow',
              //           style: TextStyle(
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     const Image(
              //       image: AssetImage('assets/share.png'),
              //       height: 20,
              //       width: 20,
              //     ),
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}
