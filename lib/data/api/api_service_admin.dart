import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/auth/full_user.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

part 'api_service_admin.g.dart';

@RestApi()
abstract class ApiServiceAdmin {
  factory ApiServiceAdmin(Dio dio, {String baseUrl}) = _ApiServiceAdmin;

  @POST('/projects')
  Future<Project> addProject(@Body() Project project);

  @DELETE('/projects/{id}')
  Future<void> deleteProject(
    @Path() int id,
    @Query('isArchive') bool isArchive,
  );

  @GET('/users')
  Future<List<FullUser>> fetchUsers();

  @POST('/users')
  Future<FullUser> addUser(@Body() FullUser user);

  @PUT('/users')
  Future<FullUser> editUser(@Body() FullUser user);

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path() String id);
}
