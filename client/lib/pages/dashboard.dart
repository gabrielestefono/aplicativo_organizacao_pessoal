import 'package:client/classes/objetivo.dart';
import 'package:client/classes/objetivos.dart';
import 'package:client/pages/app_bar.dart';
import 'package:client/pages/criar_objetivo.dart';
import 'package:client/services/dio.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final int? id;
  const Dashboard({this.id, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Objetivo> objetivos = [];
  late int? _id;
  List<double> _heightPorId = [];
  String _nome = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pegarObjetivos(false);
  }

  void pegarObjetivos(bool atualizar) {
    _id = widget.id ?? 0;
    if (_id == 0 || atualizar) {
      DioService().getObjetivos().then(
            (value) => {
              setState(
                () {
                  Objetivos().objetivos = value;
                  objetivos = value.where((e) => e.parentId == _id).toList();
                  _heightPorId = List.generate(Objetivos().objetivos.length, (index) => 0);
                },
              ),
            },
          );
    } else {
      objetivos = Objetivos().objetivos.where((e) => e.parentId == _id).toList();
      _heightPorId = List.generate(Objetivos().objetivos.length, (index) => 0);
    }
  }

  bool temFilhos(Objetivo objetivo) {
    return Objetivos().objetivos.where((e) => e.parentId == objetivo.id).isNotEmpty;
  }

  double mudarWidthPorId(int id) {
    if (_heightPorId[id] == 200) {
      setState(() {
        _heightPorId[id] = 0;
      });
    } else {
      setState(() {
        _heightPorId[id] = 200;
      });
    }
    return _heightPorId[id];
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
                                  builder: (context) => CriarObjetivo(_nome, _id ?? 0, 1, null),
                                ),
                              ).then((value) {
                                pegarObjetivos(true);
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
                Center(
                  child: Column(
                    children: objetivos
                        .map(
                          (objetivo) => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF444444),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
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
                                          child: temFilhos(objetivo)
                                              ? SizedBox(
                                                  width: 30,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      mudarWidthPorId(objetivo.id);
                                                    },
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                                                    ),
                                                    child: Image.asset(
                                                      width: 25,
                                                      height: 25,
                                                      _heightPorId[objetivo.id] == 0 ? "assets/images/accordion.png" : "assets/images/accordion_open.png",
                                                    ),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      objetivo.concluido = !objetivo.concluido;
                                                    });
                                                    DioService().marcarComoConcluido(objetivo.id).then((value) {
                                                      if (!value) {
                                                        setState(() {
                                                          objetivo.concluido = !objetivo.concluido;
                                                        });
                                                      }
                                                    });
                                                  },
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
                                                      objetivo.concluido ? const Color(0XFF5E60CE) : const Color(0XFFFFFFFF),
                                                    ),
                                                  ),
                                                  child: const Text(''),
                                                ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              fixedSize: MaterialStateProperty.all<Size>(const Size(250, 50)),
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                              elevation: MaterialStateProperty.all(0),
                                              alignment: Alignment.centerLeft,
                                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                                            ),
                                            onPressed: () {
                                              if (temFilhos(objetivo)) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(id: objetivo.id)));
                                              } else {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context) => ObjetivoDetalhe(objetivo)));
                                              }
                                            },
                                            child: Text(
                                              objetivo.objetivo.length > 30 ? "${objetivo.objetivo.substring(0, 30)}..." : objetivo.objetivo,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              //TODO: Abrir página de criação/edição de objetivo
                                              //TODO: Enviar id do objetivo para a página
                                              //TODO: Enviar dados para uma requisição de edição
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CriarObjetivo(objetivo.objetivo, objetivo.parentId, 1, objetivo),
                                                ),
                                              );
                                            },
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
                                          width: 30,
                                          margin: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              //TODO: Fazer modal de confirmação
                                              //TODO: Enviar requisição de deleção
                                            },
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
                              temFilhos(objetivo)
                                  ? AnimatedContainer(
                                      duration: const Duration(milliseconds: 800),
                                      curve: Curves.fastOutSlowIn,
                                      height: _heightPorId[objetivo.id],
                                      color: const Color(0xFF444444),
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                        width: MediaQuery.of(context).size.width,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: _heightPorId[objetivo.id] == 200
                                                ? [
                                                    // TODO: Ajustar o espaçamento entre os textos
                                                    // TODO: Ajustar a largura do texto de objetivo.objetivo
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width - 40,
                                                      child: Text(
                                                        "Objetivo: ${objetivo.objetivo}",
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width - 40,
                                                      child: Text(
                                                        "Descrição: ${objetivo.descricao}",
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width - 40,
                                                      child: Text(
                                                        "Concluído: ${objetivo.concluido}",
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width - 40,
                                                      child: Text(
                                                        "Arquivado: ${objetivo.arquivado}",
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width - 40,
                                                      child: Text(
                                                        "Prioridade: ${objetivo.prioridade}",
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
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
