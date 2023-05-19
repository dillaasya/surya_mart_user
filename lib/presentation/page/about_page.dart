import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(80),child: Container(color:const Color(0xff025ab4),child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                  child: Image.asset(
                    'assets/images/logo-suryamart-new.png',
                  )),
            ],
          ),
        ),),),
        body: SingleChildScrollView(
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Suryamart merupakan unit bisnis swalayan kepemilikan Universitas Muhammadiyah Sidoarjo yang bergerak di bidang bisnis eceran atau ritel produk rumah tangga, makanan serta produk terkait lainnya. Suryamat terdiri dari dua unit bertempat di Kampus 2 UMSIDA Jl Raya Gelam No 16 Candi, dan Kampus 1 UMSIDA Jl. Mojopahit No.666 B, Sidowayah, Celep. Suryamart beroperasi setiap hari pukul 08.00 hingga 21.00. Melalui aplikasi Suryamart kamu dapat melakukan transaksi tanpa harus datang ke toko dan barang belanjaanmu akan dikirim langsung kerumah selama pemesanan masuk pada jam kerja.',style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,)
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text('Get to know us more',style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Link(
                            uri: Uri.tryParse('uri'),
                            builder: (context, followLink) {
                              return InkWell(
                                onTap: followLink,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[600],
                                  ),
                                  child: const Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    size: 20,
                                  )),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Link(
                            uri: Uri.tryParse('uri'),
                            builder: (context, followLink) {
                              return InkWell(
                                onTap: followLink,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[400],
                                  ),
                                  child: const Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.tiktok,
                                    size: 20,
                                  )),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Link(
                            uri: Uri.tryParse('uri'),
                            builder: (context, followLink) {
                              return InkWell(
                                onTap: followLink,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[200],
                                  ),
                                  child: const Center(
                                      child: FaIcon(
                                    FontAwesomeIcons.twitter,
                                    size: 20,
                                  )),
                                ),
                              );
                            },
                          ),
                        ]),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
