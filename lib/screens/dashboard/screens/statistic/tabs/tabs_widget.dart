import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker_client/core/setup/injectable.dart';
import 'package:time_tracker_client/core/widgets/responsive_utils.dart';
import 'package:time_tracker_client/domain/models/progress/progress_filters.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/filters/bloc/bloc.dart';
import 'package:time_tracker_client/screens/dashboard/screens/statistic/tabs/filters/filtres_dialog.dart';

class TabsWidget extends StatefulWidget {
  final List<TabInfo> tabs;

  const TabsWidget({super.key, required this.tabs});

  @override
  State<TabsWidget> createState() => _TabsWidgetState();
}

class _TabsWidgetState extends State<TabsWidget> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: widget.tabs.map((t) => Tab(text: t.label)).toList(),
                ),
              ),
              const _FilterWidget(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: widget.tabs.map((t) => t.child).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _FilterWidget extends StatefulWidget {
  const _FilterWidget();

  @override
  State<_FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<_FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => openFiltersDialog(context),
      ),
      desktop: TextButton(
        child: const Text('Фильтры'),
        onPressed: () => openFiltersDialog(context),
      ),
    );
  }

  Future<void> openFiltersDialog(BuildContext context) async {
    final oldFilters = context.read<StatisticBloc>().state as WithTabsState;
    final filters = await showDialog<ProgressFilters>(
      context: context,
      builder: (context) => BlocProvider<FiltersBloc>(
        create: (_) => getIt<FiltersBloc>(param1: oldFilters.filters),
        child: const FiltersDialog(),
      ),
    );

    if (mounted && filters != null) {
      context.read<StatisticBloc>().add(UpdateFilters(filters));
    }
  }
}

class TabInfo {
  final Widget child;
  final String label;

  const TabInfo({required this.child, required this.label});
}
