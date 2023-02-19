import 'package:flutter/material.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class SecondCart extends StatelessWidget {
  const SecondCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return DetailPage();
            }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                //width: 140,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
              child: SizedBox(
                  width: 140,
                  child: Text(
                    'Product Name',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: SizedBox(
                  width: 140,
                  child: Text(
                    'Rp 100.200',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
