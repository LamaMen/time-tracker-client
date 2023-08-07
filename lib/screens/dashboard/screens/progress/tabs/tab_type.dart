import 'package:time_tracker_client/data/models/auth/user.dart';

abstract class TabType {
  String get label;
}

class GeneralStatisticTab implements TabType {
  const GeneralStatisticTab();

  @override
  String get label => 'Общая статистика';
}

class UserStatisticTab implements TabType {
  final User? user;

  const UserStatisticTab(this.user);

  @override
  String get label => user.toString();
}

class SelfStatisticTab extends UserStatisticTab {
  const SelfStatisticTab() : super(null);

  @override
  String get label => 'Своя статистика';
}
