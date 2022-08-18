import 'dart:collection';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/projectmanagementprojectmanager.dart';
import 'package:pmp/model/projectmanagmentprojectallassignedproject.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../model/project_management_project_creation.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/colors.dart';
import '../../../res/id.dart';
import '../../../responsive/responsive.dart';
import '../../../widgets/shimmer/shimmerprojectlist.dart';
import '../../comments/comments_screen.dart';
import '../assgin/assign_project.dart';

class ProjectDetailsSuperAdmin extends ConsumerStatefulWidget {
  const ProjectDetailsSuperAdmin({Key? key}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends ConsumerState<ProjectDetailsSuperAdmin> {
  List<ProjectManagementProcessProjectCreation> filter = [];
  bool itemChanged = false;

  @override
  void initState() {
    ref.refresh(getAllProjectList);
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
          ref.watch(getAllProjectList).when(data: (data) {
            if (itemChanged) {
            } else {
              filter = data;
            }
            return Expanded(
              flex: 9,
              child: Responsive.isDesktop(context)
                  ? MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      controller: ScrollController(),
                      crossAxisSpacing: 4,
                      itemCount: filter.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return itemBuilder(filter[index], index);
                      })
                  : Responsive.isMobile(context)
                      ? ListView.builder(
                          itemCount: filter.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return itemBuilder(filter[index], index);
                          })
                      : MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          controller: ScrollController(),
                          crossAxisSpacing: 4,
                          itemCount: filter.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return itemBuilder(filter[index], index);
                          }),
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

  itemBuilder(ProjectManagementProcessProjectCreation data, int index) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [],
      ),
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [],
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
                    allocationTeamList(context, data.allocationProjects!);
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
                                data.projectName!.toString(),
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
                                data.deliveryDate.toString(),
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
                                  data.description!.toString(),
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
                                  data.status.toString(),
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
                              Text(
                                data.plannedHrs! + 'hrs',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  allocationTeamList(
      BuildContext context, List<AllocationProjectManager> data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SingleChildScrollView(
                  child: AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: const Text('Allocated Team'),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Team Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              'Allocated Hrs',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return itemBuilderAllocationTeamList(data[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  itemBuilderAllocationTeamList(AllocationProjectManager data) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.teamCreation!.teamName!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Text(
                data.plannedHrs! + '' + ' hrs',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }

  onItemChanged(String value) {
    if (value.isNotEmpty) {
      itemChanged = true;
      filter = filter
          .where((ProjectManagementProcessProjectCreation
                  processProjectCreationDetails) =>
              processProjectCreationDetails.projectName!
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    } else {
      itemChanged = false;
    }
    ref.refresh(getAllProjectList);
  }
}

void doNothing(BuildContext context) {}
