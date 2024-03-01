import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFF000000),
      centerTitle: true,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Organização ", style: TextStyle(color: Color(0XFF4EA8DE), fontWeight: FontWeight.w900)),
          Text("Pessoal", style: TextStyle(color: Color(0XFF5E60CE), fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
