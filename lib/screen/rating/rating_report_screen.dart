import 'package:auto_size_text/auto_size_text.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:flutter/material.dart';
import 'package:pmp/res/colors.dart';
import 'package:intl/intl.dart';
import 'package:pmp/service/apiService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../helper.dart';
import '../../model/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../../model/overall_rating_model.dart';
import '../../model/projectmanagementprocessratingperformance.dart';
import '../../provider/changenotifier/widget_notifier.dart';
import '../../provider/project_creation_provider/project_creation_provider.dart';
import '../../provider/ratingproider/useratingprovider.dart';
import '../../res/ScreenSize.dart';
import '../director/dashboard/director_home_screen.dart';

class RatingReportScreen extends ConsumerStatefulWidget {
  const RatingReportScreen({Key? key}) : super(key: key);

  @override
  _RatingReportScreenState createState() => _RatingReportScreenState();
}

class _RatingReportScreenState extends ConsumerState<RatingReportScreen> {
  // late UserListSource userListSource;
  List<dynamic> userList = [];
  Map<dynamic, dynamic> splitTeam = {};
  Map<dynamic, dynamic> splitDepartment = {};
  String? type, dep, team;
  var depId, teamId;
  int stateValue = 0;
  num dpi=0;
  num spi=0;
  num qpi=0;
  num pri=0;
  late UserListSource _employeeDataSource;
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  List<Data> rating = [];



