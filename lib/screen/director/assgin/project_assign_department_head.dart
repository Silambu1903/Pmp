import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pmp/model/projectmanagementprojectassgin.dart';
import 'package:pmp/res/colors.dart';
import '../../../helper.dart';
import '../../../model/login_model.dart';
import '../../../model/projectmanagementdetails.dart';
import '../../../provider/created_user_provider/created_user_list_provider.dart';
import '../../../provider/project_allocation_provider/project_allocation_provider.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmeruserlist.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AssignProjectDepartmentHead extends ConsumerStatefulWidget {
  var projectId;
  String? totalPlannedHrs;
  var allocationId;
  List<String> ? fliterData;

  List<ProjectAssignDetails>? projectAssigns;

  AssignProjectDepartmentHead(
      {Key? key,
      this.projectAssigns,
      this.projectId,
      this.allocationId,
      this.totalPlannedHrs, this.fliterData})
      : super(key: key);

  @override
  _AssignProjectState createState() => _AssignProjectState();
}

class _AssignProjectState extends ConsumerState<AssignProjectDepartmentHead> {
  @override
  void initState() {
    ref.refresh(userListStateProvider);
    ref.refresh(projectAssignNotifierProvider);
    ref.refresh(getProjectFilterIndividualDepartment(widget.projectId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    ref.watch(getProjectFilterIndividualDepartment(widget.projectId)).when(data: (data){
      widget.projectAssigns = data[0].projectAssigns;
    }, error: (e,s){}, loading: (){});
    return ref.watch(userListStateProvider).when(data: (data) {
      final id = ref.watch(projectAssignNotifierProvider);
      if (id.allocationId.value.toString().isNotEmpty &&
          id.allocationId.value.toString().length > 5) {
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.refresh(getProjectFilterIndividualDepartment(widget.projectId));
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

  void deAssignee(userId) {
    ref.read(projectAssignNotifierProvider.notifier).allocationProject(
        ProjectManagementProcessProjectAssign(
            userId: userId,
            projectId: widget.projectId,
            isActive: false,
            assignedId: Helper.sharedCreatedId));
  }

  Widget itemBuilder(ProjectManagementProcessUserRegistration userListData) {
    String assign = 'Not Assigned';
    List<String> assignList = [];
    for (var element in widget.projectAssigns!) {
      assignList.add(element.userId!);
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
            visible: assign == "Assigned" ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                assignee(userId);
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemBuilderWindows(ProjectManagementProcessUserRegistration userListData) {
    String assign = 'Not Assigned';
    List<String> assignList = [];
    for (var element in widget.projectAssigns!) {
      assignList.add(element.userId!);
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
            visible: assign == "Assigned" ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                var userId = userListData.id;
                assignee(userId);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_box,
              label: 'Assign',
            ),
          ),
        ],
      ),
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [

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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
