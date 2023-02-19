import 'package:flutter/material.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class ThirdCard extends StatefulWidget {
  bool? isChecked;

  ThirdCard({Key? key, this.isChecked}) : super(key: key);

  @override
  State<ThirdCard> createState() => _ThirdCardState();
}

class _ThirdCardState extends State<ThirdCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailPage();
        }));
      },
      child: Row(
        children: [
          Checkbox(
              activeColor: Colors.orangeAccent,
              value: widget.isChecked,
              onChanged: (newValue) {
                setState(() {
                  widget.isChecked = newValue;
                });
              }),
          //SizedBox(width: 16,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
                color: Colors.grey.shade300,

              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Name'),
              Text('Rp 1.200.000'),
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
            ],
          ),
        ],
      ),
    );
  }
}