  @override
  void initState() {
     ref.refresh(getOverAllRatingList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return windowsUi(context);
  }

  windowsUi(BuildContext context) {
    ref.watch(counterModelProvider);
    return stateValue == 0
        ? defaultUi(context)
        : stateValue == 1
            ? departmentUi(context)
            : teamUI(context);
  }

  defaultUi(BuildContext context) {
    return ref.watch(getOverAllRatingList).when(data: (data) {
      final List<ChartData> chartData = [];
      final List<ChartData> chartData2 = [];
      final List<ChartData> chartData3 = [];
      final List<ChartData> chartData4 = [];

       if (data.projectManagementProcessUserRegistration!.isNotEmpty) {
         if( data.dpiTotal!=null){
           dpi =  data.dpiTotal/data.dpiCount;
         }
         if( data.spiTotal!=null){
           spi =  data.spiTotal/data.spiCount;
         }
         if( data.qpiTotal!=null){
           qpi =  data.qpiTotal/data.qpiCount;
         }
         if( data.priTotal!=null){
           pri =  data.priTotal/data.priCount;
         }

         _employeeDataSource = UserListSource(
             employees: data.projectManagementProcessUserRegistration!);
        chartData.add(ChartData('DPI',
            100, Colors.pink));
        chartData2.add(ChartData('SPI',
            100, Colors.blue));
        chartData3.add(
          ChartData('QPI', 100,
              Colors.deepOrangeAccent),
        );
        chartData4.add(ChartData('PRI',
            100, Colors.yellow));

      } else {
        _employeeDataSource = UserListSource(employees: []);
      }
      return RefreshIndicator(
        displacement: 200.0,
        onRefresh: () async {},
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: data.projectManagementProcessUserRegistration!.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.arrow_back_ios)),
                                    Text(
                                      'Ratting Report',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.015),
                                    ),

                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: InkWell(
                                        onTap: () {
                                          exportDataGridToExcel(data);
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    ref.watch(counterModelProvider);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, left: 12),
                                      child: Container(
                                        width: ScreenSize.screenWidth,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 1.0),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              iconSize: 24,
                                              elevation: 16,
                                              hint: const Text('Department'),
                                              value: dep,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              onChanged: (String? newValue) {
                                                ref
                                                    .read(counterModelProvider
                                                        .notifier)
                                                    .press();
                                                dep = newValue;
                                                depId =
                                                    splitDepartment[newValue];
                                                stateValue = 1;
                                              },
                                              items: Helper.departmentList.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                splitDepartment[
                                                        value.split('*').last] =
                                                    value.split('*').first;
                                                return DropdownMenuItem<String>(
                                                  value: value.split('*').last,
                                                  child: Row(
                                                    children: [
                                                      Text(value
                                                          .split('*')
                                                          .last),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Consumer(builder: (context, ref, child) {
                                  ref.watch(counterModelProvider);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 12, right: 12),
                                    child: Container(
                                      width: ScreenSize.screenWidth,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1.0),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            iconSize: 24,
                                            elevation: 16,
                                            hint: const Text('Team'),
                                            value: team,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            onChanged: (String? newValue) {
                                              ref
                                                  .read(counterModelProvider
                                                      .notifier)
                                                  .press();
                                              team = newValue;
                                              String splitData =
                                                  splitTeam[newValue];
                                              teamId = splitData.split('*')[0];
                                              stateValue = 2;
                                            },
                                            items: Helper.teamList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              splitTeam[value.split('*')[1]] =
                                                  value.split('*')[0] +
                                                      '*' +
                                                      value.split('*')[2];
                                              return DropdownMenuItem<String>(
                                                value: value.split('*')[1],
                                                child: Row(
                                                  children: [
                                                    Text(value.split('*')[1]),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )),
                         Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 8.0, right: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Card(
                                      elevation: 20,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                              radius: '65',
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      data.color,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                              // Mode of grouping
                                              groupMode:
                                                  CircularChartGroupMode.point,
                                              groupTo: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Center(
                                          child: Text(
                                            dpi.toString().length >
                                                3
                                            ? dpi.toString().substring(0, 3) +
                                                '%'
                                            : dpi.toString() +
                                                '%',
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
                                    Card(
                                      elevation: 20,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                              dataSource: chartData2,
                                              innerRadius: '75%',
                                              radius: '65',
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      data.color,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                              // Mode of grouping
                                              groupMode:
                                                  CircularChartGroupMode.point,
                                              groupTo: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Center(
                                          child: Text(
                                     spi
                                                    .toString()
                                                    .length >
                                                3
                                            ?  spi
                                                    .toString()
                                                    .substring(0, 3) +
                                                '%'
                                            :  spi
                                                    .toString() +
                                                '%',
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
                                    Card(
                                      elevation: 20,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                              radius: '65',
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      data.color,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                              // Mode of grouping
                                              groupMode:
                                                  CircularChartGroupMode.point,
                                              groupTo: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Center(
                                          child: Text(
                                            qpi
                                                    .toString()
                                                    .length >
                                                3
                                            ?qpi
                                                    .toString()
                                                    .substring(0, 3) +
                                                '%'
                                            : qpi
                                                    .toString() +
                                                '%',
                                        maxLines: 3,
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
                                    Card(
                                      elevation: 20,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                              radius: '65',
                                              pointColorMapper:
                                                  (ChartData data, _) =>
                                                      data.color,
                                              xValueMapper:
                                                  (ChartData data, _) => data.x,
                                              yValueMapper:
                                                  (ChartData data, _) => data.y,
                                              // Mode of grouping
                                              groupMode:
                                                  CircularChartGroupMode.point,
                                              groupTo: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Center(
                                          child: Text(
                                     pri
                                                    .toString()
                                                    .length >
                                                3
                                            ? pri
                                                    .toString()
                                                    .substring(0, 3) +
                                                '%'
                                            :pri
                                                    .toString() +
                                                '%',
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
                      Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 20,
                              child: SfDataGridTheme(
                                data: SfDataGridThemeData(
                                    gridLineColor: AppColors.icon,
                                    headerColor: Colors.white38,
                                    headerHoverColor: AppColors.bg),
                                child: SfDataGrid(
                                    key: key,
                                    allowSwiping: true,
                                    swipeMaxOffset: 100.0,
                                    columnWidthMode: ColumnWidthMode.fill,
                                    columnWidthCalculationRange:
                                        ColumnWidthCalculationRange.allRows,
                                    gridLinesVisibility:
                                        GridLinesVisibility.both,
                                    headerGridLinesVisibility:
                                        GridLinesVisibility.both,
                                    source: _employeeDataSource,
                                    columns: [
                                      GridColumn(
                                          columnName: 'name',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'NAME',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'Employee code',
                                          label: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'EMPLOYEE CODE',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'Type',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'TYPE',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'DPI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'DPI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'SPI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'SPI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'QPI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'QPI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'PRI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'PRI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),

                                    ]),
                              ),
                            ),
                          ))
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.arrow_back_ios)),
                                    Text(
                                      'Ratting Sheet - ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                    ),
                                    Text(
                                      'April - 2022',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.date_range_outlined))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: SizedBox(
                                          height: 25,
                                          width: 25.0,
                                          child: SvgPicture.asset(
                                              'assets/file.svg'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: InkWell(
                                        onTap: () {},
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Consumer(builder: (context, ref, child) {
                                  ref.watch(counterModelProvider);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 12),
                                    child: Container(
                                      width: ScreenSize.screenWidth,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1.0),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            iconSize: 24,
                                            elevation: 16,
                                            hint: const Text('Department'),
                                            value: dep,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            onChanged: (String? newValue) {
                                              ref
                                                  .read(counterModelProvider
                                                      .notifier)
                                                  .press();
                                              dep = newValue;
                                              depId = splitDepartment[newValue];
                                              stateValue = 1;
                                            },
                                            items: Helper.departmentList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              splitDepartment[
                                                      value.split('*').last] =
                                                  value.split('*').first;
                                              return DropdownMenuItem<String>(
                                                value: value.split('*').last,
                                                child: Row(
                                                  children: [
                                                    Text(value.split('*').last),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              Expanded(
                                flex: 3,
                                child: Consumer(builder: (context, ref, child) {
                                  ref.watch(counterModelProvider);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 12, right: 12),
                                    child: Container(
                                      width: ScreenSize.screenWidth,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1.0),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            iconSize: 24,
                                            elevation: 16,
                                            hint: const Text('Team'),
                                            value: team,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            onChanged: (String? newValue) {
                                              ref
                                                  .read(counterModelProvider
                                                      .notifier)
                                                  .press();
                                              team = newValue;
                                              String splitData =
                                                  splitTeam[newValue];
                                              teamId = splitData.split('*')[0];
                                              stateValue = 2;
                                            },
                                            items: Helper.teamList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              splitTeam[value.split('*')[1]] =
                                                  value.split('*')[0] +
                                                      '*' +
                                                      value.split('*')[2];
                                              return DropdownMenuItem<String>(
                                                value: value.split('*')[1],
                                                child: Row(
                                                  children: [
                                                    Text(value.split('*')[1]),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )),
                      const Expanded(
                        flex: 3,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
                          child: Center(
                            child: Text('No Data'),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 20,
                              child: SfDataGridTheme(
                                data: SfDataGridThemeData(
                                    gridLineColor: AppColors.icon,
                                    headerColor: Colors.white38,
                                    headerHoverColor: AppColors.bg),
                                child: SfDataGrid(
                                    key: key,
                                    allowSwiping: true,
                                    swipeMaxOffset: 100.0,
                                    columnWidthMode: ColumnWidthMode.fill,
                                    columnWidthCalculationRange:
                                    ColumnWidthCalculationRange.allRows,
                                    gridLinesVisibility:
                                    GridLinesVisibility.both,
                                    headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                    source: _employeeDataSource,
                                    columns: [
                                      GridColumn(
                                          columnName: 'name',
                                          label: Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'NAME',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'Employee code',
                                          label: Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'EMPLOYEE CODE',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'Type',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'TYPE',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'DPI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'DPI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'SPI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'SPI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'QPI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'QPI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),
                                      GridColumn(
                                          columnName: 'PRI',
                                          label: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'PRI',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ))),

                                    ]),
                              ),
                            ),
                          ))
                    ],
                  ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: const Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  stateValue = 0;
                  ref.read(counterModelProvider.notifier).press();
                },
              ),
            )),
      );
    }, error: (error, s) {
      return Scaffold(
        appBar: AppBar(),
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text(error.toString()),
        ),
      );
    }, loading: () {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Loading'),
        ),
      );
    });
  }

  departmentUi(BuildContext context) {
    return ref.watch(getOverAllRatingDepList(depId)).when(data: (data) {
      final List<ChartData> chartData = [];
      final List<ChartData> chartData2 = [];
      final List<ChartData> chartData3 = [];
      final List<ChartData> chartData4 = [];
      if (data.projectManagementProcessUserRegistration!.isNotEmpty) {
        if( data.dpiTotal!=null){
          dpi =  data.dpiTotal/data.dpiCount;
        }
        if( data.spiTotal!=null){
          spi =  data.spiTotal/data.spiCount;
        }
        if( data.qpiTotal!=null){
          qpi =  data.qpiTotal/data.qpiCount;
        }
        if( data.priTotal!=null){
          pri =  data.priTotal/data.priCount;
        }

        _employeeDataSource = UserListSource(
            employees: data.projectManagementProcessUserRegistration!);
        chartData.add(ChartData('DPI',
            100, Colors.pink));
        chartData2.add(ChartData('SPI',
            100, Colors.blue));
        chartData3.add(
          ChartData('QPI', 100,
              Colors.deepOrangeAccent),
        );
        chartData4.add(ChartData('PRI',
            100, Colors.yellow));

      } else {
        _employeeDataSource = UserListSource(employees: []);
      }
      return RefreshIndicator(
        onRefresh: () async {
          stateValue = 0;
          ref.refresh(getRatingNoitifer);
        },
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: data.projectManagementProcessUserRegistration!.isNotEmpty
                ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios)),
                              Text(
                                'Ratting Report',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.015),
                              ),

                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8),
                                child: InkWell(
                                  onTap: () {
                                    exportDataGridToExcel(data);
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Consumer(
                            builder: (context, ref, child) {
                              ref.watch(counterModelProvider);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 12),
                                child: Container(
                                  width: ScreenSize.screenWidth,
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        iconSize: 24,
                                        elevation: 16,
                                        hint: const Text('Department'),
                                        value: dep,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        onChanged: (String? newValue) {
                                          ref
                                              .read(counterModelProvider
                                              .notifier)
                                              .press();
                                          dep = newValue;
                                          depId =
                                          splitDepartment[newValue];
                                          stateValue = 1;
                                        },
                                        items: Helper.departmentList.map<
                                            DropdownMenuItem<String>>(
                                                (String value) {
                                              splitDepartment[
                                              value.split('*').last] =
                                                  value.split('*').first;
                                              return DropdownMenuItem<String>(
                                                value: value.split('*').last,
                                                child: Row(
                                                  children: [
                                                    Text(value
                                                        .split('*')
                                                        .last),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Consumer(builder: (context, ref, child) {
                            ref.watch(counterModelProvider);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12, right: 12),
                              child: Container(
                                width: ScreenSize.screenWidth,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: const Text('Team'),
                                      value: team,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(counterModelProvider
                                            .notifier)
                                            .press();
                                        team = newValue;
                                        String splitData =
                                        splitTeam[newValue];
                                        teamId = splitData.split('*')[0];
                                        stateValue = 2;
                                      },
                                      items: Helper.teamList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            splitTeam[value.split('*')[1]] =
                                                value.split('*')[0] +
                                                    '*' +
                                                    value.split('*')[2];
                                            return DropdownMenuItem<String>(
                                              value: value.split('*')[1],
                                              child: Row(
                                                children: [
                                                  Text(value.split('*')[1]),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      dpi.toString().length >
                                          3
                                          ? dpi.toString().substring(0, 3) +
                                          '%'
                                          : dpi.toString() +
                                          '%',
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
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        dataSource: chartData2,
                                        innerRadius: '75%',
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      spi
                                          .toString()
                                          .length >
                                          3
                                          ?  spi
                                          .toString()
                                          .substring(0, 3) +
                                          '%'
                                          :  spi
                                          .toString() +
                                          '%',
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
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      qpi
                                          .toString()
                                          .length >
                                          3
                                          ?qpi
                                          .toString()
                                          .substring(0, 3) +
                                          '%'
                                          : qpi
                                          .toString() +
                                          '%',
                                      maxLines: 3,
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
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      pri
                                          .toString()
                                          .length >
                                          3
                                          ? pri
                                          .toString()
                                          .substring(0, 3) +
                                          '%'
                                          :pri
                                          .toString() +
                                          '%',
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
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                              gridLineColor: AppColors.icon,
                              headerColor: Colors.white38,
                              headerHoverColor: AppColors.bg),
                          child: SfDataGrid(
                              key: key,
                              allowSwiping: true,
                              swipeMaxOffset: 100.0,
                              columnWidthMode: ColumnWidthMode.fill,
                              columnWidthCalculationRange:
                              ColumnWidthCalculationRange.allRows,
                              gridLinesVisibility:
                              GridLinesVisibility.both,
                              headerGridLinesVisibility:
                              GridLinesVisibility.both,
                              source: _employeeDataSource,
                              columns: [
                                GridColumn(
                                    columnName: 'name',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'NAME',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Employee code',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'EMPLOYEE CODE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Type',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'TYPE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'DPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'DPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'SPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'SPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'QPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'QPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'PRI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'PRI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),

                              ]),
                        ),
                      ),
                    ))
              ],
            )
                : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                              Text(
                                'Ratting Sheet - ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.02),
                              ),
                              Text(
                                'April - 2022',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.date_range_outlined))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SizedBox(
                                    height: 25,
                                    width: 25.0,
                                    child: SvgPicture.asset(
                                        'assets/file.svg'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8),
                                child: InkWell(
                                  onTap: () {},
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Consumer(builder: (context, ref, child) {
                            ref.watch(counterModelProvider);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12),
                              child: Container(
                                width: ScreenSize.screenWidth,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: const Text('Department'),
                                      value: dep,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(counterModelProvider
                                            .notifier)
                                            .press();
                                        dep = newValue;
                                        depId = splitDepartment[newValue];
                                        stateValue = 1;
                                      },
                                      items: Helper.departmentList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            splitDepartment[
                                            value.split('*').last] =
                                                value.split('*').first;
                                            return DropdownMenuItem<String>(
                                              value: value.split('*').last,
                                              child: Row(
                                                children: [
                                                  Text(value.split('*').last),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Expanded(
                          flex: 3,
                          child: Consumer(builder: (context, ref, child) {
                            ref.watch(counterModelProvider);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12, right: 12),
                              child: Container(
                                width: ScreenSize.screenWidth,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: const Text('Team'),
                                      value: team,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(counterModelProvider
                                            .notifier)
                                            .press();
                                        team = newValue;
                                        String splitData =
                                        splitTeam[newValue];
                                        teamId = splitData.split('*')[0];
                                        stateValue = 2;
                                      },
                                      items: Helper.teamList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            splitTeam[value.split('*')[1]] =
                                                value.split('*')[0] +
                                                    '*' +
                                                    value.split('*')[2];
                                            return DropdownMenuItem<String>(
                                              value: value.split('*')[1],
                                              child: Row(
                                                children: [
                                                  Text(value.split('*')[1]),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                const Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
                    child: Center(
                      child: Text('No Data'),
                    ),
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                              gridLineColor: AppColors.icon,
                              headerColor: Colors.white38,
                              headerHoverColor: AppColors.bg),
                          child: SfDataGrid(
                              key: key,
                              allowSwiping: true,
                              swipeMaxOffset: 100.0,
                              columnWidthMode: ColumnWidthMode.fill,
                              columnWidthCalculationRange:
                              ColumnWidthCalculationRange.allRows,
                              gridLinesVisibility:
                              GridLinesVisibility.both,
                              headerGridLinesVisibility:
                              GridLinesVisibility.both,
                              source: _employeeDataSource,
                              columns: [
                                GridColumn(
                                    columnName: 'name',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'NAME',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Employee code',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'EMPLOYEE CODE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Type',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'TYPE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'DPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'DPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'SPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'SPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'QPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'QPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'PRI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'PRI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),

                              ]),
                        ),
                      ),
                    ))
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: const Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  stateValue = 0;
                  ref.read(counterModelProvider.notifier).press();
                },
              ),
            )),
      );
    }, error: (error, s) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Try Again'),
        ),
      );
    }, loading: () {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Loading'),
        ),
      );
    });
  }

  teamUI(BuildContext context) {
    return ref.watch(getOverAllRatingTeamList(teamId)).when(data: (data) {
      final List<ChartData> chartData = [];
      final List<ChartData> chartData2 = [];
      final List<ChartData> chartData3 = [];
      final List<ChartData> chartData4 = [];
      if (data.projectManagementProcessUserRegistration!.isNotEmpty) {
        if( data.dpiTotal!=null){
          dpi =  data.dpiTotal/data.dpiCount;
        }
        if( data.spiTotal!=null){
          spi =  data.spiTotal/data.spiCount;
        }
        if( data.qpiTotal!=null){
          qpi =  data.qpiTotal/data.qpiCount;
        }
        if( data.priTotal!=null){
          pri =  data.priTotal/data.priCount;
        }

        _employeeDataSource = UserListSource(
            employees: data.projectManagementProcessUserRegistration!);
        chartData.add(ChartData('DPI',
            100, Colors.pink));
        chartData2.add(ChartData('SPI',
            100, Colors.blue));
        chartData3.add(
          ChartData('QPI', 100,
              Colors.deepOrangeAccent),
        );
        chartData4.add(ChartData('PRI',
            100, Colors.yellow));

      } else {
        _employeeDataSource = UserListSource(employees: []);
      }

      return RefreshIndicator(
        onRefresh: () async {
          stateValue = 0;
          ref.refresh(getRatingNoitifer);
        },
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: data.projectManagementProcessUserRegistration!.isNotEmpty
                ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios)),
                              Text(
                                'Ratting Report',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.015),
                              ),

                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8),
                                child: InkWell(
                                  onTap: () {
                                    exportDataGridToExcel(data);
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Consumer(
                            builder: (context, ref, child) {
                              ref.watch(counterModelProvider);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 12),
                                child: Container(
                                  width: ScreenSize.screenWidth,
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        iconSize: 24,
                                        elevation: 16,
                                        hint: const Text('Department'),
                                        value: dep,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        onChanged: (String? newValue) {
                                          ref
                                              .read(counterModelProvider
                                              .notifier)
                                              .press();
                                          dep = newValue;
                                          depId =
                                          splitDepartment[newValue];
                                          stateValue = 1;
                                        },
                                        items: Helper.departmentList.map<
                                            DropdownMenuItem<String>>(
                                                (String value) {
                                              splitDepartment[
                                              value.split('*').last] =
                                                  value.split('*').first;
                                              return DropdownMenuItem<String>(
                                                value: value.split('*').last,
                                                child: Row(
                                                  children: [
                                                    Text(value
                                                        .split('*')
                                                        .last),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Consumer(builder: (context, ref, child) {
                            ref.watch(counterModelProvider);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12, right: 12),
                              child: Container(
                                width: ScreenSize.screenWidth,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: const Text('Team'),
                                      value: team,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(counterModelProvider
                                            .notifier)
                                            .press();
                                        team = newValue;
                                        String splitData =
                                        splitTeam[newValue];
                                        teamId = splitData.split('*')[0];
                                        stateValue = 2;
                                      },
                                      items: Helper.teamList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            splitTeam[value.split('*')[1]] =
                                                value.split('*')[0] +
                                                    '*' +
                                                    value.split('*')[2];
                                            return DropdownMenuItem<String>(
                                              value: value.split('*')[1],
                                              child: Row(
                                                children: [
                                                  Text(value.split('*')[1]),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      dpi.toString().length >
                                          3
                                          ? dpi.toString().substring(0, 3) +
                                          '%'
                                          : dpi.toString() +
                                          '%',
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
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        dataSource: chartData2,
                                        innerRadius: '75%',
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      spi
                                          .toString()
                                          .length >
                                          3
                                          ?  spi
                                          .toString()
                                          .substring(0, 3) +
                                          '%'
                                          :  spi
                                          .toString() +
                                          '%',
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
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      qpi
                                          .toString()
                                          .length >
                                          3
                                          ?qpi
                                          .toString()
                                          .substring(0, 3) +
                                          '%'
                                          : qpi
                                          .toString() +
                                          '%',
                                      maxLines: 3,
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
                              Card(
                                elevation: 20,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 15.0),
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
                                        radius: '65',
                                        pointColorMapper:
                                            (ChartData data, _) =>
                                        data.color,
                                        xValueMapper:
                                            (ChartData data, _) => data.x,
                                        yValueMapper:
                                            (ChartData data, _) => data.y,
                                        // Mode of grouping
                                        groupMode:
                                        CircularChartGroupMode.point,
                                        groupTo: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 25.0),
                                child: Center(
                                    child: Text(
                                      pri
                                          .toString()
                                          .length >
                                          3
                                          ? pri
                                          .toString()
                                          .substring(0, 3) +
                                          '%'
                                          :pri
                                          .toString() +
                                          '%',
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
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                              gridLineColor: AppColors.icon,
                              headerColor: Colors.white38,
                              headerHoverColor: AppColors.bg),
                          child: SfDataGrid(
                              key: key,
                              allowSwiping: true,
                              swipeMaxOffset: 100.0,
                              columnWidthMode: ColumnWidthMode.fill,
                              columnWidthCalculationRange:
                              ColumnWidthCalculationRange.allRows,
                              gridLinesVisibility:
                              GridLinesVisibility.both,
                              headerGridLinesVisibility:
                              GridLinesVisibility.both,
                              source: _employeeDataSource,
                              columns: [
                                GridColumn(
                                    columnName: 'name',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'NAME',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Employee code',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'EMPLOYEE CODE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Type',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'TYPE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'DPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'DPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'SPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'SPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'QPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'QPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'PRI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'PRI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),

                              ]),
                        ),
                      ),
                    ))
              ],
            )
                : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                              Text(
                                'Ratting Sheet - ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.02),
                              ),
                              Text(
                                'April - 2022',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.date_range_outlined))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SizedBox(
                                    height: 25,
                                    width: 25.0,
                                    child: SvgPicture.asset(
                                        'assets/file.svg'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8),
                                child: InkWell(
                                  onTap: () {},
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Consumer(builder: (context, ref, child) {
                            ref.watch(counterModelProvider);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12),
                              child: Container(
                                width: ScreenSize.screenWidth,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: const Text('Department'),
                                      value: dep,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(counterModelProvider
                                            .notifier)
                                            .press();
                                        dep = newValue;
                                        depId = splitDepartment[newValue];
                                        stateValue = 1;
                                      },
                                      items: Helper.departmentList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            splitDepartment[
                                            value.split('*').last] =
                                                value.split('*').first;
                                            return DropdownMenuItem<String>(
                                              value: value.split('*').last,
                                              child: Row(
                                                children: [
                                                  Text(value.split('*').last),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Expanded(
                          flex: 3,
                          child: Consumer(builder: (context, ref, child) {
                            ref.watch(counterModelProvider);
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12, right: 12),
                              child: Container(
                                width: ScreenSize.screenWidth,
                                height:
                                MediaQuery.of(context).size.height *
                                    0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: const Text('Team'),
                                      value: team,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String? newValue) {
                                        ref
                                            .read(counterModelProvider
                                            .notifier)
                                            .press();
                                        team = newValue;
                                        String splitData =
                                        splitTeam[newValue];
                                        teamId = splitData.split('*')[0];
                                        stateValue = 2;
                                      },
                                      items: Helper.teamList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            splitTeam[value.split('*')[1]] =
                                                value.split('*')[0] +
                                                    '*' +
                                                    value.split('*')[2];
                                            return DropdownMenuItem<String>(
                                              value: value.split('*')[1],
                                              child: Row(
                                                children: [
                                                  Text(value.split('*')[1]),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                const Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 10, left: 8.0, right: 8.0),
                    child: Center(
                      child: Text('No Data'),
                    ),
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                              gridLineColor: AppColors.icon,
                              headerColor: Colors.white38,
                              headerHoverColor: AppColors.bg),
                          child: SfDataGrid(
                              key: key,
                              allowSwiping: true,
                              swipeMaxOffset: 100.0,
                              columnWidthMode: ColumnWidthMode.fill,
                              columnWidthCalculationRange:
                              ColumnWidthCalculationRange.allRows,
                              gridLinesVisibility:
                              GridLinesVisibility.both,
                              headerGridLinesVisibility:
                              GridLinesVisibility.both,
                              source: _employeeDataSource,
                              columns: [
                                GridColumn(
                                    columnName: 'name',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'NAME',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Employee code',
                                    label: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'EMPLOYEE CODE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'Type',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'TYPE',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'DPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'DPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'SPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'SPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'QPI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'QPI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),
                                GridColumn(
                                    columnName: 'PRI',
                                    label: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'PRI',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ))),

                              ]),
                        ),
                      ),
                    ))
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                child: const Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  stateValue = 0;
                  ref.read(counterModelProvider.notifier).press();
                },
              ),
            )),
      );
    }, error: (error, s) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text(error.toString()),
        ),
      );
    }, loading: () {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text('Loading'),
        ),
      );
    });
  }

  Future<void> exportDataGridToExcel(OverAllRatingModel data) async {
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet worksheet = workbook.worksheets[0];
    final xls.Style style = workbook.styles.add('Style1');
    final xls.Style style1 = workbook.styles.add('Style2');
    style.hAlign = xls.HAlignType.center;
    style.bold = true;
    style1.hAlign = xls.HAlignType.center;
    style1.vAlign = xls.VAlignType.center;

    worksheet.getRangeByName('A1').setText('NAME');
    worksheet.getRangeByName('A1').cellStyle = style;
    worksheet.getRangeByName('B1').setText('EMPLOYEE CODE');
    worksheet.getRangeByName('B1').cellStyle = style;
    worksheet.getRangeByName('C1').setText('TYPE');
    worksheet.getRangeByName('C1').cellStyle = style;
    worksheet.getRangeByName('D1').setText('DPI');
    worksheet.getRangeByName('D1').cellStyle = style;
    worksheet.getRangeByName('E1').setText('SPI');
    worksheet.getRangeByName('E1').cellStyle = style;
    worksheet.getRangeByName('F1').setText('QPI');
    worksheet.getRangeByName('F1').cellStyle = style;
    worksheet.getRangeByName('G1').setText('PRI');
    worksheet.getRangeByName('G1').cellStyle = style;

    worksheet.getRangeByName('J1').cellStyle = style;
    worksheet.getRangeByName('A1').columnWidth = 40.82;
    worksheet.getRangeByName('B1').columnWidth = 15.82;
    worksheet.getRangeByName('C1').columnWidth = 20.82;
    worksheet.getRangeByName('D1').columnWidth = 20.82;
    worksheet.getRangeByName('E1').columnWidth = 20.82;
    worksheet.getRangeByName('F1').columnWidth = 20.82;
    worksheet.getRangeByName('G1').columnWidth = 25.82;

    for (int i = 0; i < data.projectManagementProcessUserRegistration!.length; i++) {
      worksheet
          .getRangeByName('A' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].userName);
      worksheet.getRangeByName('A' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('B' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].employeCode);
      worksheet.getRangeByName('B' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('C' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].type);
      worksheet.getRangeByName('C' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('D' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].dpiTotal.toString());
      worksheet.getRangeByName('D' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('E' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].spiTotal.toString());
      worksheet.getRangeByName('E' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('F' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].qpiTotal.toString());
      worksheet.getRangeByName('F' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('G' + (i + 2).toString())
          .setText(data.projectManagementProcessUserRegistration![i].priTotal.toString());
      worksheet.getRangeByName('G' + (i + 2).toString()).cellStyle = style1;

    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      String data = DateFormat("dd-MM-yyyy-HH-mm-ss").format(DateTime.now());
      final String fileName = '$path/RatingReport-' + data + '.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}

class UserListSource extends DataGridSource {
  UserListSource(
      {required List<ProjectManagementProcessUserRegistrationOverAll>
          employees}) {
    dataGridRows = employees
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(cells: [
            DataGridCell<dynamic>(
                columnName: 'name', value: dataGridRow.userName),
            DataGridCell<dynamic>(
                columnName: 'Employee code', value: dataGridRow.employeCode),
            DataGridCell<dynamic>(columnName: 'Type', value: dataGridRow.type),
            DataGridCell<dynamic>(
                columnName: 'DPI',
                value: dataGridRow.dpiTotal),
            DataGridCell<dynamic>(
                columnName: 'SPI',
                value: dataGridRow.spiTotal),
            DataGridCell<dynamic>(
                columnName: 'QPI',  value: dataGridRow.qpiTotal),
            DataGridCell<dynamic>(
                columnName: 'PRI',
                value: dataGridRow.priTotal!
                    ),

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
