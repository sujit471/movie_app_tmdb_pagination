import'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;
  const Indicator({Key? key, required this.itemCount, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
    children:List.generate(itemCount, (index){
      final isActive = currentPage== index;
      return AnimatedContainer(duration: const Duration (milliseconds: 300),
        margin : const EdgeInsets.symmetric(horizontal: 4.0),
        height: 8.0,
        width: isActive? 24.0:8.0,
        decoration: BoxDecoration(
          color:  isActive? Colors.white:Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
      );
    }),

    );
  }
}

