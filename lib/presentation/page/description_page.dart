import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  const DescriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'Description',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo in vitae turpis massa sed elementum tempus egestas sed. Quam pellentesque nec nam aliquam sem et tortor consequat id. Vivamus at augue eget arcu dictum. Nunc scelerisque viverra mauris in. Malesuada fames ac turpis egestas. Mattis aliquam faucibus purus in massa tempor nec feugiat. Non pulvinar neque laoreet suspendisse interdum. Faucibus turpis in eu mi. Sapien faucibus et molestie ac feugiat. Tempus imperdiet nulla malesuada pellentesque elit eget gravida.',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
