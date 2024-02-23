import 'package:client/pages/app_bar.dart';
import 'package:client/services/dio.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final VoidCallback fazerLogin;
  const Login(this.fazerLogin, {super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _logginIn = false;
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _senha = "";

  void tentarLogin() {
    debugPrint("Tentando login");
    if (_formKey.currentState!.validate()) {
      debugPrint(_email);
      debugPrint(_senha);
      debugPrint(_formKey.currentState!.validate() ? "Valido" : "Invalid");
      DioService().login(_email, _senha);
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
          child: !_logginIn
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: 250,
                              clipBehavior: Clip.none,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                                    return 'Por favor, insira um email válido';
                                  }
                                  _email = value;
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Color(0xFFFFFFFF)),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                  filled: true,
                                  fillColor: Color(0xFF444444),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF808080),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 250,
                                clipBehavior: Clip.none,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'O campo senha deve ser preenchido';
                                    }
                                    _senha = value;
                                    return null;
                                  },
                                  obscureText: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Color(0xFFFFFFFF)),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                    filled: true,
                                    fillColor: Color(0xFF444444),
                                    hintText: "Senha",
                                    hintStyle: TextStyle(
                                      color: Color(0xFF808080),
                                    ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                                  ),
                                ),
                              ),
                            ),
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
                        onPressed: tentarLogin,
                        child: const Text(
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                          ),
                          'Login',
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
