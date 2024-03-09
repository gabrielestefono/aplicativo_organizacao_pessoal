import 'package:client/classes/objetivo.dart';
import 'package:client/pages/app_bar.dart';
import 'package:client/services/dio.dart';
import 'package:flutter/material.dart';

class CriarObjetivo extends StatefulWidget {
  final String objetivo;
  final int parentId;
  final int userId;
  final Objetivo? objetivoAntigo;
  final Function? atualizarEdicao;
  final Function? atualizar;
  const CriarObjetivo(this.objetivo, this.parentId, this.userId, this.objetivoAntigo, this.atualizarEdicao, this.atualizar, {super.key});

  @override
  State<CriarObjetivo> createState() => _CriarObjetivoState();
}

class _CriarObjetivoState extends State<CriarObjetivo> {
  final _formKey = GlobalKey<FormState>();
  bool alteracao = false;
  bool _registrando = false;
  String _objetivo = "";
  String _descricao = "";
  int _prioridade = 0;
  final bool _concluido = false;
  final bool _arquivado = false;
  int _parentId = 0;
  int _userId = 1;

  void tentarCriarObjetivo() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _registrando = true;
        if (!alteracao) {
          DioService().criarObjetivo(_objetivo, _descricao, _prioridade, _concluido, _arquivado, _parentId, _userId).then((value) {
            if (value) {
              if (widget.atualizar != null) {
                widget.atualizar!();
              }
              Navigator.pop(context);
            } else {
              setState(() {
                _registrando = false;
              });
            }
          });
        } else {
          DioService().atualizarObjetivo(widget.objetivoAntigo!.id, _objetivo, _descricao, _prioridade, _concluido, _arquivado, _parentId, _userId).then((value) {
            if (value) {
              widget.atualizarEdicao!();
              Navigator.pop(context);
            } else {
              setState(() {
                _registrando = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.objetivoAntigo != null) {
      _objetivo = widget.objetivoAntigo!.objetivo;
      _descricao = widget.objetivoAntigo!.descricao;
      _prioridade = widget.objetivoAntigo!.prioridade;
      alteracao = true;
    } else {
      _parentId = widget.parentId;
      _userId = widget.userId;
      _objetivo = widget.objetivo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.height - 80,
        decoration: const BoxDecoration(color: Color(0xFF333333)),
        child: Center(
          child: !_registrando
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 350,
                              clipBehavior: Clip.none,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "O campo deve ser preenchido!";
                                  }
                                  _objetivo = value;
                                  return null;
                                },
                                initialValue: _objetivo,
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Color(0xFFFFFFFF)),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFF444444),
                                  hintText: "Objetivo",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF808080),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                ),
                              ),
                            ),
                            Container(
                              width: 350,
                              margin: const EdgeInsets.only(top: 20),
                              decoration: const BoxDecoration(
                                color: Color(0xFF444444),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              clipBehavior: Clip.none,
                              child: TextFormField(
                                scrollPadding: const EdgeInsets.all(30),
                                initialValue: _descricao,
                                maxLines: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "O campo deve ser preenchido!";
                                  }
                                  _descricao = value;
                                  return null;
                                },
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Color(0xFFFFFFFF)),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFF444444),
                                  hintText: "Descrição",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF808080),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                ),
                              ),
                            ),
                            Container(
                              width: 350,
                              margin: const EdgeInsets.only(top: 20),
                              decoration: const BoxDecoration(
                                color: Color(0xFF444444),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              child: Theme(
                                data: ThemeData(
                                  canvasColor: const Color(0xFF444444),
                                ),
                                child: DropdownButtonFormField(
                                  value: _prioridade,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Prioridade",
                                    hintStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 0,
                                      child: Text(
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        "Prioridade Baixa",
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text(
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        "Prioridade Média",
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text(
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        "Prioridade Alta",
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    _prioridade = value as int;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      margin: const EdgeInsets.only(top: 20),
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
                        onPressed: tentarCriarObjetivo,
                        child: const Text(
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                          'Criar Objetivo',
                        ),
                      ),
                    ),
                  ],
                )
              : const CircularProgressIndicator(
                  backgroundColor: Color(0xFF333333),
                ),
        ),
      ),
    );
  }
}
