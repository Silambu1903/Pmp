import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/screen/comments/comments_screen.dart';
import 'package:pmp/screen/director/dailytask/daily_task_department_head.dart';
import 'package:pmp/screen/director/project/project_stepper_update.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../helper/applicationhelper.dart';
import '../../../model/projectmanagementdetails.dart';
import '../../../provider/changenotifier/widget_notifier.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/id.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmerprojectlist.dart';
import '../assgin/project_assign_department_head.dart';

class ProjectDetails extends ConsumerStatefulWidget {
  const ProjectDetails({Key? key}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends ConsumerState<ProjectDetails> {
  List<ProjectManagementProcessProjectCreationDetails> filter = [];
  bool itemChanged = false,
      isCheckedCompleted = false,
      isCheckedInProcess = false,
      isCheckedMoveTesting = false,
      isCheckedTestingCompleted = false,
      isCheckedOpen = false,
      isCheckedIsInactive = false;
  String selectedDate = '';
  String textDate = '';
  List<String> filterData = [];

  @override
  void initState() {
    itemChanged = false;
    filterData.add(selectedDate);
    filterData.add('InProgress');
    ref.refresh(getProjectFilterListDepartment(filterData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
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
                    hintText: 'Search by Project Name',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: Responsive.isDesktop(context)?1 :3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Responsive.isDesktop(context)
                    ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: IconButton(
                            onPressed: () async {
                              DateTime? date = DateTime(1900);
                              FocusScope.of(context).requestFocus(FocusNode());
                              date = await showMonthYearPicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2101));
                              if (date != null) {
                                selectedDate = ApplicationHelper().dateFormatter1(date);
                                textDate = ApplicationHelper().dateFormatter2(date);
                              }
                              filterData[0] = selectedDate;
                              ref.refresh(getProjectAssignedTeamFilterList(filterData));
                            },
                            icon: const Icon(
                              Icons.date_range_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5,right: 10),
                          child: Text(
                            textDate,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.01),
                          ),
                        ),
                        _buildChipCompleted('Completed', Colors.black, 0),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: _buildChipInProgress(
                              'InProgress', Colors.black, 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child:
                          _buildChipTesting('InTesting', Colors.black, 2),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: _buildChipTestingCompleted(
                              'Testing Completed', Colors.black, 2),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: _buildChipOpen('Open', Colors.black, 3),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 12.0, right: 15),
                          child: _buildChipMovedTesting(
                              'Moved Testing', Colors.black, 3),
                        ),
                      ],
                    ))
                    : Expanded(
                  child: Column(
                    children: [
                      /*   Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: IconButton(
                                    onPressed: () async {
                                      DateTime? date = DateTime(1900);
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      date = await showMonthYearPicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2101));
                                      if (date != null) {
                                        selectedDate = ApplicationHelper().dateFormatter1(date);
                                        textDate = ApplicationHelper().dateFormatter2(date);
                                      }
                                      filterData[0] = selectedDate;
                                      ref.refresh(getProjectAssignedTeamFilterList(filterData));
                                    },
                                    icon: const Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 10),
                                  child: Text(
                                    textDate,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.01),
                                  ),
                                ),
                              ],
                            ),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildChipCompleted(
                                'Completed', Colors.black, 0),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: _buildChipInProgress(
                                  'InProgress', Colors.black, 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child:
                              _buildChipOpen('Open', Colors.black, 3),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: _buildChipTesting(
                                  'InTest', Colors.black, 2),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: _buildChipTestingCompleted(
                                  'Test C', Colors.black, 2),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 15),
                              child: _buildChipMovedTesting(
                                  'Moved T', Colors.black, 3),
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
          ref.watch(getProjectFilterListDepartment(filterData)).when(data: (data) {
            if (itemChanged) {
            } else {
              filter = data;
            }
            return Expanded(
              flex: 9,
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Responsive.isDesktop(context)
                        ? MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            controller: ScrollController(),
                            crossAxisSpacing: 4,
                            itemCount: filter.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return itemBuilder(filter[index]);
                            })
                        : Responsive.isMobile(context)
                            ? ListView.builder(
                                itemCount: filter.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return itemBuilder(filter[index]);
                                })
                            : MasonryGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                                controller: ScrollController(),
                                crossAxisSpacing: 4,
                                itemCount: filter.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return itemBuilder(filter[index]);
                                }),
                  ),
                ],
              ),
            );
          }, error: (error, s) {
            return const Expanded(
              flex: 8,
              child: Center(child: Text('No Project Available')),
            );
          }, loading: () {
            return Expanded(
              flex: 9,
              child: ShimmerForProjectList(),
            );
          })
        ],
      ),
    );
  }

  itemBuilder(ProjectManagementProcessProjectCreationDetails data) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                assign(context, data.id, data.plannedHrs, data),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.add_box,
            label: 'Assign',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => dailyTask(data),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.access_time,
            label: 'DailyTask',
          ),
          data.status != 'Completed'
              ? SlidableAction(
                  onPressed: (context) => status(data),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  icon: Icons.done,
                  label: 'completed',
                )
              : Container(),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: SizedBox(
          child: Card(
            elevation: 10,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings:
                            RouteSettings(name: AppId.UPDATE_PROJECT_SCREEN),
                        builder: (context) => ProjectStepperUpdate(data: data),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 12.0, right: 12.0, bottom: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Project Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: data.isActive == true
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data.projectName!,
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
                                'Delivery Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                data.deliveryDate!,
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
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                            children: [
                              Flexible(
                                child: Text(
                                  data.description!,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.grey,
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
                                'status',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                            children: [
                              Flexible(
                                child: Text(
                                  data.status != null ? data.status! : '',
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Total Hour',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                            children: [
                              Flexible(
                                child: Text(
                                  data.plannedHrs! + 'hrs',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentScreen(
                                projectId: data.id,
                                projectName: data.projectName,
                                deliveryDate: data.deliveryDate,
                                projectCode: data.projectCode,
                                status: data.status,
                                totalHrs: data.plannedHrs,
                                des: data.description,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: ScreenSize.screenWidth,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0)),
                        color: Color(0XFFe3edfc),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'comments',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: SvgPicture.asset(
                                        'assets/comment.svg',
                                        width: 15,
                                        height: 15,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'view all   ' +
                                      data.projectComments!.length.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 8),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              data.projectComments!.isNotEmpty
                                                  ? data
                                                      .projectComments![0]
                                                      .userRegistration!
                                                      .userName!
                                                      .toString()
                                                  : '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              data.projectComments!.isNotEmpty
                                                  ? ' :  ' +
                                                      data.projectComments![0]
                                                          .comment!
                                                          .toString()
                                                  : 'No comments',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: SvgPicture.asset(
                                        'assets/heart.svg',
                                        width: 15,
                                        height: 15,
                                        color: Colors.pink,
                                      ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  assign(BuildContext context, String? id, String? plannedHrs,
      ProjectManagementProcessProjectCreationDetails data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: AppId.ASSGIN_PROJECT),
        builder: (context) => AssignProjectDepartmentHead(
          projectId: id,
          totalPlannedHrs: plannedHrs,
          projectAssigns: data.projectAssigns,
          fliterData : filterData
        ),
      ),
    );
  }

  void dailyTask(ProjectManagementProcessProjectCreationDetails data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: AppId.DAILY_TASK_DEPARTMENT),
        builder: (context) => DailyTaskDepartmentHead(
          projectCode: data.projectCode,
          projectId: data.id,
          projectName: data.projectName,

        ),
      ),
    );
  }

  void status(ProjectManagementProcessProjectCreationDetails data) {
    updateRating(context, data.id!);
  }

  void updateRating(BuildContext context, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Stack(
              children: const [
                Text('Are you sure to submit?'),
              ],
            ),
            actions: [
              Consumer(builder: (context, ref, child) {
                return ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'));
              }),
              ElevatedButton(
                  onPressed: () async {
                    ref
                        .read(projectCreationNotifierProvider.notifier)
                        .getProjectStatus(id, 'Completed');
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      ref.refresh(getProjectFilterListDepartment(filterData));
                    });
                  },
                  child: const Text('CONFIRM'))
            ],
          );
        });
  }

  onItemChanged(String value) {
    if (value.isNotEmpty) {
      itemChanged = true;
      filter = filter
          .where((ProjectManagementProcessProjectCreationDetails
                  processProjectCreationDetails) =>
              processProjectCreationDetails.projectName!
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    } else {
      itemChanged = false;
    }
    ref.refresh(getProjectFilterListDepartment(filterData));
  }

  Widget _buildChipCompleted(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
        isCheckedCompleted == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedCompleted,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('Completed');
          ref.refresh(getProjectFilterListDepartment(filterData));
          isCheckedCompleted = value;
          isCheckedInProcess = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipInProgress(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
        isCheckedInProcess == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedInProcess,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();

          isCheckedInProcess = value;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('InProgress');
          ref.refresh(getProjectFilterListDepartment(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipTesting(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
        isCheckedMoveTesting == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedMoveTesting,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = value;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('InTesting');
          ref.refresh(getProjectFilterListDepartment(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipTestingCompleted(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor: isCheckedTestingCompleted == true
            ? Colors.white
            : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedTestingCompleted,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = value;
          isCheckedOpen = false;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('CompletedTesting');
          ref.refresh(getProjectFilterListDepartment(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipOpen(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
        isCheckedOpen == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedOpen,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = value;
          isCheckedIsInactive = false;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('Open');
          ref.refresh(getProjectFilterListDepartment(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }

  Widget _buildChipMovedTesting(String label, Color textColor, int index) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(counterModelProvider);
      return ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.bg,
          child: Ink(
            child: Center(
              child: Text(
                label[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        label: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: TextStyle(
                color: textColor, fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor:
        isCheckedIsInactive == true ? Colors.white : AppColors.chipColor,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        selected: isCheckedIsInactive,
        onSelected: (bool value) {
          ref.read(counterModelProvider).press();
          isCheckedInProcess = false;
          isCheckedCompleted = false;
          isCheckedMoveTesting = false;
          isCheckedTestingCompleted = false;
          isCheckedOpen = false;
          isCheckedIsInactive = true;
          filterData.clear();
          filterData.add(selectedDate);
          filterData.add('MovedTesting');
          ref.refresh(getProjectFilterListDepartment(filterData));
        },
        padding: const EdgeInsets.all(5.0),
      );
    });
  }
}
