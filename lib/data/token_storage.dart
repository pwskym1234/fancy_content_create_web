class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();

  String? _accessToken;
  String? _refreshToken;

  factory TokenStorage() {
    return _instance;
  }

  TokenStorage._internal();

  void setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
}
