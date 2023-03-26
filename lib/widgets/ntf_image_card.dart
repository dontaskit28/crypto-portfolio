// import 'package:flutter/material.dart';
// import '../utils/get_data.dart';

// class NFTImage extends StatelessWidget {
//   final String tokenAddress;
//   const NFTImage({super.key, required this.tokenAddress});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getNFTCollectionData(
//         tokenAddress,
//         needImage: true,
//       ),
//       builder: (context, dynamic snapshot) {
//         if (snapshot.hasData) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.network(
//               snapshot.data.toString(),
//               height: MediaQuery.of(context).size.width * 0.33,
//               width: MediaQuery.of(context).size.width * 0.35,
//               errorBuilder: (context, error, stackTrace) {
//                 return defaultImage(context);
//               },
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return defaultImage(context);
//         } else {
//           return const Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget defaultImage(context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Image(
//         image: const AssetImage('assets/images/default.jpg'),
//         height: MediaQuery.of(context).size.width * 0.33,
//         width: MediaQuery.of(context).size.width * 0.35,
//       ),
//     );
//   }
// }
