import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/widgets/shimmer/shimmerprojectlist.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../helper.dart';
import '../../../helper/applicationhelper.dart';
import '../../../provider/changenotifier/widget_notifier.dart';
import '../../../provider/created_user_provider/created_user_list_provider.dart';
import '../../../provider/project_allocation_provider/project_report_provider.dart';
import '../../../provider/project_allocation_provider/project_report_team_lead.dart';
import '../../../responsive/responsive.dart';
import '../../director/dashboard/director_home_screen.dart';

class ProjectReportTeamLeadScreen extends ConsumerStatefulWidget {
  const ProjectReportTeamLeadScreen({Key? key}) : super(key: key);

  @override
  _ProjectReportScreenState createState() => _ProjectReportScreenState();
}

class _ProjectReportScreenState
    extends ConsumerState<ProjectReportTeamLeadScreen> {
  late ProjectListSource _projectListDataSource;
  bool itemChanged = false,
      isCheckedCompleted = false,
      isCheckedInProcess = false,
      isCheckedMoveTesting = false,
      isCheckedTestingCompleted = false,
      isCheckedOpen = false,
      isCheckedIsInactive = false;
  String selectedDate = '';
  String textDate = '';
  List<ProjectReportTeamLead> filter = [];
  List<String> filterData = [];

  @override
  void initState() {
    super.initState();
    filterData.add(selectedDate);
    filterData.add('InProgress');
    return ref.refresh(projectReportListTeamLeadNotifier(filterData));
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Responsive.isDesktop(context)
        ? windowViewHomeScreen(context)
        : Responsive.isMobile(context)
        ? mobileViewHomeScreen(context)
        : windowViewHomeScreen(context);
  }
  mobileViewHomeScreen(BuildContext context){
    final List<ChartData> chartData = [];
    final List<ChartData> chartData1 = [];
    final List<ChartData> chartData2 = [];
    final List<ChartData> chartData3 = [];
    List<String> open = [],
        testCompleted = [],
        test = [],
        ongoing = [],
        completed = [],
        blocked = [];
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: SizedBox(
                              height: ScreenSize.screenHeight * 0.05,
                              child: TextField(
                                onChanged: (value) {
                                  onItemChanged(value);
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {},
                                  ),
                                  hintText: 'Search by Project Name',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: Responsive.isDesktop(context)?1 :1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Responsive.isDesktop(context)
                            ? Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: IconButton(
                                    onPressed: () async {
                                      DateTime? date = DateTime(1900);
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      date = await showMonthYearPicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2101));
                                      if (date != null) {
                                        selectedDate = ApplicationHelper().dateFormatter1(date);
                                        textDate = ApplicationHelper().dateFormatter2(date);
                                      }
                                      filterData[0] = selectedDate;
                                      ref.refresh(projectReportListTeamLeadNotifier(filterData));
                                    },
                                    icon: const Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 10),
                                  child: Text(
                                    textDate,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.01),
                                  ),
                                ),
                                _buildChipCompleted('Completed', Colors.black, 0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: _buildChipInProgress(
                                      'InProgress', Colors.black, 1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child:
                                  _buildChipTesting('InTesting', Colors.black, 2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: _buildChipTestingCompleted(
                                      'Testing Completed', Colors.black, 2),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: _buildChipOpen('Open', Colors.black, 3),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 12.0, right: 15),
                                  child: _buildChipMovedTesting(
                                      'Moved Testing', Colors.black, 3),
                                ),
                              ],
                            ))
                            : Expanded(
                          child: Column(
                            children: [
                              /*   Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: IconButton(
                                    onPressed: () async {
                                      DateTime? date = DateTime(1900);
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      date = await showMonthYearPicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2101));
                                      if (date != null) {
                                        selectedDate = ApplicationHelper().dateFormatter1(date);
                                        textDate = ApplicationHelper().dateFormatter2(date);
                                      }
                                      filterData[0] = selectedDate;
                                      ref.refresh(getProjectAssignedTeamFilterList(filterData));
                                    },
                                    icon: const Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 10),
                                  child: Text(
                                    textDate,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.01),
                                  ),
                                ),
                              ],
                            ),*/
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildChipCompleted(
                                        'CO', Colors.black, 0),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: _buildChipInProgress(
                                          'IP', Colors.black, 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child:
                                      _buildChipOpen('OP', Colors.black, 3),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: _buildChipTesting(
                                          'In', Colors.black, 2),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 15),
                                      child: _buildChipMovedTesting(
                                          'MT', Colors.black, 3),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ref.watch(projectReportListTeamLeadNotifier(filterData)).when(
                data: (data) {
                  if (data.isNotEmpty) {
                    for (var value in data) {
                      if (value.projectCreation!.status == 'Created') {
                        open.add('Created');
                      } else if (value.projectCreation!.status ==
                          'InProgress') {
                        ongoing.add('Created');
                      } else if (value.projectCreation!.status == 'Blocked') {
                        blocked.add('Blocked');
                      } else if (value.projectCreation!.status ==
                          'MovedTesting') {
                        test.add('MovedTesting');
                      } else if (value.projectCreation!.status ==
                          'CompletedTesting') {
                        testCompleted.add('CompletedTesting');
                      } else if (value.projectCreation!.status ==
                          'Completed') {
                        completed.add('Completed');
                      }
                    }

                    chartData.add(ChartData(
                        'Completed Project', 100, Colors.purpleAccent));
                    chartData1.add(ChartData(
                        'OnGoing Project', 100, Colors.orangeAccent));
                    chartData2.add(ChartData(
                        'Testing Project', 100, Colors.deepPurpleAccent));
                    chartData3
                        .add(ChartData('Open Project', 100, Colors.blue));
                  }
                  return Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MasonryGridView.count(
                        crossAxisCount: 1,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: data.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return itemBuilder(data[index]);
                        },
                      ),
                    ),
                  );
                },
                error: (error, s) {
                  return Center(
                    child: Text(error.toString()),
                  );
                },
                loading: () {
                  return ShimmerForProjectList();
                },
              )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  windowViewHomeScreen(BuildContext context) {
    final List<ChartData> chartData = [];
    final List<ChartData> chartData1 = [];
    final List<ChartData> chartData2 = [];
    final List<ChartData> chartData3 = [];
    List<String> open = [],
        test = [],
        testCompleted = [],
        ongoing = [],
        completed = [],
        blocked = [];
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SizedBox(
                            height: ScreenSize.screenHeight * 0.05,
                            child: TextField(
                              onChanged: (value) {
                                onItemChanged(value);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {},
                                ),
                                hintText: 'Search...',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: IconButton(
                          onPressed: () async {
                            DateTime? date = DateTime(1900);
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = await showMonthYearPicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2101));
                            if (date != null) {
                              selectedDate =
                                  ApplicationHelper().dateFormatter1(date);
                              textDate =
                                  ApplicationHelper().dateFormatter2(date);
                            }
                            filterData[0] = selectedDate;
                            return ref.refresh(projectReportListTeamLeadNotifier(filterData));
                          },
                          icon: const Icon(
                            Icons.date_range_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          textDate,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.01),
                        ),
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildChipCompleted('Completed', Colors.black, 0),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: _buildChipInProgress(
                                'InProgress', Colors.black, 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child:
                                _buildChipTesting('InTesting', Colors.black, 2),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: _buildChipTestingCompleted(
                                'Testing Completed', Colors.black, 2),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: _buildChipOpen('Open', Colors.black, 3),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 15),
                            child: _buildChipMovedTesting(
                                'Moved Testing', Colors.black, 3),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                ref.watch(projectReportListTeamLeadNotifier(filterData)).when(
                  data: (data) {
                    if (data.isNotEmpty) {
                      for (var value in data) {
                        if (value.projectCreation!.status == 'Created') {
                          open.add('Created');
                        } else if (value.projectCreation!.status ==
                            'InProgress') {
                          ongoing.add('Created');
                        } else if (value.projectCreation!.status == 'Blocked') {
                          blocked.add('Blocked');
                        } else if (value.projectCreation!.status ==
                            'MovedTesting') {
                          test.add('MovedTesting');
                        } else if (value.projectCreation!.status ==
                            'CompletedTesting') {
                          testCompleted.add('CompletedTesting');
                        } else if (value.projectCreation!.status ==
                            'Completed') {
                          completed.add('Completed');
                        }
                      }

                      chartData.add(ChartData(
                          'Completed Project', 100, Colors.purpleAccent));
                      chartData1.add(ChartData(
                          'OnGoing Project', 100, Colors.orangeAccent));
                      chartData2.add(ChartData(
                          'Testing Project', 100, Colors.deepPurpleAccent));
                      chartData3
                          .add(ChartData('Open Project', 100, Colors.blue));
                    }
                    return Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          itemCount: data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return itemBuilder(data[index]);
                          },
                        ),
                      ),
                    );
                  },
                  error: (error, s) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  },
                  loading: () {
                    return ShimmerForProjectList();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0XFFe8e6e1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        Text(
                          'Project Summary',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenSize.screenWidth * 0.015),
                        )
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                borderWidth: 1,
                                toggleSeriesVisibility: true,
                                position: LegendPosition.bottom,
                                title: LegendTitle(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                  dataSource: chartData,
                                  innerRadius: '75%',
                                  radius: '50',
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  // Mode of grouping
                                  groupMode: CircularChartGroupMode.point,
                                  groupTo: 1,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Center(
                                child: Text(
                              completed.isNotEmpty
                                  ? completed.length.toString()
                                  : '0',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                borderWidth: 1,
                                toggleSeriesVisibility: true,
                                position: LegendPosition.bottom,
                                title: LegendTitle(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                  dataSource: chartData1,
                                  innerRadius: '75%',
                                  radius: '50',
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  // Mode of grouping
                                  groupMode: CircularChartGroupMode.point,
                                  groupTo: 1,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Center(
                                child: Text(
                              testCompleted.isNotEmpty
                                  ? testCompleted.length.toString()
                                  : '0',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                borderWidth: 1,
                                overflowMode: LegendItemOverflowMode.wrap,
                                toggleSeriesVisibility: true,
                                position: LegendPosition.bottom,
                                title: LegendTitle(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                  dataSource: chartData2,
                                  innerRadius: '75%',
                                  radius: '50',
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  // Mode of grouping
                                  groupMode: CircularChartGroupMode.point,
                                  groupTo: 1,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Center(
                                child: Text(
                              test.isNotEmpty ? test.length.toString() : '0',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SfCircularChart(
                              legend: Legend(
                                isVisible: true,
                                borderWidth: 1,
                                toggleSeriesVisibility: true,
                                position: LegendPosition.bottom,
                                title: LegendTitle(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                  dataSource: chartData3,
                                  innerRadius: '75%',
                                  radius: '50',
                                  pointColorMapper: (ChartData data, _) =>
                                      data.color,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  // Mode of grouping
                                  groupMode: CircularChartGroupMode.point,
                                  groupTo: 1,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Center(
                                child: Text(
                              open.isNotEmpty ? open.length.toString() : '0',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  itemBuilder(ProjectReportTeamLead data) {
    return ref.watch(userListStateProvider).when(data: (users) {
      final List<ChartData> chartData4 = [];
      List<ProjectTeamSpentHour> teamSpent = [];
      List<String> userList = [];
      for (var user in users) {
        userList.add(user.userName!);
      }
      Map<String, dynamic> mMap = {};

      for (var list in data.projectCreation!.dailyReports!) {
        if (userList.contains(list.userRegistration!.userName!)) {
          if (mMap.containsKey(list.userRegistration!.userName!)) {
            mMap[list.userRegistration!.userName!] += list.spentHrs!;
          } else {
            mMap[list.userRegistration!.userName!] = list.spentHrs!;
          }
        } else if (Helper.shareduserName == list.userRegistration!.userName!) {
          if (mMap.containsKey(list.userRegistration!.userName!)) {
            mMap[list.userRegistration!.userName!] += list.spentHrs!;
          } else {
            mMap[list.userRegistration!.userName!] = list.spentHrs!;
          }
        }
      }
      mMap.forEach((key, value) {
        teamSpent
            .add(ProjectTeamSpentHour(teamName: key, planned: 0, spent: value));
      });

      _projectListDataSource = ProjectListSource(teamSpent: teamSpent);
      num percentage = 0;
      if (data.projectCreation!.dailyReportsAggregate!.aggregate!.sum!.spentHrs
              .toString()
              .isNotEmpty &&
          data.projectCreation!.dailyReportsAggregate!.aggregate!.sum!
                  .spentHrs !=
              0) {
        /*  percentage = data.projectCreation!.dailyReportsAggregate!.aggregate!
                .sum!.spentHrs! /
            double.parse(data.projectCreation!.plannedHrs!);*/
        percentage = percentage * 10;
      }
      chartData4.add(ChartData(
          'PlannedHours',
          data.projectCreation!.plannedHrs.toString().isNotEmpty
              ? double.parse(data.projectCreation!.plannedHrs)
              : 0,
          Colors.deepOrangeAccent));
      chartData4.add(ChartData(
          'SpentHours',
          data.projectCreation!.dailyReportsAggregate!.aggregate!.sum!.spentHrs!
                  .toString()
                  .isNotEmpty
              ? data.projectCreation!.dailyReportsAggregate!.aggregate!.sum!
                  .spentHrs!
              : 0,
          Colors.pink));
      return Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Project Code :',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Tooltip(
                                    message: data.projectCreation!.projectCode!,
                                    child: Text(
                                      data.projectCreation!.projectCode!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Project Name :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Tooltip(
                                      message:
                                          data.projectCreation!.projectName,
                                      child: Text(
                                        data.projectCreation!.projectName!
                                                    .length >
                                                25
                                            ? '${data.projectCreation!.projectName!.substring(0, 20)}...'
                                            : data
                                                .projectCreation!.projectName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Status :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    data.projectCreation!.status!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Created Date :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Tooltip(
                                      message: data.projectCreation!.createDate,
                                      child: Text(
                                        data.projectCreation!.createDate!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Delivery Date :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Tooltip(
                                      message:
                                          data.projectCreation!.deliveryDate!,
                                      child: Text(
                                        data.projectCreation!.deliveryDate!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'PlannedHrs :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Tooltip(
                                    message: data.projectCreation!.plannedHrs!
                                        .toString(),
                                    child: Text(
                                      data.projectCreation!.plannedHrs!
                                              .toString() +
                                          'hrs',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'SpentHrs :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Tooltip(
                                    message: data
                                            .projectCreation!
                                            .dailyReportsAggregate!
                                            .aggregate!
                                            .sum!
                                            .spentHrs!
                                            .toString()
                                            .isNotEmpty
                                        ? data
                                                .projectCreation!
                                                .dailyReportsAggregate!
                                                .aggregate!
                                                .sum!
                                                .spentHrs!
                                                .toString() +
                                            'hrs'
                                        : '0hrs',
                                    child: Text(
                                      data
                                              .projectCreation!
                                              .dailyReportsAggregate!
                                              .aggregate!
                                              .sum!
                                              .spentHrs!
                                              .toString()
                                              .isNotEmpty
                                          ? data
                                                  .projectCreation!
                                                  .dailyReportsAggregate!
                                                  .aggregate!
                                                  .sum!
                                                  .spentHrs!
                                                  .toString() +
                                              'hrs'
                                          : '0hrs',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                      borderWidth: 1,
                                      toggleSeriesVisibility: true,
                                      position: LegendPosition.bottom,
                                      title: LegendTitle(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                          dataSource: chartData4,
                                          innerRadius: '75%',
                                          radius: '50',
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                          // Mode of grouping
                                          groupMode:
                                              CircularChartGroupMode.point,
                                          groupTo: 2,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  child: Center(
                                      child: Text(
                                    percentage.toString().length > 4
                                        ? percentage
                                                .toString()
                                                .substring(0, 4) +
                                            '%'
                                        : percentage.toString() + '%',
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenSize.screenHeight * 0.35,
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(),
                  child: SfDataGrid(
                    allowSwiping: true,
                    swipeMaxOffset: 100.0,
                    columnWidthMode: ColumnWidthMode.fill,
                    columnWidthCalculationRange:
                        ColumnWidthCalculationRange.allRows,
                    source: _projectListDataSource,
                    columns: [
                      GridColumn(
                          columnName: 'Name',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Name',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                      /*   GridColumn(
                          columnName: 'AssignedHours',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'AssignedHours',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),*/
                      GridColumn(
                          columnName: 'SpendHours',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'SpendHours',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                    ],
                  ),
                ),
              ),
              /*  Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: ScreenSize.screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'comments',
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: SvgPicture.asset(
                                    'assets/comment.svg',
                                    width: 20,
                                    height: 20,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'view all  20',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(

                                      children: const [
                                        Text(
                                          'Jeeva :  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          'suma a  va eruken',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 10),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){

                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: SvgPicture.asset(
                                    'assets/heart.svg',
                                    width: 20,
                                    height: 20,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              )*/
            ],
          ),
        ),
      );
    }, error: (error, s) {
      return Container();
    }, loading: () {
      return Container();
    });
  }

  onItemChanged(String value) {
    if (value.isNotEmpty) {
      itemChanged = true;
      filter = filter
          .where((ProjectReportTeamLead projectReportList) => projectReportList
              .projectCreation!.projectName!
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    } else {
      itemChanged = false;
    }
    ref.refresh(projectReportListTeamLeadNotifier(filterData));
  }

  Widget _buildChipCompleted(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
            isCheckedCompleted == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedCompleted,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('Completed');
          ref.refresh(projectReportListTeamLeadNotifier(filterData));
          isCheckedCompleted = value;
          isCheckedInProcess = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipInProgress(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
            isCheckedInProcess == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedInProcess,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();

          isCheckedInProcess = value;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('InProgress');
          ref.refresh(projectReportListTeamLeadNotifier(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipTesting(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
            isCheckedMoveTesting == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedMoveTesting,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = value;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('InTesting');
          ref.refresh(projectReportListTeamLeadNotifier(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipTestingCompleted(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor: isCheckedTestingCompleted == true
            ? Colors.white
            : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedTestingCompleted,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = value;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('CompletedTesting');
          ref.refresh(projectReportListTeamLeadNotifier(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipOpen(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
            isCheckedOpen == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedOpen,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = value;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('Open');
          ref.refresh(projectReportListTeamLeadNotifier(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipMovedTesting(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
            isCheckedIsInactive == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedIsInactive,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = true;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('MovedTesting');
          ref.refresh(projectReportListTeamLeadNotifier(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }
}

class ProjectListSource extends DataGridSource {
  ProjectListSource({required List<ProjectTeamSpentHour> teamSpent}) {
    dataGridRows = teamSpent
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(cells: [
            DataGridCell<dynamic>(
                columnName: 'Team', value: dataGridRow.teamName!),
            /* DataGridCell<dynamic>(
                columnName: 'PlannedHours', value: dataGridRow.planned!),*/
            DataGridCell<dynamic>(
                columnName: 'SpendHours', value: dataGridRow.spent!),
          ]),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}

class ProjectTeamSpentHour {
  String? teamName;
  dynamic? planned, spent;

  ProjectTeamSpentHour({this.teamName, this.planned, this.spent});

  setSpentValue(var val) {
    spent = val;
  }
}
