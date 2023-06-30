import 'package:flutter/material.dart';

class LikedButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  LikedButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
        color: Colors.grey[300],

      ),
    );
  }
}
