import 'package:client/pages/dashboard.dart';
import 'package:client/pages/login.dart';
import 'package:client/services/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void fazerLogin() {
    setState(() {
      // Só atualiza o estado, não faz mais nada
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<String>(
        future: DioService().getToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // TODO: Finalizar o app em caso de erro
              return Text('Erro: ${snapshot.error}');
            } else if (snapshot.data == '') {
              return Login(fazerLogin);
            } else {
              return const Dashboard();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
