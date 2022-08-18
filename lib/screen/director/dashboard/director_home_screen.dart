import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pmp/res/id.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:pmp/widgets/shimmer/shimmeruseruupdate.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:pmp/res/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timer_builder/timer_builder.dart';
import '../../../helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../helper/applicationhelper.dart';
import '../../../provider/dailytaskprovider/daily_task_provider.dart';
import '../../../provider/ratingproider/useratingprovider.dart';
import '../../../res/screensize.dart';
import '../../../responsive/responsive.dart';
import '../../reports/team_report/individual_member_report.dart';

class DirectorDashboardScreen extends ConsumerStatefulWidget {
  const DirectorDashboardScreen({Key? key}) : super(key: key);

  @override
  _DirectorDashboardScreenState createState() =>
      _DirectorDashboardScreenState();
}

class _DirectorDashboardScreenState
    extends ConsumerState<DirectorDashboardScreen> {
  TeamReportListSource _teamReportListSource =TeamReportListSource(teamSpent: []) ;
  List<String> filter = [];
  @override
  void initState() {
    ref.refresh(getCumulativePerformance);
    filter.clear();
    filter.add(Helper.sharedCreatedId);
    filter.add(ApplicationHelper().dateFormatter1(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? windowViewHomeScreen(context)
        : Responsive.isMobile(context)
            ? mobileViewHomeScreen(context)
            : windowViewHomeScreen(context);
  }

  Widget mobileViewHomeScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        primary: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hello,\n' + Helper.shareduserName!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenSize.screenWidth * 0.06,
                                fontWeight: FontWeight.bold)),
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(Helper.sharedAvatar),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (Helper.sharedRoleId == 'SuperAdmin') {
                      Navigator.pushNamed(context, AppId.RATING_LIST_SCREEN_ID);
                    } else if (Helper.sharedRoleId == 'DepartmentHead') {
                      Navigator.pushNamed(context, AppId.RATING_LIST_SCREEN_ID);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Do not Access !'
                            ''),
                      ));
                    }
                  },
                  child: Card(
                    elevation: 20,
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rating Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: SvgPicture.asset(
                                    'assets/rating.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.025),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (Helper.sharedRoleId == 'SuperAdmin') {
                        Navigator.pushNamed(
                            context, AppId.PROJECT_REPORT_SCREEN_ID);
                      } else if (Helper.sharedRoleId == 'DepartmentHead') {
                        Navigator.pushNamed(
                            context, AppId.PROJECT_REPORT_DEP_HEAD_SCREEN_ID);
                      } else if (Helper.sharedRoleId == 'Manager') {
                        Navigator.pushNamed(
                            context, AppId.PROJECT_REPORT_DEP_HEAD_SCREEN_ID);
                      } else if (Helper.sharedRoleId == 'TeamLead') {
                        Navigator.pushNamed(
                            context, AppId.PROJECT_REPORT_TEAM_LEAD_SCREEN_ID);
                      }
                    },
                    child: Card(
                      elevation: 20,
                      child: Container(
                        height: 115,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.grey, width: 0.01)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 12, right: 10.0, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Project Report',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: SvgPicture.asset(
                                      'assets/project.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                              ScreenSize.screenWidth * 0.025),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (Helper.sharedRoleId == 'TeamLead') {
                      Navigator.pushNamed(context, AppId.TEAMLEAD_REPORT);
                    } else {
                      Navigator.pushNamed(context, AppId.TEAMWISE_REPORT);
                    }
                  },
                  child: Card(
                    elevation: 20,
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'TeamWise Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: SvgPicture.asset(
                                    'assets/team.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.025),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {},
                  child: Card(
                    elevation: 20,
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Attendance Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: SvgPicture.asset(
                                    'assets/timesheet.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.025),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
            ref.watch(getCumulativePerformance).when(data: (data) {
              final List<ChartData> chartData2 = [
                ChartData('Scored', data.dpiTotal),
                ChartData('Overall', 100),
              ];
              num dpiSum = 0;
              num spiSum = 0;
              num qpiSum = 0;
              num priSum = 0;

              if (data.dpiTotal != null) {
                num dpiTotal = data.dpiTotal;
                dpiSum = dpiTotal / data.dpicount;
              }
              if (data.spiTotal != null) {
                num spiTotal = data.spiTotal;
                spiSum = spiTotal / data.spicount;
              }
              if (data.qpiTotal != null) {
                num qpiTotal = data.qpiTotal;
                qpiSum = qpiTotal/ data.qpicount ;
              }
              if (data.priTotal != null) {
                num priTotal = data.priTotal;
                priSum = priTotal/ data.pricount;
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border:
                                  Border.all(color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 12, right: 10.0, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'DPI Cumulative ',
                                          style: TextStyle(
                                              fontSize:
                                              ScreenSize.screenWidth * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper: (ChartData data, _) =>
                                                data.x,
                                                yValueMapper: (ChartData data, _) =>
                                                data.y,
                                                // Mode of grouping
                                                groupMode:
                                                CircularChartGroupMode.point,
                                                groupTo: 2,
                                              )
                                            ],
                                          ),
                                          Positioned(
                                              left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.2,
                                              top: 85,
                                              child: Text(
                                                dpiSum.toString().length > 4
                                                    ? dpiSum
                                                    .toString()
                                                    .substring(0, 3)
                                                    : dpiSum.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border:
                                  Border.all(color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 12, right: 10.0, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'SPI Cumulative',
                                          style: TextStyle(
                                              fontSize:
                                              ScreenSize.screenWidth * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper: (ChartData data, _) =>
                                                data.x,
                                                yValueMapper: (ChartData data, _) =>
                                                data.y,
                                                // Mode of grouping
                                                groupMode:
                                                CircularChartGroupMode.point,
                                                groupTo: 2,
                                              )
                                            ],
                                          ),
                                          Positioned(
                                              left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.2,
                                              top: 85,
                                              child: Text(
                                                spiSum.toString().length > 4
                                                    ? spiSum
                                                    .toString()
                                                    .substring(0, 3)
                                                    : spiSum.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border:
                                  Border.all(color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 12, right: 10.0, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'PRI Cumulative',
                                          style: TextStyle(
                                              fontSize:
                                              ScreenSize.screenWidth * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper: (ChartData data, _) =>
                                                data.x,
                                                yValueMapper: (ChartData data, _) =>
                                                data.y,
                                                // Mode of grouping
                                                groupMode:
                                                CircularChartGroupMode.point,
                                                groupTo: 2,
                                              )
                                            ],
                                          ),
                                          Positioned(
                                              left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.2,
                                              top: 85,
                                              child: Text(
                                                priSum.toString().length > 4
                                                    ? priSum
                                                    .toString()
                                                    .substring(0, 3)
                                                    : priSum.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border:
                                  Border.all(color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 12, right: 10.0, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'QPI Cumulative',
                                          style: TextStyle(
                                              fontSize:
                                              ScreenSize.screenWidth * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper: (ChartData data, _) =>
                                                data.x,
                                                yValueMapper: (ChartData data, _) =>
                                                data.y,
                                                // Mode of grouping
                                                groupMode:
                                                CircularChartGroupMode.point,
                                                groupTo: 2,
                                              )
                                            ],
                                          ),
                                          Positioned(
                                            left:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                            top: 85,
                                            child: Text(
                                              qpiSum.toString().length > 4
                                                  ? qpiSum
                                                  .toString()
                                                  .substring(0, 3)
                                                  : qpiSum.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    width: ScreenSize.screenWidth ,
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ref
                                .watch(individualReportNotifier(filter))
                                .when(data: (data) {
                              _teamReportListSource =
                                  TeamReportListSource(teamSpent: data);
                              return Container();
                            }, error: (e, s) {
                              return Container();
                            }, loading: () {
                              return Container();
                            }),

                            SfDataGridTheme(
                              data: SfDataGridThemeData(),
                              child: SfDataGrid(
                                  allowSwiping: true,
                                  swipeMaxOffset: 100.0,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  columnWidthCalculationRange:
                                  ColumnWidthCalculationRange.allRows,
                                  source: _teamReportListSource,
                                  columns: [
                                    GridColumn(
                                        columnName: 'Date',
                                        label: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Date',
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        columnName: 'User Name',
                                        label: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'User Name',
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        columnName: 'Project Name',
                                        label: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Project Name',
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        columnName: 'Task Name',
                                        label: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Task Name',
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ))),
                                    GridColumn(
                                        columnName: 'Spent Hrs',
                                        label: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Spent Hrs',
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ))),
                                  ]),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }, error: (error, s) {
              final List<ChartData> chartData2 = [
                ChartData('Scored', 0),
                ChartData('Overall', 0),
              ];
              return Row(
                children: [
                  Expanded(
                      child: Card(
                    elevation: 20,
                    child: Container(
                      height: 270,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'DPI Cumulative ',
                                  style: TextStyle(
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                      borderWidth: 1,
                                      toggleSeriesVisibility: true,
                                      position: LegendPosition.bottom,
                                      title: LegendTitle(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: chartData2,
                                        innerRadius: '75%',
                                        radius: '65',
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        // Mode of grouping
                                        groupMode: CircularChartGroupMode.point,
                                        groupTo: 2,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                // Renders the data label
                                                isVisible: true,
                                                useSeriesColor: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .outside),
                                      )
                                    ],
                                  ),
                                  const Positioned(
                                      left: 110,
                                      top: 85,
                                      child: Text(
                                        '10',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Card(
                    elevation: 20,
                    child: Container(
                      height: 270,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SPI Cumulative',
                                  style: TextStyle(
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                      borderWidth: 1,
                                      toggleSeriesVisibility: true,
                                      position: LegendPosition.bottom,
                                      title: LegendTitle(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: chartData2,
                                        innerRadius: '75%',
                                        radius: '65',
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        // Mode of grouping
                                        groupMode: CircularChartGroupMode.point,
                                        groupTo: 2,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                // Renders the data label
                                                isVisible: true,
                                                useSeriesColor: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .outside),
                                      )
                                    ],
                                  ),
                                  const Positioned(
                                      left: 110,
                                      top: 85,
                                      child: Text(
                                        '10',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Card(
                    elevation: 20,
                    child: Container(
                      height: 270,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PRI Cumulative',
                                  style: TextStyle(
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                      borderWidth: 1,
                                      toggleSeriesVisibility: true,
                                      position: LegendPosition.bottom,
                                      title: LegendTitle(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: chartData2,
                                        innerRadius: '75%',
                                        radius: '65',
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        // Mode of grouping
                                        groupMode: CircularChartGroupMode.point,
                                        groupTo: 2,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                // Renders the data label
                                                isVisible: true,
                                                useSeriesColor: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .outside),
                                      )
                                    ],
                                  ),
                                  const Positioned(
                                      left: 110,
                                      top: 85,
                                      child: Text(
                                        '10',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Card(
                    elevation: 20,
                    child: Container(
                      height: 270,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey, width: 0.01)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 12, right: 10.0, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'QPI Cumulative',
                                  style: TextStyle(
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  SfCircularChart(
                                    legend: Legend(
                                      isVisible: true,
                                      borderWidth: 1,
                                      toggleSeriesVisibility: true,
                                      position: LegendPosition.bottom,
                                      title: LegendTitle(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    series: <CircularSeries>[
                                      DoughnutSeries<ChartData, String>(
                                        dataSource: chartData2,
                                        innerRadius: '75%',
                                        radius: '65',
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        // Mode of grouping
                                        groupMode: CircularChartGroupMode.point,
                                        groupTo: 2,
                                        dataLabelSettings:
                                            const DataLabelSettings(
                                                // Renders the data label
                                                isVisible: true,
                                                useSeriesColor: true,
                                                labelPosition:
                                                    ChartDataLabelPosition
                                                        .outside),
                                      )
                                    ],
                                  ),
                                  const Positioned(
                                    left: 110,
                                    top: 85,
                                    child: Text(
                                      '10',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              );
            }, loading: () {
              return ShimmerUserUpdate();
            }),
          ],
        ),
      ),
    );
  }

  Widget windowViewHomeScreen(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 300,
              color: AppColors.bg,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 10, bottom: 15),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenSize.screenWidth * 0.02),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (Helper.sharedRoleId == 'SuperAdmin') {
                              Navigator.pushNamed(
                                  context, AppId.RATING_LIST_SCREEN_ID);
                            } else if (Helper.sharedRoleId ==
                                'DepartmentHead') {
                              Navigator.pushNamed(
                                  context, AppId.RATING_LIST_SCREEN_ID);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Do not Access !'
                                    ''),
                              ));
                            }
                          },
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Rating Report',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: SvgPicture.asset(
                                            'assets/rating.svg',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.0075),
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (Helper.sharedRoleId == 'SuperAdmin') {
                              Navigator.pushNamed(
                                  context, AppId.PROJECT_REPORT_SCREEN_ID);
                            } else if (Helper.sharedRoleId ==
                                'DepartmentHead') {
                              Navigator.pushNamed(context,
                                  AppId.PROJECT_REPORT_DEP_HEAD_SCREEN_ID);
                            } else if (Helper.sharedRoleId == 'Manager') {
                              Navigator.pushNamed(context,
                                  AppId.PROJECT_REPORT_DEP_HEAD_SCREEN_ID);
                            } else if (Helper.sharedRoleId == 'TeamLead') {
                              Navigator.pushNamed(context,
                                  AppId.PROJECT_REPORT_TEAM_LEAD_SCREEN_ID);
                            }
                          },
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Project Report',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: SvgPicture.asset(
                                            'assets/project.svg',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.0075),
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            if (Helper.sharedRoleId == 'TeamLead') {
                              Navigator.pushNamed(
                                  context, AppId.TEAMLEAD_REPORT);
                            } else {
                              Navigator.pushNamed(
                                  context, AppId.TEAMWISE_REPORT);
                            }
                          },
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'TeamWise Report',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: SvgPicture.asset(
                                            'assets/team.svg',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.0075),
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {},
                          child: Card(
                            elevation: 20,
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Attendance Report',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: SvgPicture.asset(
                                            'assets/timesheet.svg',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'The project report details the project proposal in order to assess the feasibility of the planned plan/activity.',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.0075),
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: ScreenSize.screenHeight * 0.3,
          child: SizedBox(
            height: ScreenSize.screenHeight * 0.9,
            width: ScreenSize.screenWidth * 0.78,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ref.watch(getCumulativePerformance).when(data: (data) {
                      final List<ChartData> chartData2 = [
                        ChartData('Scored', data.dpiTotal),
                        ChartData('Overall', 100),
                      ];
                      num dpiSum = 0;
                      num spiSum = 0;
                      num qpiSum = 0;
                      num priSum = 0;
                      if (data.dpiTotal != null) {
                        num dpiTotal = data.dpiTotal;
                        dpiSum = dpiTotal / data.dpicount;
                      }
                      if (data.spiTotal != null) {
                        num spiTotal = data.spiTotal;
                        spiSum = spiTotal / data.spicount;
                      }
                      if (data.qpiTotal != null) {
                        num qpiTotal = data.qpiTotal;
                        qpiSum = qpiTotal/ data.qpicount ;
                      }
                      if (data.priTotal != null) {
                        num priTotal = data.priTotal;
                        priSum = priTotal/ data.pricount;
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Card(
                                elevation: 20,
                                child: Container(
                                  height: 270,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.01)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 12,
                                        right: 10.0,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'DPI Cumulative ',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenSize.screenWidth * 0.01,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              SfCircularChart(
                                                legend: Legend(
                                                  isVisible: true,
                                                  borderWidth: 1,
                                                  toggleSeriesVisibility: true,
                                                  position: LegendPosition.bottom,
                                                  title: LegendTitle(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                series: <CircularSeries>[
                                                  DoughnutSeries<ChartData, String>(
                                                    dataSource: chartData2,
                                                    innerRadius: '75%',
                                                    radius: '65',
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.y,
                                                    // Mode of grouping
                                                    groupMode:
                                                        CircularChartGroupMode
                                                            .point,
                                                    groupTo: 2,
                                                  )
                                                ],
                                              ),
                                              Positioned(
                                                  left: 110,
                                                  top: 85,
                                                  child: Text(
                                                    dpiSum.toString().length > 4
                                                        ? dpiSum
                                                            .toString()
                                                            .substring(0, 3)
                                                        : dpiSum.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Card(
                                elevation: 20,
                                child: Container(
                                  height: 270,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.01)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 12,
                                        right: 10.0,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'SPI Cumulative',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenSize.screenWidth * 0.01,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              SfCircularChart(
                                                legend: Legend(
                                                  isVisible: true,
                                                  borderWidth: 1,
                                                  toggleSeriesVisibility: true,
                                                  position: LegendPosition.bottom,
                                                  title: LegendTitle(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                series: <CircularSeries>[
                                                  DoughnutSeries<ChartData, String>(
                                                    dataSource: chartData2,
                                                    innerRadius: '75%',
                                                    radius: '65',
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.y,
                                                    // Mode of grouping
                                                    groupMode:
                                                        CircularChartGroupMode
                                                            .point,
                                                    groupTo: 2,
                                                  )
                                                ],
                                              ),
                                              Positioned(
                                                  left: 110,
                                                  top: 85,
                                                  child: Text(
                                                    spiSum.toString().length > 4
                                                        ? spiSum
                                                            .toString()
                                                            .substring(0, 3)
                                                        : spiSum.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Card(
                                elevation: 20,
                                child: Container(
                                  height: 270,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.01)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 12,
                                        right: 10.0,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'PRI Cumulative',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenSize.screenWidth * 0.01,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              SfCircularChart(
                                                legend: Legend(
                                                  isVisible: true,
                                                  borderWidth: 1,
                                                  toggleSeriesVisibility: true,
                                                  position: LegendPosition.bottom,
                                                  title: LegendTitle(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                series: <CircularSeries>[
                                                  DoughnutSeries<ChartData, String>(
                                                    dataSource: chartData2,
                                                    innerRadius: '75%',
                                                    radius: '65',
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.y,
                                                    // Mode of grouping
                                                    groupMode:
                                                        CircularChartGroupMode
                                                            .point,
                                                    groupTo: 2,
                                                  )
                                                ],
                                              ),
                                               Positioned(
                                                  left: 110,
                                                  top: 85,
                                                 child: Text(
                                                   priSum.toString().length > 4
                                                       ? priSum
                                                       .toString()
                                                       .substring(0, 3)
                                                       : priSum.toString(),
                                                   style: const TextStyle(
                                                       color: Colors.black,
                                                       fontWeight: FontWeight.bold),
                                                 ),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Card(
                                elevation: 20,
                                child: Container(
                                  height: 270,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.01)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 12,
                                        right: 10.0,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'QPI Cumulative',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenSize.screenWidth * 0.01,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              SfCircularChart(
                                                legend: Legend(
                                                  isVisible: true,
                                                  borderWidth: 1,
                                                  toggleSeriesVisibility: true,
                                                  position: LegendPosition.bottom,
                                                  title: LegendTitle(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                series: <CircularSeries>[
                                                  DoughnutSeries<ChartData, String>(
                                                    dataSource: chartData2,
                                                    innerRadius: '75%',
                                                    radius: '65',
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.y,
                                                    // Mode of grouping
                                                    groupMode:
                                                        CircularChartGroupMode
                                                            .point,
                                                    groupTo: 2,
                                                  )
                                                ],
                                              ),
                                              Positioned(
                                                left: 110,
                                                top: 85,
                                                child: Text(
                                                  qpiSum.toString().length > 4
                                                      ? qpiSum
                                                          .toString()
                                                          .substring(0, 3)
                                                      : qpiSum.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                            ],
                          ),
                          SizedBox(
                            height: ScreenSize.screenHeight * 0.6,
                            width: ScreenSize.screenWidth ,
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ref
                                        .watch(individualReportNotifier(filter))
                                        .when(data: (data) {
                                      _teamReportListSource =
                                          TeamReportListSource(teamSpent: data);
                                      return Container();
                                    }, error: (e, s) {
                                      return Container();
                                    }, loading: () {
                                      return Container();
                                    }),

                                    SfDataGridTheme(
                                      data: SfDataGridThemeData(),
                                      child: SfDataGrid(
                                          allowSwiping: true,
                                          swipeMaxOffset: 100.0,
                                          columnWidthMode: ColumnWidthMode.fill,
                                          columnWidthCalculationRange:
                                          ColumnWidthCalculationRange.allRows,
                                          source: _teamReportListSource,
                                          columns: [
                                            GridColumn(
                                                columnName: 'Date',
                                                label: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'Date',
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ))),
                                            GridColumn(
                                                columnName: 'User Name',
                                                label: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'User Name',
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ))),
                                            GridColumn(
                                                columnName: 'Project Name',
                                                label: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'Project Name',
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ))),
                                            GridColumn(
                                                columnName: 'Task Name',
                                                label: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'Task Name',
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ))),
                                            GridColumn(
                                                columnName: 'Spent Hrs',
                                                label: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'Spent Hrs',
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ))),
                                          ]),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }, error: (error, s) {
                      final List<ChartData> chartData2 = [
                        ChartData('Scored', 0),
                        ChartData('Overall', 0),
                      ];
                      return Row(
                        children: [
                          Expanded(
                              child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'DPI Cumulative ',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenSize.screenWidth * 0.01,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                // Mode of grouping
                                                groupMode:
                                                    CircularChartGroupMode
                                                        .point,
                                                groupTo: 2,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        // Renders the data label
                                                        isVisible: true,
                                                        useSeriesColor: true,
                                                        labelPosition:
                                                            ChartDataLabelPosition
                                                                .outside),
                                              )
                                            ],
                                          ),
                                          const Positioned(
                                              left: 110,
                                              top: 85,
                                              child: Text(
                                                '10',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'SPI Cumulative',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenSize.screenWidth * 0.01,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                // Mode of grouping
                                                groupMode:
                                                    CircularChartGroupMode
                                                        .point,
                                                groupTo: 2,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        // Renders the data label
                                                        isVisible: true,
                                                        useSeriesColor: true,
                                                        labelPosition:
                                                            ChartDataLabelPosition
                                                                .outside),
                                              )
                                            ],
                                          ),
                                          const Positioned(
                                              left: 110,
                                              top: 85,
                                              child: Text(
                                                '10',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'PRI Cumulative',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenSize.screenWidth * 0.01,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                // Mode of grouping
                                                groupMode:
                                                    CircularChartGroupMode
                                                        .point,
                                                groupTo: 2,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        // Renders the data label
                                                        isVisible: true,
                                                        useSeriesColor: true,
                                                        labelPosition:
                                                            ChartDataLabelPosition
                                                                .outside),
                                              )
                                            ],
                                          ),
                                          const Positioned(
                                              left: 110,
                                              top: 85,
                                              child: Text(
                                                '10',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Card(
                            elevation: 20,
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.01)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 12,
                                    right: 10.0,
                                    bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'QPI Cumulative',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenSize.screenWidth * 0.01,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SfCircularChart(
                                            legend: Legend(
                                              isVisible: true,
                                              borderWidth: 1,
                                              toggleSeriesVisibility: true,
                                              position: LegendPosition.bottom,
                                              title: LegendTitle(
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: chartData2,
                                                innerRadius: '75%',
                                                radius: '65',
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                // Mode of grouping
                                                groupMode:
                                                    CircularChartGroupMode
                                                        .point,
                                                groupTo: 2,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        // Renders the data label
                                                        isVisible: true,
                                                        useSeriesColor: true,
                                                        labelPosition:
                                                            ChartDataLabelPosition
                                                                .outside),
                                              )
                                            ],
                                          ),
                                          const Positioned(
                                            left: 110,
                                            top: 85,
                                            child: Text(
                                              '10',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                        ],
                      );
                    }, loading: () {
                      return ShimmerUserUpdate();
                    }),


                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  itemBuilderProjectSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        children: const [
          Expanded(
              flex: 2,
              child: Text(
                'Pmp',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.normal),
              )),
          Expanded(
              flex: 2,
              child: Text('123456',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.normal))),
          Expanded(
              flex: 2,
              child: Text('10-03-2022',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.normal))),
          Expanded(
              flex: 2,
              child: Text('10-04-2022',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.normal))),
          Expanded(
            flex: 2,
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.bg,
              ),
              value: 0.8,
            ),
          )
        ],
      ),
    );
  }
}

class Time extends StatelessWidget {
  const Time({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(const Duration(seconds: 1),
        builder: (context) {
      return Text(
        "$getSystemTime",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      );
    });
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("H:m:s").format(now).toString();
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  dynamic y;
  final Color? color;
}

class ChartDataValue {
  ChartDataValue(this.s, this.i, this.color);

  final String s;
  final int i;
  final Color color;
}

class ChartData1 {
  ChartData1(this.x, this.y);

  final int x;
  final double y;
}
