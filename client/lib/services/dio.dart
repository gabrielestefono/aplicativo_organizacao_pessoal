import 'package:client/classes/objetivo.dart';
import 'package:client/classes/objetivos.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  DioService._();

  static final DioService _instancia = DioService._();

  factory DioService() {
    return _instancia;
  }

  final Dio _dio = Dio();
  late String? _token;
  final String _url = 'https://webestcoding.com.br/api/';

  Future<void> login(email, senha) async {
    try {
      Response response = await _dio.post(
        '${_url}login',
        data: {
          'email': email,
          'password': senha,
        },
      );
      String _token = response.data['token'];
      getObjetivos();
      saveToken(_token);
    } on DioError catch (error) {
      print("Errrrrrrrou");
      print(error);
    }
  }

  Future<void> registrar(email, senha, nome) async {
    try {
      Response response = await _dio.post(
        '${_url}registrar',
        data: {
          'email': email,
          'password': senha,
          'name': nome,
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

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      _token = token;
      getObjetivos();
      return token;
    } else {
      return '';
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token).then((value) => print(_token));
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
