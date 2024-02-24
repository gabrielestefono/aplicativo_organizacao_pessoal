import 'package:client/classes/objetivo.dart';
import 'package:client/classes/objetivos.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  // * Construtor privado
  DioService._();

  // * Singleton
  static final DioService _instancia = DioService._();

  // * Factory
  factory DioService() {
    return _instancia;
  }

  // * Atributos
  // Dio, pacote para requisições HTTP
  final Dio _dio = Dio();
  // Token de autenticação, salvo ao fazer login, usado para fazer requisições autenticadas
  late String? _token;
  // URL da API
  final String _url = 'http://webestcoding.com.br/api/';
  // Código de erro, usado para mostrar mensagens de erro ao usuário
  late int? _erro;

  ///
  /// Método Login.
  /// Primeiro ele aumenta o tempo de espera para a resposta do servidor.
  /// Depois ele faz a requisição POST para a rota de login.
  /// Se a resposta for 401, ele retorna false #TODO: Mostrar modal de erro.
  /// Se a resposta for 200, ele salva o token e retorna true.
  /// Se ocorrer um erro, ele retorna false #TODO: Mostrar modal de erro.
  ///
  Future<bool> login(email, senha) async {
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    try {
      Response response = await _dio.post(
        '${_url}login',
        data: {
          'email': email,
          'password': senha,
        },
      );
      if (response.statusCode == 401) {
        _erro = response.statusCode;
        return false;
      }
      String token = response.data['token'];
      if (await saveToken(token)) {
        _token = token;
      }
      return true;
    } on DioError catch (error) {
      debugPrint(error.message);
      _erro = error.response?.statusCode;
      return false;
    }
  }

  ///
  /// Método para pegar os objetivos do usuário.
  Future<List<Objetivo>> getObjetivos() async {
    try {
      Response response = await _dio.get(
        '${_url}objetivo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<Objetivo> objetivos = [];
        for (var objetivo in response.data) {
          objetivos.add(Objetivo.fromJson(objetivo));
        }
        return objetivos;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message);
      return [];
    }
  }

  ///
  /// Método para recuperar o token salvo no SharedPreferences.
  /// Se o token existir, ele é salvo no atributo _token e retornado.
  /// Se não existir, é retornado uma string vazia.
  /// Se ocorrer um erro, é retornado uma string vazia.
  ///
  Future<String> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        _token = token;
        return token;
      } else {
        return '';
      }
    } catch (error) {
      debugPrint(error.toString());
      return '';
    }
  }

  Future<bool> saveToken(String token) async {
    bool retorno = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('token', token)
        .then(
          (value) => {retorno = true},
        )
        .catchError(
          (error) => {
            retorno = false,
          },
        );
    return retorno;
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<int?> getErro() async {
    return _erro;
  }
}
