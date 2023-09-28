import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class ProductImageSlider extends StatefulWidget {
  const ProductImageSlider({super.key, required this.images});

  final List<dynamic> images;

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _pagePosition = 0;

  late MultiImageProvider _multiImageProvider;

  @override
  void initState() {
    _multiImageProvider = MultiImageProvider(
      List.from(
        (widget.images).map((imageUrl) => Image.network(imageUrl).image),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? 400
              : MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
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
        SizedBox(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? 400
              : MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        showImageViewerPager(
                          context,
                          _multiImageProvider,
                          doubleTapZoomable: true,
                          swipeDismissible: true,
                          immersive: true,
                        );
                      },
                      icon: const Icon(
                        Icons.fullscreen,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? 400
              : MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 110, 110, 110),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${_pagePosition + 1} of ${widget.images.length}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
