import 'package:flutter/material.dart';
import '../utils/get_data.dart';

class NFTImageCard extends StatefulWidget {
  String url;
  String id;
  NFTImageCard({super.key, required this.url, required this.id});

  @override
  State<NFTImageCard> createState() => _NFTImageCardState();
}

class _NFTImageCardState extends State<NFTImageCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrl(widget.url),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      snapshot.data.toString(),
                      errorBuilder: (context, error, stackTrace) {
                        return defaultImage(context);
                      },
                    ),
                  ),
                ),
                Text(
                  '#${widget.id}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return defaultImage(context);
        } else {
          return const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget defaultImage(context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image(
        image: const AssetImage('assets/images/default.jpg'),
        height: MediaQuery.of(context).size.width * 0.33,
        width: MediaQuery.of(context).size.width * 0.35,
      ),
    );
  }
}
