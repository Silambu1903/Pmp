import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pmp/model/projectmanagementprojectassgin.dart';
import 'package:pmp/res/colors.dart';
import '../../../helper.dart';
import '../../../model/login_model.dart';
import '../../../model/projectmanagementprojectmanager.dart';
import '../../../model/projectmanagmentprojectallassignedproject.dart';
import '../../../provider/created_user_provider/created_user_list_provider.dart';
import '../../../provider/project_allocation_provider/project_allocation_provider.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmeruserlist.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class ProjectAssignManager extends ConsumerStatefulWidget {
  var projectId;
  String? totalPlannedHrs;
  var allocationId;
  List<ProjectAssignId>? projectAssignIds;
  ProjectManagementProcessProjectAssignManager? processProjectAssignManager;
  List<String> ? filterData;
  ProjectAssignManager(
      {Key? key,
      this.processProjectAssignManager,
      this.projectAssignIds,
      this.projectId,
      this.allocationId,
      this.totalPlannedHrs, this.filterData})
      : super(key: key);

  @override
  _ProjectAssignManagerState createState() => _ProjectAssignManagerState();
}

class _ProjectAssignManagerState extends ConsumerState<ProjectAssignManager> {
  @override
  void initState() {
    ref.refresh(userListStateProvider);
    ref.refresh(getProjectIndividualAssignedManagerList(widget.projectId));
    ref.refresh(projectAssignNotifierProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    ref.watch(getProjectIndividualAssignedManagerList(widget.projectId)).when(data: (data){
      widget.projectAssignIds =  data[0].projectCreation!.projectAssigns;
    }, error: (e,s){}, loading: (){});
    return ref.watch(userListStateProvider).when(data: (data) {
      final id = ref.watch(projectAssignNotifierProvider);
      if (id.allocationId.value.toString().isNotEmpty &&
          id.allocationId.value.toString().length > 5) {
        Future.delayed(const Duration(milliseconds: 700), () {
          ref.refresh(getProjectIndividualAssignedManagerList(widget.projectId));
        });
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            title: const Text('Assign'),
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

  void assignee(userId) {
    ref.read(projectAssignNotifierProvider.notifier).allocationProject(
        ProjectManagementProcessProjectAssign(
            userId: userId,
            projectId: widget.projectId,
            isActive: true,
            assignedHourBool: false,
            assignedId: Helper.sharedCreatedId));
  }

  void assigneeTeam(userId, String assignHrs) {
    ref.read(projectAssignNotifierProvider.notifier).allocationProjectByTeam(
        ProjectManagementProcessProjectAssign(
            userId: userId,
            projectId: widget.projectId,
            isActive: true,
            assignedHours: assignHrs,
            assignedHourBool: true,
            assignedId: Helper.sharedCreatedId));
  }



  void deAssignee(userId) {
    ref.read(projectAssignNotifierProvider.notifier).allocationProject(
        ProjectManagementProcessProjectAssign(
            userId: userId,
            projectId: widget.projectId,
            isActive: false,
            assignedId: Helper.sharedCreatedId));
  }

  Widget itemBuilder(ProjectManagementProcessUserRegistration userListData) {
    String assign = 'Not Assigned', assignedHrs = '';
    var assignedId;
    List<String> assignList = [];
    bool? visible = false;
    Map<dynamic, bool> tempMap = {};
    Map<dynamic, String> tempAssignMap = {};
    Map<dynamic, String> tempAssignIdMap = {};
    for (var element in widget.projectAssignIds!) {
      assignList.add(element.userId!);
      tempAssignIdMap[element.userId] = element.assignHr!.assignId ?? '';
      tempMap[element.userId] = element.assignedHrs!;

    }

    if (tempMap[userListData.id] != null) {
      if (tempMap[userListData.id] == true) {
        visible = false;

      } else {
        visible = true;
        assignedHrs = '0 ' 'hrs';
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
            visible: Helper.sharedCreatedId ==  userListData.id ? visible : assign == 'Assigned' ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                if (userId == Helper.sharedCreatedId) {
                  //mobileDialog(context, userId);
                } else {
                  assignee(userId);
                }
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_box,
              label: 'Assign',
            ),
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: Helper.sharedCreatedId == userListData.id
                ? !visible
                : false,
            child: SlidableAction(
              onPressed: (context) {
                updateAssignHoursDialog(assignedId, assignedHrs);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: Helper.sharedCreatedId == userListData.id
                                ? true
                                : false,
                            child: Text(
                              assignedHrs,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
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

  Widget itemBuilderWindows(ProjectManagementProcessUserRegistration userListData) {
    String assign = 'Not Assigned', assignedHrs = '';
    var assignedId;
    List<String> assignList = [];
    bool? visible = false;
    Map<dynamic, bool> tempMap = {};
    Map<dynamic, String> tempAssignMap = {};
    Map<dynamic, String> tempAssignIdMap = {};
    for (var element in widget.projectAssignIds!) {
      assignList.add(element.userId!);
      tempAssignIdMap[element.userId] = element.assignHr!.assignId ?? '';
      tempMap[element.userId] = element.assignedHrs!;
      tempAssignMap[element.userId] = element.assignHr!.assignHrs ?? '';
    }

    if (tempMap[userListData.id] != null) {
      if (tempMap[userListData.id] == true) {
        visible = false;
        assignedHrs = tempAssignMap[userListData.id]! + '' + ' hrs';
        assignedId = tempAssignIdMap[userListData.id];
      } else {
        visible = true;
        assignedHrs = '0 ' 'hrs';
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
            visible: Helper.sharedCreatedId ==  userListData.id ? visible : assign == 'Assigned' ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                if (userId == Helper.sharedCreatedId) {
                  mobileDialog(context, userId);
                } else {
                  assignee(userId);
                }
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_box,
              label: 'Assign',
            ),
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: Helper.sharedCreatedId == userListData.id
                ? !visible
                : false,
            child: SlidableAction(
              onPressed: (context) {
                updateAssignHoursDialog(assignedId, assignedHrs);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: Helper.sharedCreatedId == userListData.id
                                ? true
                                : false,
                            child: Text(
                              assignedHrs,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
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

  mobileDialog(BuildContext context, userId) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: const Text('Assign'),
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
                          controller: assignedHours,
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
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if(assignedHours.text.toString().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Enter Hours')));
                            } else {
                              ref
                                  .read(projectAssignNotifierProvider.notifier)
                                  .assignHours(widget.allocationId,
                                  assignedHours.text.toString());
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

  updateAssignHoursDialog(userId, assignedHrs) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: const Text('Updated Assign hrs'),
                    actions: <Widget>[
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
                                  if(assignedHours.text.toString().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                  content: Text('Enter Hours')));
                                  } else {
                                    ref
                                        .read(projectAssignNotifierProvider.notifier)
                                        .updateAssignHours(
                                        userId, assignedHours.text.toString());
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
