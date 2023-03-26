import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        SizedBox(
          width: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(
                CupertinoIcons.search,
                size: 18,
              ),
              Icon(
                Icons.chat_bubble_outline,
                size: 18,
              ),
              Icon(
                CupertinoIcons.bell,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
