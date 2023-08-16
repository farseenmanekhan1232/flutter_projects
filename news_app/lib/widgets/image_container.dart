import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  ImageContainer({
    super.key,
    this.width,
    this.height,
    this.child,
    this.padding,
    this.margin,
    required this.url,
  });

  final String url;
  Widget? child;
  double? width;
  double? height;
  double? padding;
  double? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 300,
      width: width ?? 300,
      padding: EdgeInsets.all(padding ?? 20),
      margin: EdgeInsets.all(margin ?? 20),
      child: Stack(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(
                  url,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(96, 0, 0, 0),
                    Color.fromARGB(202, 0, 0, 0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
