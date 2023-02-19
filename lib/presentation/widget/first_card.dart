import 'package:flutter/material.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class FirstCard extends StatelessWidget {
  const FirstCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return DetailPage();
            }));
      },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width:120,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
              child: Container(color: Colors.grey.shade300,)
              //child: Image.asset('name'),
            ),
          ),
        ));
  }
}
