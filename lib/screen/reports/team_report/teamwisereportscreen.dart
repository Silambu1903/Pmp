import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pmp/model/project_management_process_team_creation.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/screen/reports/team_report/teamwisereportdetails.dart';

import '../../../helper.dart';
import '../../../model/projectmanagementprocessteamcreation.dart';
import '../../../provider/changenotifier/widget_notifier.dart';
import '../../../provider/project_allocation_provider/project_report_provider.dart';
import '../../../res/id.dart';
import '../../../responsive/responsive.dart';

class TeamWiseReportScreen extends ConsumerStatefulWidget {
  const TeamWiseReportScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TeamWiseReportScreen> createState() =>
      _TeamWiseReportScreenState();
}

class _TeamWiseReportScreenState extends ConsumerState<TeamWiseReportScreen> {
  String? type, dep, team;
  var depId, teamId;
  Map<dynamic, dynamic> splitTeam = {};
  Map<dynamic, dynamic> splitDepartment = {};
  List<ProjectManagementProcessTeamCreationReport> filter = [];
  bool itemChanged= false;


  @override
  void initState() {
    ref.refresh(getTeamWiseReportNotifier);
    super.initState();
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

  windowViewHomeScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: AppColors.bg,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          Text(
                            'TeamWise Summary',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.screenWidth * 0.015),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
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
                  ],
                ),
              ),
            ),
            ref.watch(getTeamWiseReportNotifier).when(data: (data) {
              if (itemChanged) {
              } else {
                filter = data;
              }
              return Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: filter.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemBuilder(filter[index]);
                    },
                  ),
                ),
              );
            }, error: (error, s) {
              return Container();
            }, loading: () {
              return Container();
            })
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
          body:   ref.watch(getTeamWiseReportNotifier).when(data: (data) {
            if (itemChanged) {
            } else {
              filter = data;
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: MasonryGridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: filter.length,
                itemBuilder: (BuildContext ctx, index) {
                  return itemBuilder(filter[index]);
                },
              ),
            );
          }, error: (error, s) {
            return Container();
          }, loading: () {
            return Container();
          }),
        ));
  }

  itemBuilder(ProjectManagementProcessTeamCreationReport data) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(name: AppId.TEAMWISE_REPORT_DETAILS),
            builder: (context) => TeamWiseReportDetails(data:data),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 30,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    data.teamName!.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.isDesktop(context)?
                        MediaQuery.of(context).size.width * 0.015 :MediaQuery.of(context).size.width * 0.05),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.style,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(data.dailyReports!.isNotEmpty
                          ? data.dailyReports![0].departmentCreation!.group
                              .toString()
                          : ''),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Team Members',
                        style: TextStyle(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Spent Hrs'),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            itemCount: data.dailyReports!.length >= 4
                                ? 4
                                : data.dailyReports!.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: 40.0,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(data
                                              .dailyReports![i]
                                              .userRegistration!
                                              .avatar!
                                              .toString()))),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(data.dailyReportsAggregate!.aggregate!
                                  .sum!.spentHrs!
                                  .toString() +
                              ' hrs'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  onItemChanged(String value) {
    if (value.isNotEmpty) {
      itemChanged = true;
      filter = filter
          .where((ProjectManagementProcessTeamCreationReport
      processProjectCreationDetails) =>
          processProjectCreationDetails.teamName!
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    } else {
      itemChanged = false;
    }
    ref.refresh(getTeamWiseReportNotifier);
  }
}
