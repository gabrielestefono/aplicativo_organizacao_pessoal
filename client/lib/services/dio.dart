class DioService {
  DioService._();

  static final DioService _instancia = DioService._();

  factory DioService() {
    return _instancia;
  }

  late String? _token;
  final String _url = 'http://vps51751.publiccloud.com.br/api/';
}
