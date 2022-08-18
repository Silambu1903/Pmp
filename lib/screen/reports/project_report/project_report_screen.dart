import 'dart:io';
import  'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmp/model/projectreportlist.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/screensize.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

import '../../../provider/project_allocation_provider/project_report_provider.dart';
import '../../director/dashboard/director_home_screen.dart';

class ProjectReportScreen extends ConsumerStatefulWidget {
  const ProjectReportScreen({Key? key}) : super(key: key);

  @override
  _ProjectReportScreenState createState() => _ProjectReportScreenState();
}

class _ProjectReportScreenState extends ConsumerState<ProjectReportScreen> {
  late ProjectListSource _projectListDataSource;

  @override
  void initState() {
    ref.refresh(projectReportListSuperAdminNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return windowsUi();
  }

  windowsUi() {
    return ref.watch(projectReportListSuperAdminNotifier).when(data: (data) {
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
      if (data.isNotEmpty) {
        for (var value in data) {
          if (value.status == 'Created') {
            open.add('Created');
          } else if (value.status == 'InProgress') {
            ongoing.add('Created');
          } else if (value.status == 'Blocked') {
            blocked.add('Blocked');
          } else if (value.status == 'MovedTesting') {
            test.add('MovedTesting');
          } else if (value.status == 'CompletedTesting') {
            testCompleted.add('Completed Testing');
          } else if (value.status == 'Completed') {
            completed.add('Completed');
          }
        }

        chartData.add(ChartData('Completed Project', 100, Colors.purpleAccent));
        chartData1.add(ChartData('OnGoing Project', 100, Colors.orangeAccent));
        chartData2
            .add(ChartData('Completed Testing', 100, Colors.deepPurpleAccent));
        chartData3.add(ChartData('Moved Testing', 100, Colors.blue));
      }
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
                          }),
                    ),
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
                                ongoing.isNotEmpty
                                    ? ongoing.length.toString()
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
                                testCompleted.isNotEmpty ? testCompleted.length.toString() : '0',
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
                      Padding(
                        padding:  const EdgeInsets.only(
                            left: 8.0, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Export as',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenSize.screenWidth * 0.0095),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                excelExport(data);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SizedBox(
                                  height: 25.0,
                                  width: 25.0,
                                  child: SvgPicture.asset(
                                      'assets/excel.svg'),
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
            ),
          ],
        ),
      );
    }, error: (error, s) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Row(
          children: [
            Expanded(
              flex: 7,
              child: Center(
                child: Text(error.toString()),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }, loading: () {
      return const Scaffold(
        backgroundColor: AppColors.cream,
      );
    });
  }

  mobileUi() {
    return ref.watch(projectReportListSuperAdminNotifier).when(data: (data) {
      final List<ChartData> chartData = [];
      final List<ChartData> chartData1 = [];
      final List<ChartData> chartData2 = [];
      final List<ChartData> chartData3 = [];
      List<String> open = [],
          test = [],
          ongoing = [],
          completed = [],
          blocked = [];
      if (data.isNotEmpty) {
        for (var value in data) {
          if (value.status == 'Created') {
            open.add('Created');
          } else if (value.status == 'InProgress') {
            ongoing.add('Created');
          } else if (value.status == 'Blocked') {
            blocked.add('Blocked');
          } else if (value.status == 'MovedtoTesting') {
            test.add('MovedtoTesting');
          } else if (value.status == 'InTesting') {
            test.add('InTesting');
          } else if (value.status == 'TestedOK') {
            test.add('TestedOK');
          } else if (value.status == 'Completed') {
            completed.add('Completed');
          }
        }

        chartData.add(ChartData('Completed Project', 100, Colors.purpleAccent));
        chartData1.add(ChartData('OnGoing Project', 100, Colors.orangeAccent));
        chartData2
            .add(ChartData('Testing Project', 100, Colors.deepPurpleAccent));
        chartData3.add(ChartData('Open Project', 100, Colors.blue));
      }
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
                          }),
                    ),
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
                                ongoing.isNotEmpty
                                    ? ongoing.length.toString()
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
    }, error: (error, s) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Row(
          children: [
            Expanded(
              flex: 7,
              child: Center(
                child: Text(error.toString()),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }, loading: () {
      return const Scaffold(
        backgroundColor: AppColors.cream,
      );
    });
  }

  itemBuilder(ProjectReportList data) {
    final List<ChartData> chartData4 = [];
    List<ProjectTeamSpentHour> teamSpent = [];
    double hrTemp = 0,
        hardware = 0,
        firmware = 0,
        software = 0,
        support = 0,
        mobile = 0,
        aI = 0,
        business = 0,
        qC = 0,
        pcb = 0,
        accounts = 0,
        purchase = 0,
        stores = 0,
        validation = 0,
        panel = 0;
    for (int i = 0; i < data.dailyReports!.length; i++) {
      if (data.dailyReports![i].spentHrs.toString().isNotEmpty &&
          data.dailyReports![i].spentHrs != null &&
          data.dailyReports![i].teamCreation != null &&
          data.dailyReports![i].teamCreation.toString().isNotEmpty) {
        switch (data.dailyReports![i].teamCreation!.teamName!) {
          case 'HR / Admin':
            hrTemp = hrTemp + data.dailyReports![i].spentHrs;
            break;
          case 'Hardware':
            hardware = hardware + data.dailyReports![i].spentHrs;
            break;
          case 'Firmware':
            firmware = firmware + data.dailyReports![i].spentHrs;
            break;
          case 'Software':
            software = software + data.dailyReports![i].spentHrs;

            break;
          case 'Support':
            support = support + data.dailyReports![i].spentHrs;

            break;
          case 'Mobile APP':
            mobile = mobile + data.dailyReports![i].spentHrs;

            break;
          case 'AI/ML':
            aI = aI + data.dailyReports![i].spentHrs;

            break;
          case 'Business Development':
            business = business + data.dailyReports![i].spentHrs;

            break;
          case 'QC Production':
            qC = qC + data.dailyReports![i].spentHrs;

            break;
          case 'PCB Producation':
            pcb = pcb + data.dailyReports![i].spentHrs;

            break;
          case 'Accounts':
            accounts = accounts + data.dailyReports![i].spentHrs;

            break;
          case 'Purchase':
            purchase = purchase + data.dailyReports![i].spentHrs;

            break;
          case 'Stores':
            stores = hrTemp + data.dailyReports![i].spentHrs;

            break;
          case 'Validation':
            validation = validation + data.dailyReports![i].spentHrs;

            break;
          case 'Panel Producation':
            panel = panel + data.dailyReports![i].spentHrs;

            break;
        }
      }
    }

    for (var value in data.allocationProjects!) {
      switch (value.teamCreation!.teamName!) {
        case 'HR / Admin':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: hrTemp));
          break;
        case 'Hardware':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: hardware));

          break;
        case 'Firmware':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: firmware));
          break;
        case 'Software':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: software));

          break;
        case 'Support':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: support));

          break;
        case 'Mobile APP':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: mobile));
          break;
        case 'AI/ML':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: aI));
          break;
        case 'Business Development':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: business));

          break;
        case 'QC Production':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: qC));

          break;
        case 'PCB Producation':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: pcb));

          break;
        case 'Accounts':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: accounts));

          break;
        case 'Purchase':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: purchase));

          break;
        case 'Stores':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: stores));

          break;
        case 'Validation':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: validation));

          break;
        case 'Panel Producation':
          teamSpent.add(ProjectTeamSpentHour(
              teamName: value.teamCreation!.teamName!,
              planned: value.plannedHrs!,
              spent: panel));

          break;
      }
    }

    _projectListDataSource = ProjectListSource(teamSpent: teamSpent);
    num percentage = 0;
    if (data.dailyReportsAggregate!.aggregate!.sum!.spentHrs
            .toString()
            .isNotEmpty &&
        data.dailyReportsAggregate!.aggregate!.sum!.spentHrs != 0) {
      percentage = data.dailyReportsAggregate!.aggregate!.sum!.spentHrs! /
          double.parse(data.plannedHrs!);
      percentage = percentage * 10;
    }
    chartData4.add(ChartData(
        'PlannedHours',
        data.plannedHrs.toString().isNotEmpty
            ? double.parse(data.plannedHrs)
            : 0,
        Colors.deepOrangeAccent));
    chartData4.add(ChartData(
        'SpentHours',
        data.dailyReportsAggregate!.aggregate!.sum!.spentHrs!
                .toString()
                .isNotEmpty
            ? data.dailyReportsAggregate!.aggregate!.sum!.spentHrs!
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
                                  message: data.projectCode!,
                                  child: Text(
                                    data.projectCode!,
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
                                    message: data.projectName,
                                    child: Text(
                                      data.projectName!.length > 25
                                          ? '${data.projectName!.substring(0, 20)}...'
                                          : data.projectName!,
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
                                  data.status.toString(),
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
                                    message: data.createDate,
                                    child: Text(
                                      data.createDate!,
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
                                    message: data.deliveryDate!,
                                    child: Text(
                                      data.deliveryDate!,
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
                                  message: data.plannedHrs!.toString(),
                                  child: Text(
                                    data.plannedHrs!.toString() + 'hrs',
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
                                  message: data.dailyReportsAggregate!
                                      .aggregate!.sum!.spentHrs!
                                      .toString()
                                      .isNotEmpty
                                      ? data.dailyReportsAggregate!.aggregate!
                                      .sum!.spentHrs!
                                      .toString() +
                                      'hrs'
                                      : '0hrs',
                                  child: Text(
                                    data.dailyReportsAggregate!.aggregate!.sum!
                                        .spentHrs!
                                        .toString()
                                        .isNotEmpty
                                        ? data.dailyReportsAggregate!.aggregate!
                                        .sum!.spentHrs!
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
                                        pointColorMapper: (ChartData data, _) =>
                                        data.color,
                                        xValueMapper: (ChartData data, _) =>
                                        data.x,
                                        yValueMapper: (ChartData data, _) =>
                                        data.y,
                                        // Mode of grouping
                                        groupMode: CircularChartGroupMode.point,
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
                                      percentage.toString().length > 3
                                          ? percentage.toString().substring(0, 3) +
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
                          columnName: 'Team',
                          label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Team',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          columnName: 'PlannedHours',
                          label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'PlannedHours',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                      GridColumn(
                          columnName: 'SentHours',
                          label: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'SpendHours',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                    ]),
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                        'summa a  va eruken',
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
                              onTap: () {},
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
  }

  Future<void> excelExport(List<ProjectReportList> data) async {

    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet worksheet = workbook.worksheets[0];
    final xls.Style style = workbook.styles.add('Style1');
    final xls.Style style1 = workbook.styles.add('Style2');
    style.hAlign = xls.HAlignType.center;
    style.bold = true;
    style1.hAlign = xls.HAlignType.center;
    style1.vAlign = xls.VAlignType.center;

    worksheet.getRangeByName('A1').setText('S NO');

    worksheet.getRangeByName('A1').cellStyle = style;
    worksheet.getRangeByName('B1').setText('PROJECT NAME');

    worksheet.getRangeByName('B1').cellStyle = style;
    worksheet.getRangeByName('C1').setText('PROJECT CODE');

    worksheet.getRangeByName('C1').cellStyle = style;
    worksheet.getRangeByName('D1').setText('CREATED DATE');

    worksheet.getRangeByName('D1').cellStyle = style;
    worksheet.getRangeByName('E1').setText('DELIVERY DATE');

    worksheet.getRangeByName('E1').cellStyle = style;
    worksheet.getRangeByName('F1').setText('PLANNED HOURS');

    worksheet.getRangeByName('F1').cellStyle = style;
    worksheet.getRangeByName('G1').setText('TEAM NAME');

    worksheet.getRangeByName('G1').cellStyle = style;
    worksheet.getRangeByName('H1').setText('ASSIGNED HOURS');

    worksheet.getRangeByName('H1').cellStyle = style;
    worksheet.getRangeByName('I1').setText('SPENT HOURS');

    worksheet.getRangeByName('I1').cellStyle = style;
    final xls.Range range = worksheet.getRangeByName('A1');

    range.autoFitRows();
    worksheet.autoFitRow(1);
    worksheet.autoFitColumn(2);
    worksheet.getRangeByName('A1').columnWidth = 5.82;
    worksheet.getRangeByName('B1').columnWidth = 40.82;
    worksheet.getRangeByName('C1').columnWidth = 20.82;
    worksheet.getRangeByName('D1').columnWidth = 20.82;
    worksheet.getRangeByName('E1').columnWidth = 20.82;
    worksheet.getRangeByName('F1').columnWidth = 20.82;
    worksheet.getRangeByName('G1').columnWidth = 20.82;
    worksheet.getRangeByName('H1').columnWidth = 20.82;
    worksheet.getRangeByName('I1').columnWidth = 20.82;

    int k = 2;
    int mergeForm = 0;
    int mergeTo = 0;
    for (int i = 0; i < data.length; i++) {
      List<ProjectTeamSpentHour> teamSpent = [];
      double hrTemp = 0,
          hardware = 0,
          firmware = 0,
          software = 0,
          support = 0,
          mobile = 0,
          aI = 0,
          business = 0,
          qC = 0,
          pcb = 0,
          accounts = 0,
          purchase = 0,
          stores = 0,
          validation = 0,
          panel = 0;
      mergeForm = k;
      for (int m = 0; m < data[i].dailyReports!.length; m++) {
        if (data[i].dailyReports![m].spentHrs.toString().isNotEmpty &&
            data[i].dailyReports![m].spentHrs != null &&
            data[i].dailyReports![m].teamCreation != null &&
            data[i].dailyReports![m].teamCreation.toString().isNotEmpty) {
          switch (data[i].dailyReports![m].teamCreation!.teamName!) {
            case 'HR / Admin':
              hrTemp = hrTemp + data[i].dailyReports![m].spentHrs;
              break;
            case 'Hardware':
              hardware = hardware + data[i].dailyReports![m].spentHrs;
              break;
            case 'Firmware':
              firmware = firmware + data[i].dailyReports![m].spentHrs;
              break;
            case 'Software':
              software = software + data[i].dailyReports![m].spentHrs;

              break;
            case 'Support':
              support = support + data[i].dailyReports![m].spentHrs;

              break;
            case 'Mobile APP':
              mobile = mobile + data[i].dailyReports![m].spentHrs;

              break;
            case 'AI/ML':
              aI = aI + data[i].dailyReports![m].spentHrs;

              break;
            case 'Business Development':
              business = business + data[i].dailyReports![m].spentHrs;

              break;
            case 'QC Production':
              qC = qC + data[i].dailyReports![m].spentHrs;

              break;
            case 'PCB Producation':
              pcb = pcb + data[i].dailyReports![m].spentHrs;

              break;
            case 'Accounts':
              accounts = accounts + data[i].dailyReports![m].spentHrs;

              break;
            case 'Purchase':
              purchase = purchase + data[i].dailyReports![m].spentHrs;

              break;
            case 'Stores':
              stores = hrTemp + data[i].dailyReports![m].spentHrs;

              break;
            case 'Validation':
              validation = validation + data[i].dailyReports![m].spentHrs;

              break;
            case 'Panel Producation':
              panel = panel + data[i].dailyReports![m].spentHrs;

              break;
          }
        }
      }
      for (int j = 0; j < data[i].allocationProjects!.length; j++) {

        switch (data[i].allocationProjects![j].teamCreation!.teamName!) {
          case 'HR / Admin':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!.teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: hrTemp));
            break;
          case 'Hardware':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!.teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: hardware));

            break;
          case 'Firmware':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: firmware));
            break;
          case 'Software':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: software));

            break;
          case 'Support':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: support));

            break;
          case 'Mobile APP':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: mobile));
            break;
          case 'AI/ML':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: aI));
            break;
          case 'Business Development':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: business));

            break;
          case 'QC Production':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: qC));

            break;
          case 'PCB Producation':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: pcb));

            break;
          case 'Accounts':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: accounts));

            break;
          case 'Purchase':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: purchase));

            break;
          case 'Stores':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: stores));

            break;
          case 'Validation':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: validation));

            break;
          case 'Panel Producation':
            teamSpent.add(ProjectTeamSpentHour(
                teamName: data[i].allocationProjects![j].teamCreation!
                    .teamName!,
                planned: data[i].allocationProjects![j].plannedHrs!,
                spent: panel));

            break;
        }
        worksheet
            .getRangeByName('G' + k.toString())
            .setText(teamSpent[j].teamName);
        worksheet.getRangeByName('G' + k.toString()).cellStyle = style1;

        worksheet
            .getRangeByName('H' + k.toString())
            .setText(teamSpent[j].planned);
        worksheet.getRangeByName('H' + k.toString()).cellStyle = style1;

        worksheet
            .getRangeByName('I' + k.toString())
            .setText(teamSpent[j].spent.toString());
        worksheet.getRangeByName('I' + k.toString()).cellStyle = style1;

        if (j == data[i].allocationProjects!.length - 1) {
          k++;
          worksheet.getRangeByName('G' + k.toString()).setText('');
          mergeTo = k - 1;
          final xls.Range range1 = worksheet.getRangeByName(
              'A' + mergeForm.toString() + ':' + 'A' + mergeTo.toString());
          final xls.Range range2 = worksheet.getRangeByName(
              'B' + mergeForm.toString() + ':' + 'B' + mergeTo.toString());
          final xls.Range range3 = worksheet.getRangeByName(
              'C' + mergeForm.toString() + ':' + 'C' + mergeTo.toString());
          final xls.Range range4 = worksheet.getRangeByName(
              'D' + mergeForm.toString() + ':' + 'D' + mergeTo.toString());
          final xls.Range range5 = worksheet.getRangeByName(
              'E' + mergeForm.toString() + ':' + 'E' + mergeTo.toString());
          final xls.Range range6 = worksheet.getRangeByName(
              'F' + mergeForm.toString() + ':' + 'F' + mergeTo.toString());
          range1.merge();
          range2.merge();
          range3.merge();
          range4.merge();
          range5.merge();
          range6.merge();

          worksheet
              .getRangeByName(
                  'A' + mergeForm.toString() + ':' + 'A' + mergeTo.toString())
              .setNumber(i + 1);
          worksheet
              .getRangeByName(
                  'A' + mergeForm.toString() + ':' + 'A' + mergeTo.toString())
              .cellStyle = style1;

          worksheet
              .getRangeByName(
                  'B' + mergeForm.toString() + ':' + 'B' + mergeTo.toString())
              .setText(data[i].projectName);
          worksheet
              .getRangeByName(
                  'B' + mergeForm.toString() + ':' + 'B' + mergeTo.toString())
              .cellStyle = style1;
          worksheet
              .getRangeByName(
                  'C' + mergeForm.toString() + ':' + 'C' + mergeTo.toString())
              .setText(data[i].projectCode);
          worksheet
              .getRangeByName(
                  'C' + mergeForm.toString() + ':' + 'C' + mergeTo.toString())
              .cellStyle = style1;
          worksheet
              .getRangeByName(
              'D' + mergeForm.toString() + ':' + 'D' + mergeTo.toString())
              .setText(data[i].createDate);
          worksheet
              .getRangeByName(
              'D' + mergeForm.toString() + ':' + 'D' + mergeTo.toString())
              .cellStyle = style1;
          worksheet
              .getRangeByName(
              'E' + mergeForm.toString() + ':' + 'E' + mergeTo.toString())
              .setText(data[i].deliveryDate);
          worksheet
              .getRangeByName(
              'E' + mergeForm.toString() + ':' + 'E' + mergeTo.toString())
              .cellStyle = style1;
          worksheet
              .getRangeByName(
              'F' + mergeForm.toString() + ':' + 'F' + mergeTo.toString())
              .setText(data[i].plannedHrs);
          worksheet
              .getRangeByName(
              'F' + mergeForm.toString() + ':' + 'F' + mergeTo.toString())
              .cellStyle = style1;
        }

        k = k + 1;
      }




    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      String data = DateFormat("dd-MM-yyyy-HH-mm-ss").format(DateTime.now());
      final String fileName = '$path/ProjectReport-'+data+'.xlsx';

      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}

class ProjectListSource extends DataGridSource {
  ProjectListSource({required List<ProjectTeamSpentHour> teamSpent}) {
    dataGridRows = teamSpent
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(cells: [
            DataGridCell<dynamic>(
                columnName: 'Team', value: dataGridRow.teamName!),
            DataGridCell<dynamic>(
                columnName: 'PlannedHours', value: dataGridRow.planned!),
            DataGridCell<dynamic>(
                columnName: 'SentHours', value: dataGridRow.spent!),
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
