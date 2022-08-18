import 'package:flutter/material.dart';

import 'package:pmp/res/colors.dart';

import 'package:pmp/screen/director/project/project_allocation_update.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/screen/director/project/project_stepper.dart';
import 'package:pmp/screen/director/project/project_upate.dart';
import '../../../model/projectmanagementdetails.dart';

import '../../../model/projectmanagementprocessallocationproject.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';

class ProjectStepperUpdate extends ConsumerStatefulWidget {
  ProjectManagementProcessProjectCreationDetails? data;
  ProjectStepperUpdate({this.data});
  static var totalplannedhrs;

  @override
  _ProjectStepperUpdateState createState() => _ProjectStepperUpdateState();
}

class _ProjectStepperUpdateState extends ConsumerState<ProjectStepperUpdate> {
  int? _currentState = 0;
  var projectId;


  @override
  void initState() {
    ProjectStepper.allocationList.clear();
    ProjectStepper.allocationListUpdate.clear();
    ref.refresh(projectCreationNotifierProvider);
    ProjectStepperUpdate.totalplannedhrs = widget.data!.plannedHrs!;
    getUpdateValue();
    super.initState();
  }

  getUpdateValue() {
    print('init');
    ProjectStepper.allocationListUpdate.clear();
    for (var element in widget.data!.allocationProjects!) {
      ProjectStepper.allocationListUpdate.add(
          ProjectManagementProcessAllocationProject(
              id: element.id,
              teamId: element.teamId,
              projectId: element.projectId,
              plannedHrs: element.plannedHrs,
              createdId: element.createdId,
              isActive: element.isActive,
              teamName: element.teamCreation!.teamName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          title: const Text('Project Update'),
        ),
        body: Consumer(builder: (context, ref, child) {
          ref.watch(projectCreationNotifierProvider).projectId.when(
                data: (data) {
                  if (data.isNotEmpty) {
                    projectId = data.split('&')[0];
                    ProjectStepperUpdate.totalplannedhrs = data.split('&')[1];
                    _currentState = 1;

                    print(projectId + " hrs=" + ProjectStepperUpdate.totalplannedhrs);
                  }
                },
                error: (error, s) {},
                loading: () {},
              );
          return Stepper(
            currentStep: _currentState!,
            controlsBuilder: (context, c) {
              return const SizedBox();
            },
            type: StepperType.vertical,
            onStepTapped: (int index) {
              setState(() {
                _currentState = index;
              });
            },
            steps: [
              Step(
                  isActive: _currentState == 0,
                  title: const Text('Project Create'),
                  content: ProjectUpdate(data: widget.data)),
              Step(
                  isActive: _currentState == 1,
                  title: const Text('Project Allocation'),
                  content: ProjectAllocationUpdate(widget.data))
            ],
          );
        }),
      ),
    );
  }
}
