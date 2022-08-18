import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/projectmanagementprocessallocationproject.dart';
import '../../screen/director/project/project_allocation.dart';

/*
final addTeamNotifier = ChangeNotifierProvider((ref) => AddTeamProvider());

class AddTeamProvider extends ChangeNotifier {
  List<ProjectManagementProcessAllocationProject> allocationList = [];

  void incrementValue(ProjectManagementProcessAllocationProject projectAllocation) {
     allocationList.add(projectAllocation);
    notifyListeners();
  }
}
*/

final addTeamNotifier = StateNotifierProvider<AddTeamProvider,
    List<ProjectManagementProcessAllocationProject>>((ref) {
  return AddTeamProvider(ref);
});

class AddTeamProvider
    extends StateNotifier<List<ProjectManagementProcessAllocationProject>> {
  final Ref ref;

  AddTeamProvider(this.ref) : super([]);

  void incrementValue(
      List<ProjectManagementProcessAllocationProject> projectAllocation) {
    state = projectAllocation;
  }

  void deIncrementValue(int index) {
    state.removeAt(index);
  }
}
