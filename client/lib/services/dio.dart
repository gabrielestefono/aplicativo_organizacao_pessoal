import 'package:client/classes/objetivo.dart';
import 'package:client/classes/objetivos.dart';
import 'package:dio/dio.dart';

class DioService {
  DioService._();

  static final DioService _instancia = DioService._();

  factory DioService() {
    return _instancia;
  }

  final Dio _dio = Dio();
  late String? _token;
  final String _url = 'http://192.168.0.105:8000/api/';

  // Variáveis temporárias
  final String _email = 'gabrielestefono@hotmail.com';
  final String _senha = '12345678';
  final String _nome = 'Gabriel Estefono';

  Future<void> login() async {
    try {
      Response response = await _dio.post(
        '${_url}login',
        data: {
          'email': _email,
          'password': _senha,
        },
      );
      _token = response.data['token'];
    } on DioError catch (error) {
      // Retornar para a tela de login
    }
  }

  Future<void> registrar() async {
    try {
      Response response = await _dio.post(
        '${_url}registrar',
        data: {
          'email': _email,
          'password': _senha,
          'name': _nome,
        },
      );

      if (response.statusCode == 200) {
        // Redirecionar para a tela de login
      } else {
        // Retornar para a tela de registro com a mensagem de erro
      }
    } on DioError catch (error) {
      // Retornar para a tela de registro com a mensagem de erro
    }
  }

  Future<void> getObjetivos() async {
    try {
      Response response = await _dio.get(
        '${_url}objetivo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      // Transformar o json em um objeto
      List<dynamic> jsonList = response.data;
      List<Objetivo> objetivos = jsonList.map((json) => Objetivo.fromJson(json)).toList();
      Objetivos().objetivos = objetivos;
    } on DioError catch (error) {
      // avisar o usuário que ocorreu um erro
      print(error);
    }
  }
}
