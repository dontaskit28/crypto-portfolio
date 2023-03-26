import 'package:crypto_portfolio/utils/get_data.dart';
import 'package:crypto_portfolio/widgets/nft_image.dart';
import 'package:flutter/material.dart';

class NFTCollectionImages extends StatefulWidget {
  dynamic data;
  String chain;
  NFTCollectionImages({super.key, required this.data, required this.chain});

  @override
  State<NFTCollectionImages> createState() => _NFTCollectionImagesState();
}

class _NFTCollectionImagesState extends State<NFTCollectionImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: FutureBuilder(
        future: getNFTCollectionData(
          widget.data["token_address"],
          widget.chain,
          needImage: false,
        ),
        builder: (context, dynamic snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: NFTImageCard(
                    url: snapshot.data[index]['token_uri'],
                    id: snapshot.data[index]['token_id'],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
