import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/auth/user.dart';
import 'package:time_tracker_client/data/models/project/project.dart';


part 'api_service_admin.g.dart';

@RestApi()
abstract class ApiServiceAdmin {
  factory ApiServiceAdmin(Dio dio, {String baseUrl}) = _ApiServiceAdmin;

  @GET('/api/v1/admin/users')
  Future<List<User>> fetchUsers();

  @POST('/api/v1/admin/projects')
  Future<Project> addProject(@Body() Project project);
}
