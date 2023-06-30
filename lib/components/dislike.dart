import 'package:flutter/material.dart';

class UnlikedButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  UnlikedButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
        color: Colors.grey[300],

      ),
    );
  }
}
