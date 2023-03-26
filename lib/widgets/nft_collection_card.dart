import 'package:flutter/material.dart';

class NFTCollection extends StatefulWidget {
  final String address;
  final String symbol;
  const NFTCollection({super.key, required this.address, required this.symbol});

  @override
  State<NFTCollection> createState() => _NFTCollectionState();
}

class _NFTCollectionState extends State<NFTCollection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 280,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
