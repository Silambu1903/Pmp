import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pmp/model/task_assign_list.dart';
import 'package:pmp/widgets/shimmer/shimmerprojectlist.dart';

import '../../../model/projectmanagmentprojectallassignedproject.dart';
import '../../../provider/task_details_provider/task_details_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../res/id.dart';
import '../../../responsive/responsive.dart';
import '../dailytask/daily_task.dart';

class TaskAssignUserListScreen extends ConsumerStatefulWidget {
  ProjectManagementProcessProjectAssignTeam? data;

  TaskAssignUserListScreen({Key? key, this.data}) : super(key: key);

  @override
  ConsumerState<TaskAssignUserListScreen> createState() =>
      _TaskAssignUserListState();
}

class _TaskAssignUserListState extends ConsumerState<TaskAssignUserListScreen> {
  @override
  void initState() {
    ref.refresh(taskAssignUserNotifier(widget.data!.projectId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? windowsUi(context)
        : Responsive.isMobile(context)
            ? mobileUi(context)
            : windowsUi(context);
  }

  windowsUi(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: ref
                .watch(taskAssignUserNotifier(widget.data!.projectId!))
                .when(data: (data) {
              double totalTaskHour = 0;
              for (var value in data) {
                totalTaskHour = totalTaskHour + value.taskAssignHrs!;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                            )),
                                        Text('Project Information',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.02,
                                                color: AppColors.bg,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              const Text('Project Name : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  widget.data!.projectCreation!
                                                      .projectName!,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              const Text('Project Code : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  widget.data!.projectCreation!
                                                      .projectCode!,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            children: [
                                              const Text('Project Status : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  widget.data!.projectCreation!
                                                      .status!,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            children: [
                                              const Text('Number of Task : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(data.length.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Row(
                                            children: [
                                              const Text('Total Task Hours : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  totalTaskHour.toString() +
                                                      ' hrs',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500))
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 10,
                      child: MasonryGridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          itemCount: data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return itemBuilder(data[index]);
                          }))
                ],
              );
            }, error: (error, s) {
              return Center(
                child: Text(error.toString()),
              );
            }, loading: () {
              return ShimmerForProjectList();
            })));
  }

  itemBuilder(TaskAssignToUserList data) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: AppId.DAILY_TASK),
              builder: (context) => DailyTask(
                data: widget.data,
                taskIdList: data,
              ),
            ),
          );
        },
        child: SizedBox(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12.0, left: 12.0, right: 12.0, bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'TaskName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.taskCreation!.taskName!.toString(),
                            maxLines: 5,
                            style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Task Description',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.taskCreation!.taskDescription!.toString(),
                            maxLines: 5,
                            style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          data.date.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Planned Hours',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          data.taskAssignHrs!.toString() + ' hrs',
                          style: const TextStyle(
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  mobileUi(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.cream,
          body: ref.watch(taskAssignUserNotifier(widget.data!.projectId!)).when(
              data: (data) {
            double totalTaskHour = 0;
            for (var value in data) {
              totalTaskHour = totalTaskHour + value.taskAssignHrs!;
            }
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  snap: false,
                  automaticallyImplyLeading: true,
                  expandedHeight: 220,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Project Information',
                                        style: TextStyle(
                                            fontSize:
                                                ScreenSize.screenWidth * 0.045,
                                            color: AppColors.bg,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          const Text('Project Name : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              widget.data!.projectCreation!
                                                  .projectName!,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          const Text('Project Code : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              widget.data!.projectCreation!
                                                  .projectCode!,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          const Text('Project Status : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              widget.data!.projectCreation!
                                                  .status!,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          const Text('Number of Task : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(data.length.toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          const Text('Total Task Hours : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              totalTaskHour.toString() + ' hrs',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ListView.builder(
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return itemBuilder(data[index]);
                      },
                    ),
                  ]),
                ),
              ],
            );
          }, error: (error, s) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return ShimmerForProjectList();
          })),
    );
  }
}
