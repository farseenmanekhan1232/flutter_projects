import 'package:appazon/providers/products.dart';
import 'package:appazon/widgets/half_icon.dart';
import 'package:appazon/widgets/product_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOverview extends StatefulWidget {
  const ProductOverview({
    super.key,
    required this.product,
    required this.currentPrice,
  });

  final Map<String, dynamic> product;

  final void Function(int) currentPrice;

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  late int price;
  bool selected = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    price = widget.product['price'];
    widget.currentPrice(-1);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductImageSlider(
          images: widget.product['images'],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                widget.product['title'],
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 180, 180, 180),
              ),
              child: Text(
                widget.product['brand'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "\$$price",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "\$${(price + price * widget.product['discountPercentage'] / 100).toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 121, 112),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 20, top: 10),
                  padding: const EdgeInsets.only(
                      top: 8, left: 20, right: 20, bottom: 8),
                  decoration: BoxDecoration(
                    color: widget.product['stock'] > 0
                        ? Colors.yellow
                        : Colors.grey,
                  ),
                  child: Text(
                    widget.product['stock'] > 0 ? "In Stock" : "Out of Stock",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 17, 0),
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                "${widget.product['discountPercentage'].toStringAsFixed(0)}% discount",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                "${widget.product['description']}",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const Text(
                    'Ratings : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('(${widget.product['rating'].toStringAsFixed(1)})'),
                  for (int i = 1; i <= widget.product['rating']; i++)
                    const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amber,
                    ),
                  if (widget.product['rating'] -
                          (widget.product['rating'].toInt()) >
                      0)
                    const HalfFilledIcon(
                      icon: Icons.star_rate_rounded,
                      size: 25,
                      color: Colors.amber,
                    )
                ],
              ),
            ),
            if (widget.product['variants'] != null)
              Container(
                margin: const EdgeInsets.all(10),
                child: DropdownMenu(
                  controller: _controller,
                  leadingIcon: selected
                      ? IconButton(
                          onPressed: () {
                            Provider.of<Products>(context, listen: false)
                                .refreshScroll();
                            widget.currentPrice(-1);
                            setState(() {
                              selected = false;
                              price = widget.product['price'];
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        )
                      : null,
                  menuStyle: const MenuStyle(
                    elevation: null,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(90, 0, 0, 0),
                      ),
                    ),
                  ),
                  hintText: "Others",
                  onSelected: (value) {
                    Provider.of<Products>(context, listen: false)
                        .refreshScroll();
                    setState(() {
                      price = widget.product['price'] + value as int;
                      selected = true;

                      int variant = -1;

                      for (int i = 0;
                          i < widget.product['variants'].length;
                          i++) {
                        if (widget.product['variants'][i][0] ==
                            _controller.text) {
                          variant = i;
                          break;
                        }
                      }

                      widget.currentPrice(variant);
                    });
                  },
                  initialSelection: null,
                  dropdownMenuEntries: [
                    for (final variant in widget.product['variants'])
                      DropdownMenuEntry(label: variant[0], value: variant[1])
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
