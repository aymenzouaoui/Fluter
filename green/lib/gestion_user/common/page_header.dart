import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Lottie.network(
              'https://lottie.host/f4b71b29-8c5e-46d3-b5f7-20d81556fee9/g1qHJZF2JF.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),);
  }
}
