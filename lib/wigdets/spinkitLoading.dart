import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

spinkitLoading() {
  return Padding(
    padding: EdgeInsets.all(10),
    child: SpinKitCircle(
      itemBuilder: (_, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? Colors.red : Colors.blue,
          ),
        );
      },
      // controller: AnimationController(
      //     vsync: this, duration: const Duration(milliseconds: 2200)),
    ),
  );
}
