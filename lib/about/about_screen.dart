import 'package:flutter/material.dart';
import 'package:my_governate_app/about/about_text_container.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
              "assets/icons/myGovIcon.png",
              scale: 1.9,
            )),
            const Text("About Our Application",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 19)),
           
          const   AboutTextContainer(title: "App Description:",text: "MyGov is your local community and service app, helping residents stay update with news, events, traffic and services in your governate",),
        const  AboutTextContainer(title:"Our Mission:" ,text: "Our mission is to connect residents with real_time updates and make local life easier",),
          const  AboutTextContainer(title:"Credits:" ,text: "Developed by GDG group ",),


          ],
        ),
      ),
    );
  }
}

