import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  //String subTitle;
  const Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<Widget> imgList = [
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/easy-shopping.jpg',
          fit: BoxFit.fill,
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/quality.jpg',
          fit: BoxFit.fill,
        ),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child:ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/images/best-prices.jpg',
          fit: BoxFit.fill,
        ),
      ),
    ),
  ];

  int current = 0;

  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: controller,
            items: imgList.map((e) => e).toList(),
            options: CarouselOptions(
              viewportFraction: 0.85,
                enlargeCenterPage: true,
                aspectRatio: 12 / 4.5,
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
                        onTap: () => controller.jumpToPage(e.key),
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 2.0),
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
}
