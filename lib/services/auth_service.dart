import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class AuthService {
  final Dio dio = Dio(); // Créer une instance de Dio
  final CookieJar cookieJar = CookieJar();
  final _storage = const FlutterSecureStorage();
  final _backendUrl = 'https://azurloc-back.onrender.com';

  AuthService() {
    // Conditionner l'ajout de CookieManager à Dio
    if (!kIsWeb) {
      dio.interceptors.add(CookieManager(cookieJar)); // Ajouter CookieManager à Dio uniquement pour les plateformes mobiles et desktop
    }
  }

  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        '$_backendUrl/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
        if (response.statusCode == 200) {
          // Extraction des cookies pour l'URL spécifiée
          List<Cookie> cookies = await cookieJar.loadForRequest(
              Uri.parse('$_backendUrl/auth/login'));
          // Recherche du cookie JWT

          var jwtCookie = cookies.firstWhere((cookie) => cookie.name == 'jwt',
              orElse: () => Cookie('jwt', ''));
          if (kDebugMode) {
            print("JWT Cookie trouvé: ${jwtCookie.value}");
          }
          if (jwtCookie.value != '') {
            await _storage.write(key: 'jwt', value: jwtCookie.value);
          } else {
            return 'Erreur lors de la connexion au serveur: JWT non trouvé';
          }
          return 'success';
        }
      } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        return 'Erreur 400: ${e.response?.data['message'] ?? 'Erreur de requête'}';
      } else {
        return 'Erreur lors de la connexion au serveur: ${e.message}';
      }
    }

    catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'Erreur lors de la connexion au serveur.';
    }
    return 'Erreur lors de la connexion au serveur.';
  }

  Future<String?> getJwt() async {
      return await _storage.read(key: 'jwt');
    }

  Future<bool> logout() async {
    try {
      final jwt = await getJwt();
      final response = await dio.post(
        '$_backendUrl/auth/logout',
        options: Options(
          headers: {
            'Cookie': 'jwt=$jwt',
          },
        ),
      );

      if (response.statusCode == 204) {
          await _storage.delete(key: 'jwt');
        cookieJar.deleteAll();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<String> refresh() async {
    final jwt = await getJwt();
    if (jwt != null) {
      try {
        final response = await dio.get(
          '$_backendUrl/refresh',
          options: Options(
            headers: {
              'Authorization': 'Bearer $jwt',
            },
          ),
        );

        if (response.statusCode == 200) {
          final accessToken = response.data['accessToken'];
          await _storage.write(key: 'jwt', value: accessToken);
          return accessToken;
        } else {
          return '';
        }
      } on DioError catch (e) {
        final code = e.response?.statusCode;
        final message = e.response?.data['message'];
        return 'Error $code: $message';
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return 'Erreur lors de la connexion au serveur.';
      }
    }
    return '';
  }

  Future<String> register({
    required String firstname,
    required String lastname,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String city,
    required String address,
  }) async {
    try {
      final response = await dio.post(
        '$_backendUrl/auth/register',
        data: {
          'firstname': firstname,
          'lastname': lastname,
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'city': city,
          'address': address,
        },
      );

      if (response.statusCode == 200) {

        return 'success';
      } else {
        // Pour les autres codes de réponse HTTP, y compris 400
        return 'Erreur: ${response.data['message'] ?? 'Erreur inconnue'}';
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        // Traitement spécifique pour le code 400
        return 'Erreur 400: ${e.response?.data['message'] ?? 'Erreur de requête'}';
      } else {
        // Pour toutes autres erreurs Dio
        return 'Erreur lors de la connexion au serveur: ${e.message}';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'Erreur lors de la connexion au serveur.';
    }
  }


}