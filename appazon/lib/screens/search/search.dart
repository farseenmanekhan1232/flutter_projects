import 'package:appazon/providers/products.dart';
import 'package:appazon/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

  String field = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              onChanged: (value) {
                if (value != '') {
                  setState(() {
                    field = value;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "Search Products",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.text,
              focusNode: null,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ),
          ProductsList(
            productsFuture: Provider.of<Products>(
              context,
              listen: false,
            ).searchProduct(field),
            title: "Results",
          )
        ],
      ),
    );
  }
}
