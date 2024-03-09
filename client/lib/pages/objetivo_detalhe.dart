import 'package:client/classes/objetivo.dart';
import 'package:client/classes/objetivos.dart';
import 'package:client/pages/app_bar.dart';
import 'package:client/pages/criar_objetivo.dart';
import 'package:client/pages/dashboard.dart';
import 'package:client/services/dio.dart';
import 'package:flutter/material.dart';

class ObjetivoDetalhe extends StatefulWidget {
  final Objetivo objetivo;
  const ObjetivoDetalhe(this.objetivo, {super.key});

  @override
  State<ObjetivoDetalhe> createState() => _ObjetivoDetalheState();
}

class _ObjetivoDetalheState extends State<ObjetivoDetalhe> {
  final _formKey = GlobalKey<FormState>();
  String _nome = "";
  int? _id;
  bool retornou = false;

  @override
  void initState() {
    super.initState();
    _id = widget.objetivo.id;
  }

  void atualizar() {
    // Primeiro, atualiza os objetivos.
    DioService().getObjetivos().then((objetivos) {
      setState(() {
        Objetivos().objetivos = objetivos;
      });
      // Depois da atualização, remove a tela atual da pilha e navega para Dashboard.
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(id: widget.objetivo.id)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SizedBox(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Color(0xFF333333)),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFFFFFFF)),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo deve ser preenchido!";
                              }
                              _nome = value;
                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        margin: const EdgeInsets.only(left: 20),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CriarObjetivo(_nome, _id ?? 0, 1, null, null, atualizar),
                                ),
                              ).then((value) {
                                _nome = "";
                              });
                            }
                          },
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
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    widget.objetivo.objetivo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    widget.objetivo.descricao,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    widget.objetivo.descricao,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    widget.objetivo.concluido ? "Concluído" : "Não Concluído",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    widget.objetivo.prioridade == 0
                        ? "Baixa"
                        : widget.objetivo.prioridade == 1
                            ? "Média"
                            : "Alta",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    '${DateTime.parse(widget.objetivo.createdAt).day.toString().padLeft(2, '0')} / ${DateTime.parse(widget.objetivo.createdAt).month.toString().padLeft(2, '0')} / ${DateTime.parse(widget.objetivo.createdAt).year.toString()}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
