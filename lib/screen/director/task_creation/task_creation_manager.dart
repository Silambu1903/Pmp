import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../helper.dart';
import '../../../model/task_details_manager_model.dart';
import '../../../model/task_details_model.dart';
import '../../../provider/project_allocation_provider/project_allocation_provider.dart';
import '../../../provider/task_details_provider/task_details_provider.dart';
import '../../../res/ScreenSize.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../res/colors.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmerprojectlist.dart';

class TaskCreationManager extends ConsumerStatefulWidget {
  var projectId, projectAssignId;

  TaskCreationManager({this.projectId, this.projectAssignId});

  @override
  ConsumerState<TaskCreationManager> createState() =>
      _TaskCreationManagerState();
}

class _TaskCreationManagerState extends ConsumerState<TaskCreationManager> {
  TextEditingController taskName = TextEditingController();
  TextEditingController plannedHours = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    ref.refresh(taskListManagerNotifier(widget.projectId));
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
              child: ref.watch(taskListManagerNotifier(widget.projectId)).when(
                  data: (data) {
                return MasonryGridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    controller: ScrollController(),
                    crossAxisSpacing: 4,
                    itemCount: data.taskCreationManager!.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemTaskList(data.taskCreationManager![index]);
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
              child: ref.watch(taskListManagerNotifier(widget.projectId)).when(
                  data: (data) {
                return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    controller: ScrollController(),
                    crossAxisSpacing: 4,
                    itemCount: data.taskCreationManager!.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemTaskList(data.taskCreationManager![index]);
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
                      title: const Text('Task'),
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
                            controller: plannedHours,
                            maxLength: 4,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'planned Hours',
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

                                Future.delayed(
                                    const Duration(milliseconds: 1000),
                                        () {
                                          Navigator.pop(context);
                                      ref.refresh(taskListManagerNotifier(
                                          widget.projectId));
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
    if (taskName.text.isEmpty) {
      displayErrorMessages('Enter the task name');
      return false;
    } else if (plannedHours.text.isEmpty) {
      displayErrorMessages('Enter the hours planned for this task');
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

  itemTaskList(TaskDetailsManagerCreation data) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          Visibility(
            visible: data.taskAssigns!.isNotEmpty ? false : true,
            child: SlidableAction(
              onPressed: (context) {
                assigneeTeam(
                    widget.projectAssignId,
                    data.plannedHrs,
                    Helper.sharedCreatedId,
                    data.id);
                Future.delayed(const Duration(milliseconds: 1000),
                        () {
                      ref.refresh(taskListManagerNotifier(widget.projectId));
                    });
                /*assigneeWithHours(context, data.id, data.plannedHrs);*/
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
            visible: data.taskAssigns!.isNotEmpty ? true : false,
            child: SlidableAction(
              onPressed: (context) {
                reAssigneeWithHours(context, data.taskAssigns![0].id,
                    data.plannedHrs, data.taskAssigns![0].taskAssignHrs);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'ReAssign',
            ),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Assign Status',
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
                             data.taskAssigns!.isNotEmpty? "Assigned" : 'Not Assigned',
                              style:  TextStyle(
                                color: data.taskAssigns!.isNotEmpty? Colors.green : Colors.red,
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
      ),
    );
  }

  assigneeWithHours(BuildContext context, var taskId, var totalPlannedHrs) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
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
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: totalPlannedHrs.toString()),
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
                            assigneeTeam(
                                widget.projectAssignId,
                                double.parse(assignedHours.text.toString()),
                                Helper.sharedCreatedId,
                                taskId);
                            Future.delayed(const Duration(milliseconds: 1000),
                                    () {
                                  Navigator.pop(context);
                                  ref.refresh(taskListManagerNotifier(widget.projectId));
                                });
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

  reAssigneeWithHours(
      BuildContext context, taskId, totalPlanned, assigneeHours) {
    TextEditingController assignedHours = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: const Text('ReAssign Task '),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                              text: totalPlanned.toString()),
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
                          controller: TextEditingController(
                              text: assigneeHours.toString()),
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
                            /* if (assignedHours.text.isEmpty) {
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

                            Future.delayed(const Duration(milliseconds: 1000),
                                    () {
                                  Navigator.pop(context);
                                  ref.refresh(taskListManagerNotifier(widget.projectId));
                                });
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

  void assigneeTeam(assignId, hours, id, taskId) {
    ref
        .read(projectAssignNotifierProvider.notifier)
        .taskAssignee(assignId, taskId, hours, id);
  }

  void reAssigneeTeam(taskId, hours) {
    ref
        .read(projectAssignNotifierProvider.notifier)
        .taskUpdateAssignee(taskId, hours);
  }
}
