import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fydp_app/business_logic/bloc/weight_bloc.dart';
import 'package:fydp_app/presentation/constants.dart';
import 'package:http/http.dart' as http;

class Tray_weight extends StatefulWidget {
  const Tray_weight({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<Tray_weight> createState() => _Tray_weightState();
}

class _Tray_weightState extends State<Tray_weight> {
  double weight = 0;
  Timer? timer;
  void getFirebase() async {
    const url =
        'https://fypd-d0e2e-default-rtdb.asia-southeast1.firebasedatabase.app/test.json?orderBy="Timestamp"&limitToLast=1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("200");
      } else {
        print("connection fail to firebase");
      }
      var extractedData = jsonDecode(response.body);
      print(extractedData);
      setState(() {
        weight = Map<String, dynamic>.from(extractedData)
            .values
            .toList()[0]['Weight_in_gram']
            .toDouble();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getFirebase());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Image.asset(
              "assets/images/Tray.png",
              fit: BoxFit.fill,
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Weight : $weight',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFF0C9869)),
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
