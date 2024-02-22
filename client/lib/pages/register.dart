import 'package:client/pages/app_bar.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
          child: Center(
            child: Column(
              children: [
                Form(
                  child: Center(
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFFFFFFF)),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          filled: true,
                          fillColor: Color(0xFF444444),
                          hintText: "Nome",
                          hintStyle: TextStyle(
                            color: Color(0xFF808080),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                      ),
                    ),
                  ),
                ),
                Form(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 50,
                        width: 250,
                        child: TextFormField(
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
                    ),
                  ),
                ),
                Form(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 50,
                        width: 250,
                        child: TextFormField(
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
                    onPressed: () {},
                    child: const Text(
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                      'Registrar',
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
