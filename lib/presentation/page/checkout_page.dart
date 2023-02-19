import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Checkout',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(
                              width: 14,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Ibu Sumi'),
                                Text('Jln Ujung Perjuangan No. 100'),
                                Text('0811 - 1122 - 2315')
                              ],
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios_rounded))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Estimasi Pengiriman'),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Sabtu 07 Januari 2023'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        'Maksimal 1 jam setelah pembayaran selama jam operasional (09.00 - 15.00)')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 80,

                        child:Card(child: Text('Product $index'),)
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('Metode Pembayaran'),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('SubTotal Produk'),
                        Text('Biaya Pengiriman'),
                        Text('Total Belanja'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                      Text('Rp 235.000'),
                      Text('Rp 0'),
                      Text('Rp 235.000'),
                    ],)
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 50,
                //width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orangeAccent),
                child: TextButton(
                  onPressed: () {},
                  child: Text('MAKE ORDER',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontSize: 16)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
