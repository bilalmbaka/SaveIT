import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff085e55),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: Image.asset("assets/images/save.png"),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Save It",
            style: TextStyle(
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "A Multi plaform status Saver",
            softWrap: true,
            maxLines: 4,
            style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20c65a)),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: const Text(
              "View the status on the app and come here to download viewed status.",
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
