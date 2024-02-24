import 'package:client/classes/objetivo.dart';
import 'package:client/pages/app_bar.dart';
import 'package:client/services/dio.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Objetivo> objetivos = [];

  @override
  void initState() {
    super.initState();
    DioService().getObjetivos().then((value) => {
          setState(() {
            objetivos = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF333333)),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 80,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 50,
                            width: 250,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                filled: true,
                                fillColor: Color(0xFF444444),
                                hintText: "Adicione um Novo Objetivo",
                                hintStyle: TextStyle(
                                  color: Color(0xFF808080),
                                ),
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      margin: const EdgeInsets.only(top: 50, left: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF1E6F9F),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                          'Criar',
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: objetivos
                        .map(
                          (objetivo) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                width: 370,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF444444),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      width: 20,
                                      height: 20,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                                side: BorderSide(
                                                  color: Color(0XFF4EA8DE),
                                                  width: 3,
                                                ),
                                              ),
                                            ),
                                            backgroundColor: MaterialStateProperty.all(
                                              objetivo.concluido ? const Color(0XFFFF0000) : const Color(0XFFFFFFFF),
                                            )),
                                        child: const Text(''),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        objetivo.objetivo,
                                        style: const TextStyle(color: Color(0xFFFFFFFF)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        child: Image.asset(
                                          width: 25,
                                          height: 25,
                                          "assets/images/edit.png",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      margin: const EdgeInsets.only(right: 20),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        child: Image.asset(
                                          width: 25,
                                          height: 25,
                                          "assets/images/trash.png",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
