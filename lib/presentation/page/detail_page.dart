import 'package:flutter/material.dart';
import 'package:surya_mart_v1/presentation/page/cart_page.dart';
import 'package:surya_mart_v1/presentation/page/description_page.dart';
import 'package:surya_mart_v1/presentation/widget/first_card.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void CustomBottomSheet() {
      showModalBottomSheet(
          isScrollControlled: true,
          //isDismissible: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          context: context,
          builder: (builder) {
            return AddToCart();
          });
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('PRODUCT NAME #01'),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Rp 1.200.000'),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DescriptionPage();
                  }));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey.shade300),
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('See Description'),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
              ),
            ),
            ProductSection('RELATED PRODUCT')
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      //width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: TextButton(
                        onPressed: () {
                          CustomBottomSheet();
                        },
                        child: Text('ADD TO CART',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      //width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orangeAccent),
                      child: TextButton(
                        onPressed: () {},
                        child: Text('BUY NOW',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ProductSection(String subHeader) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
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
                  child: Text('SEE ALL'),
                ),
              ],
            ),
          ),
          SizedBox(
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
                    children: [
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
}

class AddToCart extends StatelessWidget {
  const AddToCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 60, height: 60, color: Colors.grey.shade300),
                    SizedBox(width: 10),
                    Text('Product Name'),
                  ],
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.close))
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '2',
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CartPage();
                        }));
                      },
                      child: Text('ADD TO CART', style: TextStyle(color: Colors.black),),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
