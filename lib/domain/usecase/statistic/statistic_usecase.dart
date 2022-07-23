import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracker_client/core/failure/failure.dart';
import 'package:time_tracker_client/data/models/project/project_with_duration.dart';
import 'package:time_tracker_client/domain/repository/statistic/statistic_repository.dart';
import 'package:time_tracker_client/domain/usecase/statistic/general_statistic.dart';

@singleton
class StatisticUsecase {
  final StatisticRepository _statisticRepository;

  StatisticUsecase(this._statisticRepository);

  Future<Either<Failure, GeneralStatistic>> getGeneral() async {
    final result = await _statisticRepository.fetchGeneral();
    if (result.isLeft()) {
      final failure = (result as Left).value;
      return Left(failure);
    }

    final raw = (result as Right).value as List<ProjectWithDuration>;
    final tMinutes = raw.fold<int>(0, (s, p) => s + p.duration.onlyMinutes);
    final statistic = raw.map((p) => ProjectProgress(p, tMinutes)).toList();
    final tPercent = statistic.fold<double>(0.0, (s, p) => s + p.percent);

    final general = GeneralStatistic(
      statistic,
      ProjectDuration.fromMinutes(tMinutes),
      tPercent,
    );

    return Right(general);
  }
}
