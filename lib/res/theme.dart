import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/id.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pmp/screen/comments/comments_screen.dart';
import 'package:pmp/screen/director/assgin/assign_project.dart';
import 'package:pmp/screen/director/dailytask/daily_task.dart';
import 'package:pmp/screen/director/dailytask/daily_task_department_head.dart';
import 'package:pmp/screen/director/project/project_stepper.dart';
import 'package:pmp/screen/director/project/update_project.dart';
import 'package:pmp/screen/director/updateownprofile.dart';
import 'package:pmp/screen/director/user_creation.dart';
import 'package:pmp/screen/login.dart';
import 'package:pmp/screen/pofilescreen/general/general_settinngs_screen.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pmp/screen/reports/project_report/project_report_screen_department_head.dart';
import 'package:pmp/screen/reports/team_report/teamwisereportdetails.dart';
import '../screen/director/dashboard/dashboard.dart';
import '../screen/director/project/project_stepper_update.dart';
import '../screen/rating/rating_report_screen.dart';
import '../screen/rating/userRating.dart';
import '../screen/reports/project_report/project_report_screen.dart';
import '../screen/reports/project_report/project_report_team_lead.dart';
import '../screen/reports/team_report/teamleadreportdetails.dart';
import '../screen/reports/team_report/teamwisereportscreen.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: AppColors.primarySwatch,
              accentColor: Colors.red,
              backgroundColor: Colors.pink,
              primaryColorDark: Colors.orange),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          )),
      initialRoute: AppId.LoginID,
      routes: <String, WidgetBuilder>{
        AppId.LoginID: (context) => const Login(),
        AppId.PROJECT_CREATION_ID: (context) => const ProjectStepper(),
        AppId.DASHBOARD_SCREEN_ID: (context) => const DashBoardScreen(),
        AppId.CREATE_USER_SCREEN_ID: (context) => const UserCreation(),
        AppId.GENERAL_SETTINGS__SCREEN_ID: (context) => GeneralSettingScreen(),
        AppId.UPDATE_OWN_PROFILE: (context) => const UpdateOwnProfile(),
        AppId.ASSGIN_PROJECT: (context) => AssignProject(),
        AppId.RATING_SCREEN_ID: (context) => const UserRating(),
        AppId.UPDATE_PROJECT_SCREEN: (context) => ProjectStepperUpdate(),
        AppId.DAILY_TASK: (context) => DailyTask(),
        AppId.PROJECT_REPORT_DEP_HEAD_SCREEN_ID: (context) =>
            const ProjectReportDepartmentHeadScreen(),
        AppId.PROJECT_REPORT_TEAM_LEAD_SCREEN_ID: (context) =>
            const ProjectReportTeamLeadScreen(),
        AppId.RATING_LIST_SCREEN_ID: (context) => const RatingReportScreen(),
        AppId.DAILY_TASK_DEPARTMENT: (context) => DailyTaskDepartmentHead(),
        AppId.PROJECT_REPORT_SCREEN_ID: (context) =>
            const ProjectReportScreen(),
        AppId.TEAMWISE_REPORT: (context) => const TeamWiseReportScreen(),
        AppId.COMMENT_SCREEN: (context) => CommentScreen(),
        AppId.TEAMWISE_REPORT_DETAILS: (context) => TeamWiseReportDetails(),
        AppId.TEAMLEAD_REPORT: (context) => const TeamLeadReportDetails(),
      },
    );
  }
}
