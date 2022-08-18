import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pmp/screen/director/task_assgin/task_assignn_team_lead.dart';
import '../../../helper.dart';
import '../../../model/task_details_model.dart';
import '../../../provider/task_details_provider/task_details_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/colors.dart';
import '../../../res/id.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmerprojectlist.dart';
import '../assgin/assign_project.dart';

class TaskCreationTeamLead extends ConsumerStatefulWidget {
  var projectId;
  var projectPlannedHrs;

  TaskCreationTeamLead({this.projectId, Key? key,this.projectPlannedHrs}) : super(key: key);

  @override
  ConsumerState<TaskCreationTeamLead> createState() =>
      _TaskCreationTeamLeadState();
}

class _TaskCreationTeamLeadState extends ConsumerState<TaskCreationTeamLead> {
  TextEditingController taskName = TextEditingController();
  TextEditingController plannedHours = TextEditingController();
  TextEditingController description = TextEditingController();
  double? totaltaskPlannedHrs;
  @override
  void initState() {
    ref.refresh(taskListNotifier(widget.projectId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Responsive.isDesktop(context)
        ? taskListWindows(context)
        : taskListMobile(context);
  }

  taskListWindows(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: SizedBox(
                height: ScreenSize.screenHeight * 0.05,
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    hintText: 'Search by Task Name',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 9,
              child: ref.watch(taskListNotifier(widget.projectId)).when(data: (data) {
                return MasonryGridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    controller: ScrollController(),
                    crossAxisSpacing: 4,
                    itemCount:data.projectManagementProcessTaskCreation!.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemTaskList(data.projectManagementProcessTaskCreation![index], data.totalPlannedHrs);
                    });
              }, error: (error, s) {
                return Center(
                  child: Text(error.toString()),
                );
              }, loading: () {
                return ShimmerForProjectList();
              }))
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          addTaskDialog(context, '');
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
    ));
  }

  taskListMobile(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: SizedBox(
                height: ScreenSize.screenHeight * 0.05,
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    hintText: 'Search by Task Name',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 9,
              child: ref.watch(taskListNotifier(widget.projectId)).when(data: (data) {
                return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    controller: ScrollController(),
                    crossAxisSpacing: 4,
                    itemCount: data.projectManagementProcessTaskCreation!.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemTaskList(data.projectManagementProcessTaskCreation![index], data.totalPlannedHrs);
                    });
              }, error: (error, s) {
                return Center(
                  child: Text(error.toString()),
                );
              }, loading: () {
                return ShimmerForProjectList();
              }))
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          addTaskDialog(context, '');
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
  }

  addTaskDialog(BuildContext context, userId) {
    taskName = TextEditingController();
    plannedHours = TextEditingController();
    description = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Consumer(builder: (context, ref, child) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      title:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Assign Task'),
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
                            controller: TextEditingController(text: widget.projectPlannedHrs.toString()),
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Total Project Planned Hours',
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
                            controller: plannedHours,
                            maxLength: 4,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Task planned Hours',
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
                            controller: description,
                            textInputAction: TextInputAction.done,
                            maxLines: 3,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              isDense: true,
                              filled: true,
                              contentPadding:
                                  EdgeInsets.only(bottom: 20, left: 10, top: 5),
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              if(validateField()) {
                                ref
                                    .read(taskCreationNotifierProvider.notifier)
                                    .createTaskProvider(
                                  TaskDetailsModel(
                                    taskName: taskName.text.toString(),
                                    taskDescription:
                                    description.text.toString(),
                                    teamId: Helper.sharedteamId,
                                    createdId: Helper.sharedCreatedId,
                                    projectId: widget.projectId,
                                    plannedHrs: double.parse(
                                        plannedHours.text.toString()),
                                  ),
                                );
                                Navigator.pop(context);
                                Future.delayed(
                                    const Duration(milliseconds: 1000),
                                        () {
                                      ref.refresh(
                                          taskListNotifier(widget.projectId));
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
                    );
                  }),
                ),
              ),
            ));
  }

  bool validateField() {
    totaltaskPlannedHrs = totaltaskPlannedHrs ?? 0.0;
    if (taskName.text.isEmpty) {
      displayErrorMessages('Enter the task name');
      return false;
    } else if (plannedHours.text.isEmpty) {
      displayErrorMessages('Enter the hours planned for this task');
      return false;
    } else if (double.parse(widget.projectPlannedHrs.toString()) < double.parse(plannedHours.text.toString())+totaltaskPlannedHrs!) {
      displayErrorMessages('Task planned hours exceeds from total project hours');
      return false;
    } else if (description.text.isEmpty) {
      displayErrorMessages('Enter the task description');
      return false;
    }
    return true;
  }

  displayErrorMessages(String errormessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errormessage)));
  }

  itemTaskList(TaskDetailsModel data, int totalTaskPlannedHrs) {
    try {
      totaltaskPlannedHrs = totalTaskPlannedHrs.toDouble();
    } on Exception catch (e){
      totaltaskPlannedHrs = 0.0;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(name: AppId.ASSGIN_PROJECT),
            builder: (context) => TaskAssignTeamLead(
              projectAssginId: widget.projectId,
              taskId: data.id,
              totalPlannedHrs: data.plannedHrs,
            ),
          ),
        );
      },
      child: Padding(
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
                            data.taskName!.toString(),
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
                          'Planned Hours',
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
                            data.plannedHrs!.toString(),
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
                          'description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
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
                            data.taskDescription!.toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 5,
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

}
