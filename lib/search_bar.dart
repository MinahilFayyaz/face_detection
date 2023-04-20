import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Expanded(
        child: TextField(
          controller: _search,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: InkWell(
                onTap: (){},
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              /*prefixIconConstraints: const BoxConstraints(
                  maxHeight: 20,
                  maxWidth: 30,
                ),*/
              border: InputBorder.none,
              hintText: 'Search Wallpaper',
              hintStyle: const TextStyle(color: Colors.grey)
          ),
        ),
      ),
    );
  }
}
