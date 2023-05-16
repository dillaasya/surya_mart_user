import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class ListCard extends StatefulWidget {
  final String? id;

  const ListCard(this.id, {Key? key}) : super(key: key);

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  String? name, description, price, weight, image, category, id;

  getProductById() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.id)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          id = value.id;
          name = value.data()?['name'];
          description = value.data()?['description'];
          price = value.data()?['price'].toString();
          weight = value.data()?['weight'].toString();
          image = value.data()?['image'];
          category = value.data()?['category'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductById();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailPage(widget.id);
          }));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14), bottom: Radius.circular(14)),
                    child: image == null
                        ? Icon(Icons.image_not_supported_outlined)
                        : Image.network(
                            image ?? '',
                            fit: BoxFit.scaleDown,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Text(
                    name.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Rp ${price.toString()}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
