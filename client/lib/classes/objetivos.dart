import 'package:client/classes/objetivo.dart';

class Objetivos {
  List<Objetivo> objetivos = [];

  // Criar um construtor privado
  Objetivos._();

  // Criar uma instância privada
  static final Objetivos _instancia = Objetivos._();

  // Método Factory
  factory Objetivos() {
    return _instancia;
  }
}
