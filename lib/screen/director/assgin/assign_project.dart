import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pmp/model/projectmanagementprojectassgin.dart';
import 'package:pmp/model/projectmanagmentprojectallassignedproject.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/screen/director/project/project_stepper_update.dart';
import '../../../helper.dart';
import '../../../model/login_model.dart';
import '../../../provider/created_user_provider/created_user_list_provider.dart';
import '../../../provider/project_allocation_provider/project_allocation_provider.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmeruserlist.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AssignProject extends ConsumerStatefulWidget {
  var projectId;
  String? totalPlannedHrs;
  var allocationId;
  int totalAssignedHrs = 0;
  List<String> teamHrsList = [];
  List<ProjectAssignId>? projectAssignIds;
  ProjectManagementProcessProjectAssignTeam? processProjectAssignTeam;
  List<String> ? filterData;
  AssignProject(
      {Key? key,
      this.processProjectAssignTeam,
      this.projectAssignIds,
      this.projectId,
      this.allocationId,
      this.totalPlannedHrs,this.filterData})
      : super(key: key);

  @override
  _AssignProjectState createState() => _AssignProjectState();
}

class _AssignProjectState extends ConsumerState<AssignProject> {
  @override
  void initState() {
    ref.refresh(userListStateProvider);
    ref.refresh(userListTeamStateProvider);
    ref.refresh(getProjectAssignedIndividualTeamFilterList(widget.projectId));
    ref.refresh(projectAssignNotifierProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    widget.teamHrsList = [];
    ref.watch(getProjectAssignedIndividualTeamFilterList(widget.projectId)).when(data: (data){
      widget.projectAssignIds =  data[0].projectCreation!.projectAssigns;
    }, error: (e,s){}, loading: (){});
    return ref.watch(userListStateProvider).when(data: (data) {
      final id = ref.watch(projectAssignNotifierProvider);

      if (id.allocationId.value.toString().isNotEmpty &&
          id.allocationId.value.toString().length > 10) {
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.refresh(userListTeamStateProvider);
          ref.refresh(getProjectAssignedIndividualTeamFilterList(widget.projectId));

        });
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            title: const Text('Assign Project'),
          ),
          body: Column(
            children: [
              Center(
                child: Visibility(
                    visible: data.isEmpty ? true : false,
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
                        itemCount: data.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return itemBuilderWindows(data[index]);
                        })
                    : Responsive.isMobile(context)
                        ? ListView.builder(
                            itemCount: data.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return itemBuilder(data[index]);
                            })
                        : MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            itemCount: data.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return itemBuilderWindows(data[index]);
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

  void assigneeTeam(userId) {
    ref.read(projectAssignNotifierProvider.notifier).allocationProjectByTeam(
        ProjectManagementProcessProjectAssign(
            userId: userId,
            projectId: widget.projectId,
            isActive: true,
            assignedHourBool: true,
            assignedId: Helper.sharedCreatedId));
  }

  void deAssignee(userId) {
    /*  ref.read(projectAssignNotifierProvider.notifier).allocationProject(
        ProjectManagementProcessProjectAssign(
            userId: userId,
            projectId: widget.projectId,
            isActive: false,
            assignedId: Helper.sharedCreatedId));*/
  }

  Widget itemBuilder(ProjectManagementProcessUserRegistration userListData) {
    String assign = 'Not Assigned';
    String assignedHrs = '';
    var assignedId;
    bool? visible = false;
    Map<dynamic, bool> tempMap = {};
    Map<dynamic, String> tempAssignMap = {};
    Map<dynamic, String> tempAssignIdMap = {};
    List<String> assignList = [];
    List<String> assignHrList = [];

    for (var element in widget.projectAssignIds!) {
      assignList.add(element.userId!);
      tempAssignIdMap[element.userId] = element.assignHr!.assignId ?? '';
      tempMap[element.userId] = element.assignedHrs!;
      tempAssignMap[element.userId] = element.assignHr!.assignHrs ?? '';
    }

    assignHrList.addAll(tempAssignMap.values);
    print(assignHrList.toString());
    for (int i = 0; i < assignList.length; i++) {
      if (assignList[i] == userListData.id) {
        widget.teamHrsList.add(assignHrList[i]);
      }
    }
    widget.totalAssignedHrs = 0;

    for (var i = 0; i < widget.teamHrsList.length; i++) {
      if (widget.teamHrsList[i] != null && widget.teamHrsList[i].isNotEmpty) {
        widget.totalAssignedHrs =
            widget.totalAssignedHrs + int.parse(widget.teamHrsList[i]);
      }
    }

    if (tempMap[userListData.id] != null) {
      if (tempMap[userListData.id] == true) {
        visible = false;
        assignedHrs = tempAssignMap[userListData.id]!;
        assignedId = tempAssignIdMap[userListData.id];
      } else {
        visible = true;
        assignedHrs = '0';
      }
    } else {
      visible = true;
    }
    if (assignList.contains(userListData.id)) {
      assign = 'Assigned';
    } else {
      assign = 'Not Assigned';
    }
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: visible,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                assigneeTeam(userId);
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
            visible: false,
            child: SlidableAction(
              onPressed: (context) {
                updateAssignHoursDialog(assignedId, assignedHrs,
                    widget.totalAssignedHrs.toString(), userListData.userName!);
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
                                  image: NetworkImage(userListData.avatar),
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
                                    userListData.userName!,
                                    style: TextStyle(
                                        color: userListData.isActive == true
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize: ScreenSize.screenWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    Helper.filterDepartment[
                                        userListData.departmentId],
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: ScreenSize.screenWidth * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    assign,
                                    style: TextStyle(
                                        color: assign == "Assigned"
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: ScreenSize.screenWidth * 0.02,
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
      ProjectManagementProcessUserRegistration userListData) {
    String assign = 'Not Assigned';
    String assignedHrs = '';
    var assignedId;
    bool? visible = false;
    Map<dynamic, bool> tempMap = {};
    Map<dynamic, String> tempAssignMap = {};
    Map<dynamic, String> tempAssignIdMap = {};
    List<String> assignList = [];
    List<String> assignHrList = [];

    for (var element in widget.projectAssignIds!) {
      assignList.add(element.userId!);
      tempAssignIdMap[element.userId] = element.assignHr!.assignId ?? '';
      tempMap[element.userId] = element.assignedHrs!;
      tempAssignMap[element.userId] = element.assignHr!.assignHrs ?? '';
    }




    if (tempMap[userListData.id] != null) {
      if (tempMap[userListData.id] == true) {
        visible = false;
        assignedHrs = tempAssignMap[userListData.id]!;
        assignedId = tempAssignIdMap[userListData.id];
      } else {
        visible = true;
        assignedHrs = '0';
      }
    } else {
      visible = true;
    }
    if (assignList.contains(userListData.id)) {
      assign = 'Assigned';
    } else {
      assign = 'Not Assigned';
    }
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: visible,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                assigneeTeam(userId);
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
            visible: false,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                deAssignee(userId);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'DeAssign',
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
                                  image: NetworkImage(userListData.avatar),
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
                                    userListData.userName!,
                                    style: TextStyle(
                                        color: userListData.isActive == true
                                            ? Colors.black
                                            : Colors.red,
                                        fontSize:
                                            ScreenSize.screenWidth * 0.012,
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
                                  Text(
                                    assign,
                                    style: TextStyle(
                                        color: assign == "Assigned"
                                            ? Colors.green
                                            : Colors.red,
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

  mobileDialog(BuildContext context, userId, String assigned, String name) {
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
                              text: widget.totalPlannedHrs),
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
                          controller: TextEditingController(text: assigned),
                          enabled: false,
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
                            } else {
                              int updateAssignHrs = int.parse(
                                      widget.totalAssignedHrs.toString()) +
                                  int.parse(assignedHours.text);
                              print("if" +
                                  widget.totalAssignedHrs.toString() +
                                  " = " +
                                  assignedHours.text +
                                  " = " +
                                  updateAssignHrs.toString() +
                                  " = " +
                                  widget.totalPlannedHrs!);
                              if (updateAssignHrs >
                                  int.parse(
                                      widget.totalPlannedHrs.toString())) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Enter Valid Hours. Total Planned Hour is :' +
                                            widget.totalPlannedHrs
                                                .toString())));
                              } else {
                                if (userId == Helper.sharedCreatedId) {
                                  ref
                                      .read(projectAssignNotifierProvider
                                          .notifier)
                                      .assignHours(widget.allocationId,
                                          assignedHours.text.toString());
                                } else {}
                              }
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

  updateAssignHoursDialog(userId, assignedHrs, String hours, String name) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: Text('Updated Assign hrs to' + name),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: hours),
                          decoration: const InputDecoration(
                            labelText: 'Total Assigned Hours',
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
                          controller: TextEditingController(text: assignedHrs),
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
                            } else {
                              int updateAssignHrs = int.parse(
                                      widget.totalAssignedHrs.toString()) +
                                  int.parse(assignedHours.text);
                              updateAssignHrs =
                                  updateAssignHrs - int.parse(assignedHrs);
                              print("if" +
                                  widget.totalAssignedHrs.toString() +
                                  " = " +
                                  assignedHours.text +
                                  " = " +
                                  updateAssignHrs.toString() +
                                  " = " +
                                  widget.totalPlannedHrs!);
                              if (updateAssignHrs >
                                  int.parse(
                                      widget.totalPlannedHrs.toString())) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Enter Valid Hours. Total Planned Hour is :' +
                                            widget.totalPlannedHrs
                                                .toString())));
                              } else {
                                ref
                                    .read(
                                        projectAssignNotifierProvider.notifier)
                                    .updateAssignHours(
                                        userId, assignedHours.text.toString());
                              }
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
