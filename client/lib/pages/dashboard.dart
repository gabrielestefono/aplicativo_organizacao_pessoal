import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Text(
            style: TextStyle(
              color: Color(0XFF4EA8DE),
              fontWeight: FontWeight.w900
            ),
            "Organização "
          ),
          Text(
            style: TextStyle(
              color: Color(0XFF5E60CE),
              fontWeight: FontWeight.w900
            ),
            "Pessoal"
          ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF333333)
        ),
      )
    );
  }
}