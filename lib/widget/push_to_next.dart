import'package:flutter/material.dart';
mixin NavigationToPage{
  Future<T?> navigateTo<T extends Object?> (BuildContext context , Widget destination){
    return Navigator.push(
      context, MaterialPageRoute(builder: (context)=> destination, ),
    );
  }
  void goBack<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}