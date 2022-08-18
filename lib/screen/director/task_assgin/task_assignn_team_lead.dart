import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pmp/res/colors.dart';

import '../../../helper.dart';
import '../../../model/project_assign_user.dart';
import '../../../provider/project_allocation_provider/project_allocation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmeruserlist.dart';

class TaskAssignTeamLead extends ConsumerStatefulWidget {
  var projectAssginId;
  var taskId;
  var totalPlannedHrs;

  TaskAssignTeamLead(
      {Key? key, this.taskId, this.projectAssginId, this.totalPlannedHrs})
      : super(key: key);

  @override
  _TaskAssignTeamLeadState createState() => _TaskAssignTeamLeadState();
}

class _TaskAssignTeamLeadState extends ConsumerState<TaskAssignTeamLead> {
  List<String> addValue = [];
  List<TaskAssign>? dummyTaskAssign = [];
  int totalTaskHrs = 0;

  @override
  void initState() {
    addValue.add(widget.projectAssginId);
    addValue.add(widget.taskId);
    ref.refresh(projectAssigneeUserNotifier(addValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    totalTaskHrs = 0;
    return ref.watch(projectAssigneeUserNotifier(addValue)).when(data: (data) {
      final id = ref.watch(projectAssignNotifierProvider);
      if (id.allocationId.value.toString().isNotEmpty &&
          id.allocationId.value.toString().length > 10) {
        Future.delayed(const Duration(milliseconds: 500), () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Assigned Successfully'),
          ));
          ref.refresh(projectAssignNotifierProvider);
        });
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            title: const Text('Task Assign '),
          ),
          body: Column(
            children: [
              Center(
                child: Visibility(
                    visible: data.processProjectAssignUserList!.isEmpty
                        ? true
                        : false,
                    child: const Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              Expanded(
                flex: 7,
                child: Responsive.isDesktop(context)
                    ? MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemCount: data.processProjectAssignUserList!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return itemBuilderWindows(
                              data.processProjectAssignUserList![index],
                              data.taskAssign!,
                              index,
                              data);
                        })
                    : Responsive.isMobile(context)
                        ? ListView.builder(
                            itemCount:
                                data.processProjectAssignUserList!.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return itemBuilder(
                                  data.processProjectAssignUserList![index],
                                  data.taskAssign!,
                                  index,
                                  data);
                            })
                        : MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            itemCount:
                                data.processProjectAssignUserList!.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return itemBuilderWindows(
                                  data.processProjectAssignUserList![index],
                                  data.taskAssign!,
                                  index,
                                  data);
                            }),
              )
            ],
          ),
        ),
      );
    }, error: (e, s) {
      return const Center(
        child: Text('Try Again'),
      );
    }, loading: () {
      return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.cream,
              appBar: AppBar(
                title: const Text('Assign'),
              ),
              body: ShimmerForUserList()));
    });
  }

  void assigneeTeam(assignId, hours, id) {
    ref
        .read(projectAssignNotifierProvider.notifier)
        .taskAssignee(assignId, widget.taskId, hours, id);
  }

  void reAssigneeTeam(taskId, hours) {
    ref
        .read(projectAssignNotifierProvider.notifier)
        .taskUpdateAssignee(taskId, hours);
  }

  void deAssignee(userId) {}

  Widget itemBuilder(ProjectManagementProcessProjectAssignUserList userListData,
      List<TaskAssign> taskAssign, int index, TaskAssignUserList data) {
    Map<String, dynamic> tempMap = {};
    Map<String, dynamic> tempTaskId = {};
    int hours = 0;
    String taskAssignId = '';
    String assigned = 'Not Assigned';
    for (var value in taskAssign) {
      tempMap[value.userRegistration!.id] = value.taskAssignHrs;
      tempTaskId[value.userRegistration!.id] = value.id;
    }
    if (tempMap[userListData.userRegistration!.id] != null) {
      hours = tempMap[userListData.userRegistration!.id];
      totalTaskHrs = totalTaskHrs + hours;
      assigned = 'Assigned';
    }
    if (tempTaskId[userListData.userRegistration!.id] != null) {
      taskAssignId = tempTaskId[userListData.userRegistration!.id];
    }
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: assigned == 'Assigned' ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                assigneeWithHours(
                    context,
                    userListData.id,
                    userListData.userRegistration!.userName!,
                    userListData.userRegistration!.id);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_box,
              label: 'Assign',
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: assigned == 'Not Assigned' ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                reAssigneeWithHours(
                    context,
                    userListData.id,
                    userListData.userRegistration!.userName!,
                    userListData.userRegistration!.id,
                    hours,
                    taskAssignId);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'ReAssign',
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: SizedBox(
          child: InkWell(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 12.0, right: 12.0, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      userListData.userRegistration!.avatar),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userListData.userRegistration!.userName!,
                                    style: TextStyle(
                                        color: userListData.userRegistration!
                                                    .isActive ==
                                                true
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize: ScreenSize.screenWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    Helper.filterDepartment[userListData
                                        .userRegistration!.departmentId],
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.025,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    assigned,
                                    style: TextStyle(
                                        color: assigned.toString() ==
                                                'Not Assigned'
                                            ? Colors.red
                                            : Colors.green,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.025,
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
      ),
    );
  }

  Widget itemBuilderWindows(
      ProjectManagementProcessProjectAssignUserList userListData,
      List<TaskAssign> taskAssign,
      int index,
      TaskAssignUserList data) {
    Map<String, dynamic> tempMap = {};
    Map<String, dynamic> tempTaskId = {};
    int hours = 0;
    String taskAssignId = '';
    String assigned = 'Not Assigned';
    for (var value in taskAssign) {
      tempMap[value.userRegistration!.id] = value.taskAssignHrs;
      tempTaskId[value.userRegistration!.id] = value.id;
    }
    if (tempMap[userListData.userRegistration!.id] != null) {
      hours = tempMap[userListData.userRegistration!.id];
      totalTaskHrs = totalTaskHrs + hours;
      assigned = 'Assigned';
    }
    if (tempTaskId[userListData.userRegistration!.id] != null) {
      taskAssignId = tempTaskId[userListData.userRegistration!.id];
    }

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: assigned == 'Assigned' ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                assigneeWithHours(
                  context,
                  userListData.id,
                  userListData.userRegistration!.userName!,
                  userListData.userRegistration!.id,
                );
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_box,
              label: 'Assign',
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: assigned == 'Not Assigned' ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                reAssigneeWithHours(
                    context,
                    userListData.id,
                    userListData.userRegistration!.userName!,
                    userListData.userRegistration!.id,
                    hours,
                    taskAssignId);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'ReAssign',
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: SizedBox(
          child: InkWell(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 12.0, right: 12.0, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(userListData
                                      .userRegistration!.avatar
                                      .toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userListData.userRegistration!.userName!,
                                    style: TextStyle(
                                        color: userListData.userRegistration!
                                                    .isActive ==
                                                true
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.012,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    Helper.filterDepartment[userListData
                                        .userRegistration!.departmentId],
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: ScreenSize.screenWidth * 0.01,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    assigned,
                                    style: TextStyle(
                                        color: assigned.toString() ==
                                                'Not Assigned'
                                            ? Colors.red
                                            : Colors.green,
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
      ),
    );
  }

  assigneeWithHours(BuildContext context, var assignedId, String name, var id) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: Text('Assign to ' + name),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: widget.totalPlannedHrs.toString()),
                          decoration: const InputDecoration(
                            labelText: 'Total Hours',
                            suffixIcon: Icon(
                              Icons.timer,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: assignedHours,
                          decoration: const InputDecoration(
                            labelText: 'Hours',
                            suffixIcon: Icon(
                              Icons.timer,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (assignedHours.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter Hours')));
                            } else if (double.parse(
                                    widget.totalPlannedHrs.toString()) <
                                (totalTaskHrs.toDouble() +
                                        double.parse(
                                            assignedHours.text.toString()))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Hours exceeds')));
                            } else {
                              /*  if (assignedHours.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter Hours')));
                            } else {
                              int updateAssignHrs = widget.totalPlannedHrs +
                                  int.parse(assignedHours.text);
                              if (updateAssignHrs >
                                  int.parse(
                                      widget.totalPlannedHrs.toString())) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Enter Valid Hours. Total Planned Hour is :' +
                                            widget.totalPlannedHrs
                                                .toString())));
                              } else {
                                assigneeTeam(
                                    assignedId,
                                    double.parse(assignedHours.text.toString()),
                                    id);
                              }
                            }*/
                              //totalTaskHrs = 0;
                              assigneeTeam(
                                  assignedId,
                                  double.parse(assignedHours.text.toString()),
                                  id);
                              Navigator.pop(context);
                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                ref.refresh(
                                    projectAssigneeUserNotifier(addValue));
                              });
                            }
                          },
                          child: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(ScreenSize
                                    .screenHeight *
                                0.07), // fromHeight use double.infinity as width and 40 is the height
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  reAssigneeWithHours(BuildContext context, var assignedId, String name, var id,
      int hour, var taskId) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: Text('Assign to ' + name),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: widget.totalPlannedHrs.toString()),
                          decoration: const InputDecoration(
                            labelText: 'Total Hours',
                            suffixIcon: Icon(
                              Icons.timer,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller:
                              TextEditingController(text: hour.toString()),
                          decoration: const InputDecoration(
                            labelText: 'Assigned Hours',
                            suffixIcon: Icon(
                              Icons.timer,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: assignedHours,
                          decoration: const InputDecoration(
                            labelText: 'Hours',
                            suffixIcon: Icon(
                              Icons.timer,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (assignedHours.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter Hours')));
                            } else if (double.parse(
                                    widget.totalPlannedHrs.toString()) <
                                (totalTaskHrs.toDouble() +
                                        double.parse(
                                            assignedHours.text.toString())) -
                                    hour.toDouble()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Hours exceeds')));
                            } else {
                              /*  if (assignedHours.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Enter Hours')));
                            } else {
                              int updateAssignHrs = widget.totalPlannedHrs +
                                  int.parse(assignedHours.text);
                              if (updateAssignHrs >
                                  int.parse(
                                      widget.totalPlannedHrs.toString())) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Enter Valid Hours. Total Planned Hour is :' +
                                            widget.totalPlannedHrs
                                                .toString())));
                              } else {
                                assigneeTeam(
                                    assignedId,
                                    double.parse(assignedHours.text.toString()),
                                    id);
                              }
                            }*/

                              reAssigneeTeam(
                                taskId,
                                double.parse(assignedHours.text.toString()),
                              );
                              Future.delayed(const Duration(milliseconds: 800),
                                  () {
                                ref.refresh(
                                    projectAssigneeUserNotifier(addValue));
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(ScreenSize
                                    .screenHeight *
                                0.07), // fromHeight use double.infinity as width and 40 is the height
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
