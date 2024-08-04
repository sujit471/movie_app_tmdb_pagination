import 'package:flutter/material.dart';
import 'package:movie_from_api/constant/colors.dart';
import 'package:movie_from_api/constant/space.dart';
class ItemsInRow extends StatelessWidget {
  final String text;
  final IconData image;
  final Color ? color;
  const ItemsInRow({Key? key, required this.text, required this.image, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Icon(image,color: color??Colors.white),
        Width(15),
        Text(text,style: CustomStyleText.subheader(),),
      ],
    );
  }
}
