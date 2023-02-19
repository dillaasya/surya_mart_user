import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff025ab4),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              ProfilePicture(),
              SizedBox(
                height: 60,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  child: ProfileMenu())
            ],
          ),
        ),
      ),
    );
  }

  Widget Header() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ProfilePicture() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Center(
          child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.shade300),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Max Havelar',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      )),
    );
  }

  Widget ProfileMenu() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 60,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Edit Profile')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Shipping Address')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Order History')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.reorder_outlined),
                    SizedBox(
                      width: 16,
                    ),
                    Text('My Reviews')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Refund requests')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.help_outline_rounded),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Help Center')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Privacy & Policy')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          Container(
            height: 60,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: 16,
                    ),
                    Text('About')
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(' App v1.0.0'),
          )
        ],
      ),
    );
  }
}
