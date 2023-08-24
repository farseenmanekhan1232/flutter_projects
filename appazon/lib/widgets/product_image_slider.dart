import 'package:flutter/material.dart';

class ProductImageSlider extends StatefulWidget {
  const ProductImageSlider({super.key, required this.images});

  final List images;

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _pagePosition = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (value) {
              setState(() {
                _pagePosition = value;
              });
            },
            pageSnapping: true,
            itemBuilder: (context, pagePosition) {
              return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Hero(
                  tag: widget.images[0],
                  child: Image.network(
                    widget.images[pagePosition],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(137, 110, 110, 110),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "${_pagePosition + 1} of ${widget.images.length}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
