import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/auth/token.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/auth/user_credentials.dart';

part 'api_service_auth.g.dart';

@RestApi()
abstract class ApiServiceAuth {
  factory ApiServiceAuth(Dio dio, {String baseUrl}) = _ApiServiceAuth;

  @GET('/api/v1/auth/users')
  Future<List<User>> fetchUsers();

  @POST('/api/v1/auth/signin')
  Future<Token> singIn(@Body() UserCredentials credentials);

  @POST('/api/v1/auth/signup')
  Future<Token> singUp(@Body() User user);
}