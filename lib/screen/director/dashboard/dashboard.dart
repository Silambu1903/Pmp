import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/screen/director/profilescreen.dart';

import 'package:pmp/screen/director/project/project_details.dart';
import 'package:pmp/screen/director/updateownprofile.dart';
import 'package:pmp/screen/director/user_list.dart';

import 'package:pmp/widgets/bottombar.dart';
import 'package:pmp/widgets/bottombar_mamager_tl.dart';
import 'package:pmp/widgets/bottombar_teamember.dart';
import 'package:pmp/widgets/drawer/DrawerLayout.dart';

import '../../../helper.dart';
import '../../../provider/navigation_provider.dart';
import '../../../provider/providerLogin.dart';
import '../../../res/colors.dart';
import '../../../responsive/responsive.dart';
import '../../../service/apiService.dart';
import '../../../widgets/drawer/drawer_layout_team_member.dart';
import '../../../widgets/drawer/drawerlayout_manager.dart';
import '../../bookinng/boooking_screen.dart';
import '../../rating/rating_report_screen.dart';
import '../attendance/attendance_screen.dart';
import '../project/project_details_super_admin.dart';
import '../project/project_details_team.dart';
import '../project/project_details_manager.dart';
import '../project/project_stepper.dart';
import 'dashboard_home_team_member.dart';
import 'director_home_screen.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  final screen = [
    const DirectorDashboardScreen(),
    const ProjectDetails(),
    const UserList(),
    const ProfileScreen(),
  ];

  final windowScreen = [
    const DirectorDashboardScreen(),
    const ProjectDetails(),
    const UserList(),
    const ProjectStepper(),
    const UpdateOwnProfile(),
    const BookingScreen()
  ];


  final screenSuperAdmin = [
    const DirectorDashboardScreen(),
    const ProjectDetailsSuperAdmin(),
    const UserList(),
    const ProfileScreen(),

  ];


  final windowScreenSuperAdmin = [
    const DirectorDashboardScreen(),
    const ProjectDetailsSuperAdmin(),
    const UserList(),
    const UpdateOwnProfile(),
    const BookingScreen()
  ];

  final managerScreen = [
    const DirectorDashboardScreen(),
    const ProjectManager(),
    const UserList(),
    const ProfileScreen(),
  ];

  final windowManagerScreen = [
    const DirectorDashboardScreen(),
    const ProjectManager(),
    const UserList(),
    const UpdateOwnProfile(),
    const BookingScreen()
  ];

  final teamLeadScreen = [
    const DirectorDashboardScreen(),
    const ProjectTeam(),
    const UserList(),
    const ProfileScreen(),

  ];


  final windowTeamLeadScreen = [
    const DirectorDashboardScreen(),
    const ProjectTeam(),
    const UserList(),
    const UpdateOwnProfile(),
    const BookingScreen()
  ];


  final teamUserScreen = [
    const TeamMemberDashboardScreen(),
    const ProjectTeam(),
    const ProfileScreen(),
  ];

  final windowTeamUserScreen = [
    const TeamMemberDashboardScreen(),
    const ProjectTeam(),
    const UpdateOwnProfile(),
  ];

  @override
  void initState() {
    Helper.logout = true;
    getSharedValue();
    getApiResponse();
    super.initState();
  }

  getApiResponse() async {
    ref.read(apiProvider).getDepartments();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        ref
            .read(loginNotifier.notifier)
            .fetchUser(Helper.sharedEmployeeCode!, Helper.sharedpassword!);
      },
    );

    if (Helper.shareddepId != null) {
      ref.read(apiProvider).getTeams(Helper.shareddepId);
    }
  }

  getSharedValue() async {
    Helper.sharedEmployeeCode =
        await Helper().getStringFormSharePreferences(Helper.employeeCode);
    Helper.sharedpassword =
        await Helper().getStringFormSharePreferences(Helper.password);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Responsive.isDesktop(context)
        ? windowsUi(context)
        : Responsive.isMobile(context)
            ? mobileUi(context)
            : windowsUi(context);
  }

  mobileUi(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentIndex = ref.watch(navNotifier);
      return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.cream,
            body: Helper.sharedRoleId == 'SuperAdmin'
                ? screenSuperAdmin[currentIndex]
                : Helper.sharedRoleId == 'Manager'
                    ? managerScreen[currentIndex]
                    : Helper.sharedRoleId == 'DepartmentHead'
                        ? screen[currentIndex]
                        : Helper.sharedRoleId == 'TeamLead'
                            ? teamLeadScreen[currentIndex]
                            : Helper.sharedRoleId == 'TeamMember'
                                ? teamUserScreen[currentIndex]
                                : Container(
                                    color: Colors.pink,
                                  ),
            bottomNavigationBar: Helper.sharedRoleId == 'SuperAdmin'
                ? const BottomBarManagerTeamLead()
                : Helper.sharedRoleId == 'Manager'
                    ? const BottomBarManagerTeamLead()
                    : Helper.sharedRoleId == 'DepartmentHead'
                        ? const BottomBar()
                        : Helper.sharedRoleId == 'TeamLead'
                            ? const BottomBarManagerTeamLead()
                            : Helper.sharedRoleId == 'TeamMember'
                                ? const BottomBarTeamMember()
                                : null),
      );
    });
  }

  windowsUi(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentIndex = ref.watch(navNotifier);
      return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFFECEEF2),
            body: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Helper.sharedRoleId == 'SuperAdmin'
                        ? DrawerLayoutManager()
                        : Helper.sharedRoleId == 'Manager'
                            ? DrawerLayoutManager()
                            : Helper.sharedRoleId == 'DepartmentHead'
                                ? DrawerLayout()
                                : Helper.sharedRoleId == 'TeamLead'
                                    ? DrawerLayoutManager()
                                    : Helper.sharedRoleId == 'TeamMember'
                                        ? DrawerLayoutTeamMember()
                                        : Container()),
                Expanded(
                  flex: 7,
                  child: Helper.sharedRoleId == 'SuperAdmin'
                      ?  windowScreenSuperAdmin[currentIndex]
                      : Helper.sharedRoleId == 'Manager'
                          ?  windowManagerScreen[currentIndex]
                          : Helper.sharedRoleId == 'DepartmentHead'
                              ? windowScreen[currentIndex]
                              : Helper.sharedRoleId == 'TeamLead'
                                  ?  windowTeamLeadScreen[currentIndex]
                                  : Helper.sharedRoleId == 'TeamMember'
                                      ?  windowTeamUserScreen[currentIndex]
                                      : Container(
                                          color: Colors.pink,
                                        ),
                )
              ],
            )),
      );
    });
  }
}
