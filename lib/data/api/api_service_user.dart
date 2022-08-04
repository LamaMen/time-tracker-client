import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:time_tracker_client/data/models/progress/progress.dart';
import 'package:time_tracker_client/data/models/project/project.dart';

part 'api_service_user.g.dart';

@RestApi()
abstract class ApiServiceUser {
  factory ApiServiceUser(Dio dio, {String baseUrl}) = _ApiServiceUser;

  @GET('/projects')
  Future<List<Project>> fetchProjects(@Query("isFull") bool isFull);

  // @GET('/progress/general')
  // Future<List<Progress>> fetchGeneralProgressByPeriod(
  //   @Query('start') String start,
  //   @Query('start') String end,
  // );

  @GET('/progress/general')
  Future<List<Progress>> fetchGeneralProgress(
    @Queries() Map<String, String?> range,
  );

  @GET('/progress/today')
  Future<List<DailyProgress>> fetchDailyProgress();

  @GET('/sessions/start/{projectId}')
  Future<void> startSession(@Path('projectId') int projectId);

  @GET('/sessions/stop/{projectId}')
  Future<void> stopSession(@Path('projectId') int projectId);
}
