import 'package:flutter/material.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 110,
                color: Color(0xff025ab4),
                child: header(),
              ),
              DefaultTabController(
                length: 8,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [Tab(text: 'Tab 1'),Tab(text: 'Tab 1'),Tab(text: 'Tab 1'),Tab(text: 'Tab 1'),Tab(text: 'Tab 1'),Tab(text: 'Tab 1'),Tab(text: 'Tab 1'),Tab(text: 'Tab 1')])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: const Color(0x33ffffff),
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    //<-- SEE HERE
                    hintText: 'cari barang disini',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Container();
                }));
              },
              icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
