import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/provider/project_allocation_provider/project_report_team_lead.dart';
import '../../model/project_management_process_team_creation.dart';
import '../../model/projectmanagementprocessteamcreation.dart';
import '../../model/projectreportlist.dart';
import '../../service/apiService.dart';

final projectReportListSuperAdminNotifier =
    FutureProvider<List<ProjectReportList>>((ref) async {
  return await ref.read(apiProvider).getProjectReportSuperAdminData();
});

final projectReportListDepartmentHeadNotifier =
    FutureProvider.family<List<ProjectReportList>, List<String>>((ref, data) async {
  return await ref.read(apiProvider).getProjectReportDepartmentHeadData(data);
});

final projectReportListTeamLeadNotifier =
    FutureProvider.family<List<ProjectReportTeamLead>,List<String>>((ref,data) async {
  return await ref.read(apiProvider).getProjectReportDepartmentTeamLead(data);
});

final getTeamWiseReportNotifier =
    FutureProvider<List<ProjectManagementProcessTeamCreationReport>>(
        (ref) async {
  return await ref.read(apiProvider).getTeamWiseReport();
});

final getTeamLeadReportNotifier =
    FutureProvider<List<ProjectManagementProcessTeamCreationReport>>(
        (ref) async {
  return await ref.read(apiProvider).getTeamLeadReport();
});
