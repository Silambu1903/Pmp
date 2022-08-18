import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmp/helper.dart';
import 'package:pmp/model/projectmanagmentprojectallassignedproject.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pmp/service/apiService.dart';
import 'package:pmp/widgets/shimmer/shimmerprojectlist.dart';
import '../../../model/projectmanagementdailyreport.dart';
import '../../../model/projectmanagementdetails.dart';
import '../../../model/projectmanagementprojectassgin.dart';
import '../../../model/projectmanagementprojectmanager.dart';
import '../../../provider/dailytaskprovider/daily_task_provider.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../responsive/responsive.dart';

class DailyTaskDepartmentHead extends ConsumerStatefulWidget {
  String? projectName, projectCode, projectId, status;

  DailyTaskDepartmentHead(
      {Key? key,
      this.projectName,
      this.projectCode,
      this.projectId,
      this.status})
      : super(key: key);

  @override
  _DailyTaskManagerState createState() => _DailyTaskManagerState();
}

class _DailyTaskManagerState extends ConsumerState<DailyTaskDepartmentHead> {
  num spentHourTotal = 0;
  TextEditingController taskName = TextEditingController();
  TextEditingController spentHours = TextEditingController();
  TextEditingController remarks = TextEditingController();

  @override
  void initState() {
    ref.refresh(dailyTaskListNotifier(widget.projectId!));
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

  mobileUi(BuildContext context) {
    return ref.watch(dailyTaskListNotifier(widget.projectId!)).when(
        data: (data) {
      spentHourTotal = 0;
      if (widget.status == 'Created') {
        if (data.isNotEmpty) {
          ref
              .read(projectCreationNotifierProvider.notifier)
              .getProjectStatus(widget.projectId, 'InProgress');
        }
      }
      for (var data in data) {
        spentHourTotal = spentHourTotal + data.spentHrs!;
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                automaticallyImplyLeading: false,
                expandedHeight: 190,
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
                                          color: AppColors.white,
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
                                        Text(widget.projectName!,
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
                                        Text(widget.projectCode!,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  /* Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            const Text('AssignHours : ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold)),
                                            Text(widget.data!.assignHr!.assignHrs!,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500))
                                          ],
                                        ),
                                      ),*/
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        const Text('Total Spent Hours : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(spentHourTotal.toString(),
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
              )
            ],
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              mobileDialog(context, '',);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.black,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }, error: (error, s) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Daily Task'),
          ),
          body: Center(child: Text(error.toString())),
          floatingActionButton: GestureDetector(
            onTap: () {
              mobileDialog(context, '');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.black,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }, loading: () {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Task'),
        ),
        body: ShimmerForProjectList(),
        floatingActionButton: GestureDetector(
          onTap: () {
            mobileDialog(context, '');
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.black,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    });
  }

  windowsUi(BuildContext context) {
    return ref.watch(dailyTaskListNotifier(widget.projectId!)).when(
        data: (data) {
      spentHourTotal = 0;
      if (widget.status == 'Created') {
        if (data.isNotEmpty) {
          ref
              .read(projectCreationNotifierProvider.notifier)
              .getProjectStatus(widget.projectId, 'InProgress');
        }
      }
      for (var data in data) {
        spentHourTotal = spentHourTotal + data.spentHrs!;
      }
      return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                            ScreenSize.screenWidth * 0.025,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 20),
                                  child: Row(
                                    children: [
                                      const Text('Project Name : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        widget.projectName!,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('Project Code : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(widget.projectCode!,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500)),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('Total Spent Hours : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text(spentHourTotal.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [],
                                  ),
                                ),
                                /* Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            const Text('AssignHours : ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold)),
                                            Text(widget.data!.assignHr!.assignHrs!,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500))
                                          ],
                                        ),
                                      ),*/
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [],
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
              Expanded(
                flex: 8,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: MasonryGridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: data.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return itemBuilder(data[index]);
                      }),
                ),
              )
            ],
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              mobileDialog(context, '');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.black,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }, error: (error, s) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Daily Task'),
          ),
          body: Center(child: Text(error.toString())),
          floatingActionButton: GestureDetector(
            onTap: () {
              mobileDialog(context, '');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.black,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }, loading: () {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Task'),
        ),
        body: ShimmerForProjectList(),
        floatingActionButton: GestureDetector(
          onTap: () {
            mobileDialog(context, '');
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.black,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    });
  }

  itemBuilder(ProjectManagementProcessDailyReport data) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
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
                      'Sub Task Details',
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
                          data.taskDetails,
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
                        'Remarks',
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
                          data.remarks,
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
                        data.createdDate.toString(),
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
                        'Spent Hours',
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
                        data.spentHrs!.toString() + ' hrs',
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
    );
  }

  mobileDialog(BuildContext context, userId,) {
    taskName = TextEditingController();
    spentHours = TextEditingController();
    remarks = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Task'),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: taskName,
                          decoration: const InputDecoration(
                            labelText: 'Task Name',
                            suffixIcon: Icon(
                              Icons.approval,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          controller: spentHours,
                          maxLength: 4,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'SpentHours',
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
                          controller: remarks,
                          textInputAction: TextInputAction.done,
                          maxLines: 3,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            isDense: true,
                            filled: true,
                            contentPadding:
                                EdgeInsets.only(bottom: 20, left: 10, top: 5),
                            labelText: 'Remarks',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            if (validateField()) {
                              ref.read(dailyTaskNotifier.notifier).dailyTask(
                                  ProjectManagementProcessDailyReport(
                                      userId: Helper.sharedCreatedId,
                                      teamId: null,
                                      departmentId: Helper.shareddepId,
                                      spentHrs: double.parse(spentHours.text),
                                      taskDetails: taskName.text.toString(),
                                      remarks: remarks.text.toString(),
                                      projectId: widget.projectId!),null);
                              ref.refresh(
                                  dailyTaskListNotifier(widget.projectId!));
                              ref.watch(
                                  dailyTaskListNotifier(widget.projectId!));
                              Navigator.pop(context);
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

  displayErrorMessages(String errormessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errormessage)));
  }

  bool validateField() {
    if (taskName.text.isEmpty) {
      displayErrorMessages('TaskName should not be empty');
      return false;
    } else if (spentHours.text.isEmpty) {
      displayErrorMessages('SpentHour should not be empty');
      return false;
    } else if (remarks.text.isEmpty) {
      displayErrorMessages('Remarks should not be empty');
      return false;
    }
    return true;
  }
}
