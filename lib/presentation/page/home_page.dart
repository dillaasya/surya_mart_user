import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:surya_mart_v1/presentation/page/cart_page.dart';
import 'package:surya_mart_v1/presentation/widget/first_card.dart';
import 'package:surya_mart_v1/presentation/widget/second_cart.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff025ab4),
        body: SingleChildScrollView(
          child: Column(
            children: [
              header(),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              color: Colors.grey,
                              child: const Icon(Icons.circle_outlined)),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text('POIN'),
                        ],
                      ),
                      const Text('6.700')
                    ],
                  ),
                ),
              ),
              carousel(),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    productSection('TOP SELLING'),
                    productSection('BEST DEALS'),
                    recomendation(),
                    article(),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Amalia Putri',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CartPage();
                }));
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  final List<Widget> imgList = [
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  ];

  Widget carousel() {
    int current = 0;
    final CarouselController controller = CarouselController();

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: controller,
            items: imgList.map((e) => SizedBox(height: 125, child: e)).toList(),
            options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                autoPlay: true,
                onPageChanged: (index, x) {
                  setState(() {
                    current = index;
                  });
                }),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList
                  .asMap()
                  .entries
                  .map((e) => GestureDetector(
                        onTap: () => controller.animateToPage(e.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(current == e.key ? 0.9 : 0.4)),
                        ),
                      ))
                  .toList())
        ],
      ),
    );
  }

  Widget productSection(String subHeader) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subHeader),
                TextButton(
                  onPressed: () {},
                  child: const Text('SEE ALL'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                /*separatorBuilder: (context, _) => SizedBox(
                  width: 10,
                ),*/
                itemBuilder: (context, index) {
                  return Row(
                    children: const [
                      //SizedBox(width: 20),
                      FirstCard(),
                      SizedBox(width: 20),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget recomendation() {
    return Padding(
      padding: const EdgeInsets.only(top: 27, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RECOMENDATION',
          ),
          const SizedBox(
            height: 27,
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 20),
              itemCount: 6,
              itemBuilder: (context, index) {
                return const SecondCart();
                //return Container(height: 180, color: Colors.yellow,);
              }),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text('SEE ALL'),
                  onPressed: () {},
                )),
          ),
        ],
      ),
    );
  }

  Widget article() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ARTICLE',
          ),
          const SizedBox(
            height: 27,
          ),
          ListView.builder(
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Artikel $index'),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus in massa tempor nec feugiat nisl pretium fusce id. Condimentum mattis pellentesque id nibh.',
                      maxLines: 3,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                );
                //return Container(height: 180, color: Colors.yellow,);
              }),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text('SEE ALL'),
                  onPressed: () {},
                )),
          ),
        ],
      ),
    );
  }
}
