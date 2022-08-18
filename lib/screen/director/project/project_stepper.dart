import 'package:flutter/material.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/screen/director/project/project_allocation.dart';
import 'package:pmp/screen/director/project/project_create.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/projectmanagementprocessallocationproject.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../responsive/responsive.dart';

class ProjectStepper extends StatefulWidget {
  static int currentState = 0;
  static List<ProjectManagementProcessAllocationProject> allocationList = [];
  static List<ProjectManagementProcessAllocationProject> allocationListUpdate =
      [];

  const ProjectStepper({Key? key}) : super(key: key);

  @override
  State<ProjectStepper> createState() => _ProjectStepperState();
}

class _ProjectStepperState extends State<ProjectStepper> {
  var projectId;
  var totalplannedhrs;

  @override
  void initState() {
    ProjectStepper.currentState = 0;
    ProjectStepper.allocationList.clear();
    ProjectStepper.allocationListUpdate.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.cream,
            appBar: Responsive.isDesktop(context)
                ? null
                : Responsive.isMobile(context)
                    ? AppBar(
                        title: const Text('Project'),
                      )
                    : null,
            body: Consumer(builder: (context, ref, child) {
              ref.watch(projectCreationNotifierProvider).projectId.when(
                  data: (data) {
                    if (data.isNotEmpty) {
                      projectId = data.split('&')[0];
                      totalplannedhrs = data.split('&')[1];
                      ProjectStepper.currentState = 1;
                      print(projectId + " hrs=" + totalplannedhrs);
                      ref.refresh(projectCreationNotifierProvider);
                    }
                  },
                  error: (error, s) {},
                  loading: () {});
              ref.watch(projectAllocationNotifierProvider).projectId.when(
                    data: (data) {
                      if (data.isNotEmpty) {
                        ProjectStepper.currentState = 0;
                        ref.refresh(projectAllocationNotifierProvider);
                      }
                    },
                    error: (error, s) {},
                    loading: () {},
                  );
              return Stepper(
                  currentStep: ProjectStepper.currentState,
                  controlsBuilder: (context, c) {
                    return const SizedBox();
                  },
                  type: StepperType.vertical,
                  steps: [
                    Step(
                      isActive: ProjectStepper.currentState == 0,
                      title: const Text('Project Creation'),
                      content: const ProjectCreate(),
                    ),
                    Step(
                        isActive: ProjectStepper.currentState == 1,
                        title: const Text('Project Allocation'),
                        content: ProjectAllocation(projectId, totalplannedhrs))
                  ]);
            })));
  }
}
