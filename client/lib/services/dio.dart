import 'package:client/classes/objetivo.dart';
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
  /// Método para registrar um usuário.
  /// Primeiro ele aumenta o tempo de espera para a resposta do servidor.
  /// Depois ele faz a requisição POST para a rota "registrar".
  /// Se a resposta for 201, ele retorna true.
  /// Se ocorrer um erro, ele retorna false.
  /// TODO: Mostrar modal de erro.
  /// TODO: Salvar o código de erro no atributo _erro.
  /// TODO: Talvez, fecha a aplicação.
  ///
  Future<bool> registrar(nome, email, senha, confirmacaoSenha) async {
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    try {
      Response resposta = await _dio.post('${_url}registrar', data: {"name": nome, "email": email, "password": senha, "password_confirmation": confirmacaoSenha});
      if (resposta.statusCode != 201) {
        return false;
      }
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  ///
  /// Método para pegar os objetivos do usuário.
  /// Primeiro ele faz a requisição GET para a rota de objetivos.
  /// Se a resposta for 200, ele retorna uma lista de Objetivos.
  /// Se ocorrer um erro, ele retorna uma lista vazia.
  /// Se o token não existir, ele retorna uma lista vazia.
  /// Se o token expirar, ele retorna uma lista vazia.
  /// Se o token for inválido, ele retorna uma lista vazia.
  /// TODO: Se o token for inválido, ele remove o token do SharedPreferences.
  /// TODO: Retornar para a página de login.
  ///
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

  ///
  /// Método para salvar o token no SharedPreferences.
  /// Se o token for salvo com sucesso, é retornado true.
  /// Se ocorrer um erro, é retornado false.
  /// Se o token não for salvo, é retornado false.
  /// TODO: Em caso de erro, mostrar modal de erro.
  /// TODO: Em caso de erro, retornar para a página de login.
  /// TODO: Em caso de erro, salvar o código de erro no atributo _erro.
  ///
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

  ///
  /// Método para remover o token do SharedPreferences.
  /// Se o token for removido com sucesso, é retornado true.
  /// Se ocorrer um erro, é retornado false.
  /// Se o token não for removido, é retornado false.
  /// TODO: Em caso de erro, mostrar modal de erro.
  /// TODO: Em caso de erro, dar um jeito de forçar a remoção do token.
  /// TODO: Em caso de erro, retornar para a página de login.
  /// TODO: Em caso de erro, salvar o código de erro no atributo _erro.
  ///
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  ///
  /// Método para recuperar o código de erro.
  /// Dependendo do erro, deve executar uma ação diferente.
  ///
  Future<int?> getErro() async {
    return _erro;
  }

  ///
  /// Método para criar um objetivo.
  /// Primeiro ele faz a requisição POST para a rota de objetivos.
  /// Se a resposta for 201, ele retorna true.
  /// Se ocorrer um erro, ele retorna false.
  /// Se o token não existir, ele retorna false.
  /// Se o token expirar, ele retorna false.
  /// Se o token for inválido, ele retorna false.
  ///
  Future<bool> criarObjetivo(String objetivo, String descricao, int prioridade, bool concluido, bool arquivado, int parentId, int userId) async {
    try {
      Response response = await _dio.post(
        '${_url}objetivo',
        data: {
          'objetivo': objetivo,
          'descricao': descricao,
          'prioridade': prioridade,
          'concluido': concluido,
          'arquivado': arquivado,
          'parent_id': parentId,
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioError catch (error) {
      debugPrint(error.message);
      return false;
    }
  }

  Future<bool> atualizarObjetivo(int id, String objetivo, String descricao, int prioridade, bool concluido, bool arquivado, int parentId, int userId) async {
    try {
      Response response = await _dio.put(
        '${_url}objetivo/$id',
        data: {
          'objetivo': objetivo,
          'descricao': descricao,
          'prioridade': prioridade,
          'concluido': concluido,
          'arquivado': arquivado,
          'parent_id': parentId,
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (error) {
      debugPrint(error.message);
      return false;
    }
  }

  Future<bool> marcarComoConcluido(id) async {
    try {
      Response response = await _dio.patch(
        '${_url}objetivo-concluido/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (error) {
      debugPrint(error.message);
      return false;
    }
  }
}
