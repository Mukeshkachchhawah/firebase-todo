import 'package:flutter/material.dart';

hSpace({double mHeight = 20}) {
  return SizedBox(
    height: mHeight,
  );
}

wSpace({double mWidth = 20}) {
  return SizedBox(
    width: mWidth,
  );
}

TextStyle textStyleFont30() {
  return const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Poppins");
}

Widget SocilMedia(VoidCallback ontap, String image) {
  return InkWell(
    onTap: ontap,
    child: Container(
      height: 50,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black)),
      child: Center(
        child: Image.asset(
          image,
          height: 30,
          width: 50,
        ),
      ),
    ),
  );
}

Widget elevatedButton(
    {required String text,
    required Color colors,
    required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 50,
      width: double.infinity,
      decoration:
          BoxDecoration(color: colors, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      )),
    ),
  );
}
