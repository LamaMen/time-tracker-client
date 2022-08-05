import 'package:flutter/material.dart';
import 'package:time_tracker_client/domain/models/progress/general_statistic.dart';

class GeneralStatisticList extends StatelessWidget {
  final GeneralProgress statistic;

  const GeneralStatisticList(this.statistic, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: 32,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            'Всего: ${statistic.total}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: statistic.projectProgress.length,
            itemBuilder: (context, index) {
              final item = statistic.projectProgress[index];
              return _Item(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final ProjectProgress item;

  const _Item({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(item.project),
        subtitle: Text(item.duration),
        trailing: Text('${item.formattedPercent} %'),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
