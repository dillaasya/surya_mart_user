import 'package:flutter/material.dart';
import 'package:surya_mart_v1/presentation/page/checkout_page.dart';
import 'package:surya_mart_v1/presentation/widget/third_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool? isChecked = false;
  bool? isCardChecked = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text(
            'Cart',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                        activeColor: Colors.orangeAccent,
                        value: isChecked,
                        onChanged: (newValue) {
                          setState(() {
                            isChecked = newValue;
                          });
                        }),
                    //SizedBox(width: 10,),
                    Text('Select All'),
                  ],
                ),
                ListView.builder(
                  itemCount: 4,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ThirdCard(isChecked: isCardChecked,),
                          SizedBox(height: 8,),
                        ],
                      );
                      //return Container(height: 180, color: Colors.yellow,);
                    }

                ),
              ],
            ),
          ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL'),
                        SizedBox(height: 4,),
                        Text('Rp 1.200.000', style: TextStyle(color: Colors.redAccent),)
                      ],
                    )
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      //width: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orangeAccent),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return CheckoutPage();
                              }));
                        },
                        child: Text('CHECKOUT',
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
}
