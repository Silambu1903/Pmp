import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/projectmanagementprocessallocationproject.dart';
import 'package:pmp/provider/project_creation_provider/project_creation_provider.dart';
import 'package:pmp/screen/director/project/project_stepper.dart';
import 'package:pmp/service/apiService.dart';

import '../../../helper.dart';
import '../../../provider/changenotifier/counternotifier.dart';
import '../../../provider/changenotifier/widget_notifier.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/colors.dart';

class ProjectAllocation extends ConsumerStatefulWidget {
  var projectId;
  var totalplannedhrs;

  ProjectAllocation(this.projectId, this.totalplannedhrs);

  @override
  _ProjectAllocationState createState() => _ProjectAllocationState();
}

class _ProjectAllocationState extends ConsumerState<ProjectAllocation> {
  Map<dynamic, dynamic> splitTeam = {};

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Consumer(builder: (context, ref, child) {
      ProjectStepper.allocationList = ref.watch(addTeamNotifier);
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 35,
                child: MaterialButton(
                  color: Colors.black,
                  onPressed: () {
                    List<ProjectManagementProcessAllocationProject> tempList =
                        [];
                    tempList = ProjectStepper.allocationList;
                    ref.refresh(addTeamNotifier);
                    tempList.add(ProjectManagementProcessAllocationProject(
                        isActive: true));
                    ref.read(addTeamNotifier.notifier).incrementValue(tempList);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Create Team",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Consumer(builder: (context, ref, child) {
            List<ProjectManagementProcessAllocationProject> data =
                ref.watch(addTeamNotifier);
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    addAllocationTeam(index, data[index]));
          }),
          Consumer(builder: (context, ref, child) {
            List<ProjectManagementProcessAllocationProject> data =
                ref.watch(addTeamNotifier);
            return Visibility(
              visible: data.isEmpty ? false : true,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    int calculatePlannedHrs = 0;
                    for (ProjectManagementProcessAllocationProject data
                        in ProjectStepper.allocationList) {
                      if (data.teamName.toString() == 'null' ||
                          data.teamName.toString().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Select the Team Name")));
                        return;
                      } else if (data.plannedHrs.toString() == 'null' ||
                          data.plannedHrs.toString().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Enter " +
                                data.teamName.toString() +
                                " Team Planned Hrs")));
                        return;
                      }
                      int? plannedHrs = int.tryParse(data.plannedHrs ?? "");
                      calculatePlannedHrs = calculatePlannedHrs + plannedHrs!;
                      print(calculatePlannedHrs);
                    }
                    if (int.tryParse(widget.totalplannedhrs ?? "")! <
                        calculatePlannedHrs) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Team planned hours more than total planned hours")));
                      return;
                    }
                    for (ProjectManagementProcessAllocationProject data
                        in ProjectStepper.allocationList) {
                      ref
                          .read(projectAllocationNotifierProvider.notifier)
                          .getAllocationTeam(data);
                    }
                    ref.refresh(getProjectListDepartment);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Project Added Successfully")));
                    ProjectStepper.allocationList.clear();
                  },
                  child: const Text('SAVE'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                        0.07), // fromHeight use double.infinity as width and 40 is the height
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  addAllocationTeam(int index, ProjectManagementProcessAllocationProject data) {
    String? team, splitData = '';
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.remove_circle),
                    label: const Text('Remove'),
                    onPressed: () {
                      List<ProjectManagementProcessAllocationProject> tempList =
                          [];
                      tempList = ProjectStepper.allocationList;
                      ref.refresh(addTeamNotifier);
                      tempList.removeAt(index);
                      ref
                          .read(addTeamNotifier.notifier)
                          .incrementValue(tempList);
                    },
                  ),
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'IsActive',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Consumer(builder: (context, ref, child) {
                      ref.watch(counterModelProvider);
                      return Checkbox(
                        checkColor: AppColors.primary,
                        activeColor: Colors.black,
                        value: ProjectStepper.allocationList[index].isActive,
                        onChanged: (value) {
                          ProjectStepper.allocationList[index]
                              .setIsActive(value!);
                          ref.read(counterModelProvider.notifier).press();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          Consumer(builder: (context, ref, child) {
            ref.watch(counterModelProvider);
            return Container(
              width: ScreenSize.screenWidth,
              height: MediaQuery.of(context).size.height * 0.09,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    iconSize: 24,
                    elevation: 16,
                    hint: const Text('Team'),
                    value:
                        ProjectStepper.allocationList[index].teamName ?? team,
                    focusColor: Colors.white,
                    isDense: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      print(newValue);
                      if (newValue != null) {
                        if (ProjectStepper.allocationList
                            .map((item) => item.teamName)
                            .contains(newValue)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Team Already exists!")));
                          return;
                        } else {
                          ref.read(counterModelProvider.notifier).press();
                          team = newValue;
                          splitData = splitTeam[newValue];
                          ProjectStepper.allocationList[index]
                              .setTeam(newValue);
                          ProjectStepper.allocationList[index]
                              .setTeamId(splitData!.split('*')[0].toString());
                          print('Added!');
                        }
                      }
                    },
                    items: Helper.teamList
                        .map<DropdownMenuItem<String>>((String value) {
                      splitTeam[value.split('*')[1]] =
                          value.split('*')[0] + '*' + value.split('*')[2];
                      return DropdownMenuItem<String>(
                        value: value.split('*')[1],
                        child: Row(
                          children: [
                            Text(value.split('*')[1]),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (value) {
                ProjectStepper.allocationList[index].setHours(value);
                ProjectStepper.allocationList[index]
                    .setCreatedId(Helper.sharedCreatedId);
                ProjectStepper.allocationList[index]
                    .setProjectId(widget.projectId);
              },
              decoration: const InputDecoration(
                labelText: 'Planned Hours',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                suffixIcon: Icon(
                  Icons.timer,
                ),
                fillColor: Colors.white,
                isDense: true,
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
