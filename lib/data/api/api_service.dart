import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/auth/user_credentials.dart';

import '../models/auth/token.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/api/v1/auth/users')
  Future<List<User>> fetchUsers();

  @POST('/api/v1/auth/signin')
  Future<Token> singIn(@Body() UserCredentials credentials);

  @POST('/api/v1/auth/signup')
  Future<User> singUp(@Body() User user);
}