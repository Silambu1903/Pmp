import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:pmp/model/projectmanagementprocessteamcreation.dart';
import 'package:pmp/widgets/shimmer/shimmerprojectlist.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../helper.dart';
import '../../../model/login_model.dart';
import '../../../provider/created_user_provider/created_user_list_provider.dart';
import '../../../provider/project_allocation_provider/project_report_provider.dart';
import '../../../res/ScreenSize.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../res/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../responsive/responsive.dart';
import 'individual_member_report.dart';

class TeamLeadReportDetails extends ConsumerStatefulWidget {
  const TeamLeadReportDetails({Key? key}) : super(key: key);

  @override
  ConsumerState<TeamLeadReportDetails> createState() =>
      _TeamWiseReportDetailsState();
}

class _TeamWiseReportDetailsState extends ConsumerState<TeamLeadReportDetails> {
  late TeamReportListSource _teamReportListSource;
  List<DailyReport> teamSpent = [];

  @override
  void initState() {
    ref.refresh(getTeamLeadReportNotifier);
    ref.refresh(userFilterListTeamWiseStateProvider(Helper.sharedteamId));
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

  windowViewHomeScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  color: AppColors.bg,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
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
                                    'Team Summary',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.015),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0),
                                    child: Text(
                                      'April - 2022',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0),
                                    child: IconButton(
                                        onPressed: () {

                                        },
                                        icon: const Icon(
                                            Icons.date_range_outlined)),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Export as',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.0095),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            exportDataGridToExcel(teamSpent);
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: ref.watch(getTeamLeadReportNotifier).when(
                              data: (data) {
                                teamSpent.clear();
                                teamSpent = data[0].dailyReports!;
                                _teamReportListSource = TeamReportListSource(
                                    teamSpent: data[0].dailyReports!);
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  child: Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Row(
                                                      children: const [
                                                        Text(
                                                          'Team Spent Hrs  ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data[0]
                                                            .dailyReportsAggregate!
                                                            .aggregate!
                                                            .sum!
                                                            .spentHrs
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.grey,
                                                  height: 10,
                                                  thickness: 1.5,
                                                  indent: 5,
                                                  endIndent: 5,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: SfDataGridTheme(
                                              data: SfDataGridThemeData(),
                                              child: SfDataGrid(
                                                  allowSwiping: true,
                                                  swipeMaxOffset: 100.0,
                                                  columnWidthMode:
                                                      ColumnWidthMode.fill,
                                                  columnWidthCalculationRange:
                                                      ColumnWidthCalculationRange
                                                          .allRows,
                                                  source: _teamReportListSource,
                                                  columns: [
                                                    GridColumn(
                                                        columnName: 'Date',
                                                        label: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'Date',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))),
                                                    GridColumn(
                                                        columnName: 'User Name',
                                                        label: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'User Name',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))),
                                                    GridColumn(
                                                        columnName:
                                                            'Project Name',
                                                        label: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'Project Name',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))),
                                                    GridColumn(
                                                        columnName: 'Task Name',
                                                        label: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'Task Name',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))),
                                                    GridColumn(
                                                        columnName: 'Spent Hrs',
                                                        label: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'Spent Hrs',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))),
                                                  ]),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              error: (error, s) {
                                return Text(error.toString());
                              },
                              loading: () {
                                return ShimmerForProjectList();
                              },
                            ),
                          ),
                          ref
                              .watch(userFilterListTeamWiseStateProvider(
                                  Helper.sharedteamId))
                              .when(data: (data) {
                            return MasonryGridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 4,
                                itemCount: data.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return itemBuilderWindows(data[index]);
                                });
                          }, error: (error, stack) {
                            return Container();
                          }, loading: () {
                            return Container();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  mobileViewHomeScreen(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Team Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

  Widget itemBuilderWindows(
      ProjectManagementProcessUserRegistration userListData) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: SizedBox(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualReportDetails(
                        userListData.id,
                        userListData.userName,
                        userListData
                            .dailyReportsAggregate!.aggregate!.sum!.spentHrs!
                            .toString())));
          },
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(userListData.avatar),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userListData.userName!,
                                  style: TextStyle(
                                      color: userListData.isActive == true
                                          ? Colors.black
                                          : Colors.red,
                                      fontSize: ScreenSize.screenWidth * 0.012,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Helper.filterDepartment[
                                      userListData.departmentId],
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Total Spent',
                                    style: TextStyle(
                                        color: userListData.isActive == true
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.012,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  userListData.dailyReportsAggregate!.aggregate!
                                          .sum!.spentHrs
                                          .toString() +
                                      ' ' +
                                      'hrs',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> exportDataGridToExcel(List<DailyReport> teamSpent
     ) async {
    final xls.Workbook workbook = xls.Workbook();
    final xls.Worksheet worksheet = workbook.worksheets[0];
    final xls.Style style = workbook.styles.add('Style1');
    final xls.Style style1 = workbook.styles.add('Style2');
    style.hAlign = xls.HAlignType.center;
    style.bold = true;
    style1.hAlign = xls.HAlignType.center;
    style1.vAlign = xls.VAlignType.center;

    worksheet.getRangeByName('A1').setText('DATE');
    worksheet.getRangeByName('A1').cellStyle = style;
    worksheet.getRangeByName('B1').setText('USER NAME');
    worksheet.getRangeByName('B1').cellStyle = style;
    worksheet.getRangeByName('C1').setText('PROJECT NAME');
    worksheet.getRangeByName('C1').cellStyle = style;
    worksheet.getRangeByName('D1').setText('TASK NAME');
    worksheet.getRangeByName('D1').cellStyle = style;
    worksheet.getRangeByName('E1').setText('SPENT HRS');
    worksheet.getRangeByName('E1').cellStyle = style;

    worksheet.getRangeByName('A1').columnWidth = 40.82;
    worksheet.getRangeByName('B1').columnWidth = 30.82;
    worksheet.getRangeByName('C1').columnWidth = 30.82;
    worksheet.getRangeByName('D1').columnWidth = 60.82;
    worksheet.getRangeByName('E1').columnWidth = 20.82;

    for (int i = 0; i < teamSpent.length; i++) {
      worksheet
          .getRangeByName('A' + (i + 2).toString())
          .setText(teamSpent[i].createdDate);
      worksheet.getRangeByName('A' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('B' + (i + 2).toString())
          .setText(teamSpent[i].userRegistration!.userName);
      worksheet.getRangeByName('B' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('C' + (i + 2).toString())
          .setText(teamSpent[i].projectCreation!.projectName);
      worksheet.getRangeByName('C' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('D' + (i + 2).toString())
          .setText(teamSpent[i].taskDetails);
      worksheet.getRangeByName('D' + (i + 2).toString()).cellStyle = style1;
      worksheet
          .getRangeByName('E' + (i + 2).toString())
          .setNumber(teamSpent[i].spentHrs!);
      worksheet.getRangeByName('E' + (i + 2).toString()).cellStyle = style1;
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      String data = DateFormat("dd-MM-yyyy-HH-mm-ss").format(DateTime.now());
      final String fileName = '$path/TeamWiseReport-' + data + '.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}

class TeamReportListSource extends DataGridSource {
  TeamReportListSource({required List<DailyReport> teamSpent}) {
    dataGridRows = teamSpent
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(cells: [
            DataGridCell<dynamic>(
                columnName: 'Date', value: dataGridRow.createdDate.toString()),
            DataGridCell<dynamic>(
                columnName: 'User Name',
                value: dataGridRow.userRegistration!.userName.toString()),
            DataGridCell<dynamic>(
                columnName: 'Project Name',
                value: dataGridRow.projectCreation!.projectName.toString()),
            DataGridCell<dynamic>(
                columnName: 'Task Name',
                value: dataGridRow.taskDetails.toString()),
            DataGridCell<dynamic>(
                columnName: 'Spent Hrs',
                value: dataGridRow.spentHrs.toString()),
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
