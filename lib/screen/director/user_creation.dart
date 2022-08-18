import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/helper.dart';
import 'package:pmp/model/project_management_process_team_creation.dart';
import 'package:pmp/provider/avatarpickerprovider/avatarpickerProvider.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/service/apiService.dart';

import '../../model/login_model.dart';
import '../../model/project_management_process_department.dart';
import '../../provider/changenotifier/widget_notifier.dart';
import '../../provider/created_user_provider/created_user_list_provider.dart';
import '../../provider/excepationn_handle/expextion_handle_provider.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/user_creation/user_creation_provider.dart';
import '../../res/id.dart';

class UserCreation extends ConsumerStatefulWidget {
  const UserCreation({Key? key}) : super(key: key);

  @override
  _UserCreationState createState() => _UserCreationState();
}

class _UserCreationState extends ConsumerState<UserCreation> {
  bool is_active = true;
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController(text: '123456');
  TextEditingController employeeId = TextEditingController(text: 'EID');
  TextEditingController mobileNo = TextEditingController();
  bool visibility = false;
  String? type, dep, team;
  var depId, teamId;
  List<ProjectManagementProcessDepartmentCreation> departmentList = [];
  List<ProjectManagementProcessTeamCreation> teamList = [];

  List<String> superAdminRole = [
    'DepartmentHead',
  ];

  List<String> departmentHeadRole = [
    'Manager',
  ];
  List<String> managerRole = [
    'TeamLead',
  ];

  List<String> teamLeadRole = [
    'TeamMember',
  ];

  Map<dynamic, dynamic> splitDepartment = {};
  Map<dynamic, dynamic> splitTeam = {};
  bool _validate = false;

  @override
  void initState() {
    ref.refresh(addUserNotifier);
    depId = Helper.sharedRoleId.toString() == 'SuperAdmin'
        ? null
        : Helper.shareddepId;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var state = ref.watch(addUserNotifier);
      if (state.error == 'initial') {
        visibility = false;
      } else if(state.error == 'EmployeeId Exists') {
        visibility = false;
        Future.delayed(
          const Duration(milliseconds: 200),
              () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("EmployeeId Exists")));
            ref.refresh(addUserNotifier);
          },
        );
      }
      state.id.when(data: (data) {
        Future.delayed(const Duration(milliseconds: 400 ), () {
          ref.refresh(userListStateProvider);
          Navigator.pop(context);
        });

      }, error: (error, s) {
        visibility = false;
      }, loading: () {
        visibility = false;
      });

      if (state.isLoading) {
       visibility = true;
      }
      return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Create User',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                mobileDialog(context);
                                              },
                                              child: Consumer(builder:
                                                  (context, ref, child) {
                                                return Container(
                                                  width: 80.0,
                                                  height: 80.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          ref.watch(
                                                              avatarNotifier)),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Choose Profile Image',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'IsActive',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Consumer(builder: (context, ref, child) {
                                        ref.watch(counterModelProvider);
                                        return Checkbox(
                                          checkColor: AppColors.primary,
                                          activeColor: Colors.black,
                                          value: is_active,
                                          onChanged: (value) {
                                            ref
                                                .read(counterModelProvider
                                                    .notifier)
                                                .press();
                                            is_active = value!;
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: TextFormField(
                              controller: userName,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: false,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  width: ScreenSize.screenWidth,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    ref.watch(counterModelProvider);
                                    List<String> list = [];
                                    if (Helper.sharedRoleId == 'SuperAdmin') {
                                      list = superAdminRole;
                                    } else if (Helper.sharedRoleId ==
                                        'DepartmentHead') {
                                      list = departmentHeadRole;
                                    } else if (Helper.sharedRoleId ==
                                        'Manager') {
                                      list = managerRole;
                                    } else if (Helper.sharedRoleId ==
                                        'TeamLead') {
                                      list = teamLeadRole;
                                    } else if (Helper.sharedRoleId ==
                                        'TeamMember') {}
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          iconSize: 24,
                                          elevation: 16,
                                          hint: const Text('Role'),
                                          value: type,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          onChanged: (String? newValue) {
                                            ref
                                                .read(counterModelProvider
                                                    .notifier)
                                                .press();
                                            type = newValue;
                                          },
                                          items: list
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              )),
                          Visibility(
                            visible: Helper.sharedRoleId == 'SuperAdmin'
                                ? true
                                : false,
                            child: Consumer(builder: (context, ref, child) {
                              ref.watch(counterModelProvider);
                              return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  width: ScreenSize.screenWidth,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        iconSize: 24,
                                        elevation: 16,
                                        hint: const Text('Department'),
                                        value: dep,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        onChanged: (String? newValue) {
                                          ref
                                              .read(
                                                  counterModelProvider.notifier)
                                              .press();
                                          dep = newValue;
                                          depId = splitDepartment[newValue];
                                        },
                                        items: Helper.departmentList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          splitDepartment[value
                                              .split('*')
                                              .last] = value.split('*').first;
                                          return DropdownMenuItem<String>(
                                            value: value.split('*').last,
                                            child: Row(
                                              children: [
                                                Text(value.split('*').last),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Visibility(
                            visible:
                                Helper.sharedRoleId == 'Manager' ? true : false,
                            child: Consumer(builder: (context, ref, child) {
                              ref.watch(counterModelProvider);
                              return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Container(
                                  width: ScreenSize.screenWidth,
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        iconSize: 24,
                                        elevation: 16,
                                        hint: const Text('Team'),
                                        value: team,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        onChanged: (String? newValue) {
                                          ref
                                              .read(
                                                  counterModelProvider.notifier)
                                              .press();
                                          team = newValue;
                                          String splitData =
                                              splitTeam[newValue];
                                          teamId = splitData.split('*')[0];
                                        },
                                        items: Helper.teamList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          splitTeam[value.split('*')[1]] =
                                              value.split('*')[0] +
                                                  '*' +
                                                  value.split('*')[2];
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
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: email,

                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: employeeId,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Employee Code',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: mobileNo,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Mobile No',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: password,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              width: ScreenSize.screenWidth,
                              height: ScreenSize.screenHeight * 0.07,
                              child: Consumer(builder: (context, ref, child) {
                                return MaterialButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    if (Helper.sharedRoleId == 'SuperAdmin') {
                                      type = 'DepartmentHead';
                                    } else if (Helper.sharedRoleId ==
                                        'DepartmentHead') {
                                      type = 'Manager';
                                    } else if (Helper.sharedRoleId ==
                                        'Manager') {
                                      type = 'TeamLead';
                                    } else if (Helper.sharedRoleId ==
                                        'TeamLead') {
                                      type = 'TeamMember';
                                    }
                                   if (validateField()) {
                                      ref
                                          .read(
                                              exceptionHandleStateNotifierProvider
                                                  .notifier)
                                          .dataHandler(
                                              true, 'No user available');
                                      depId ??= Helper.shareddepId;
                                      teamId = Helper.sharedRoleId.toString() ==
                                              'Manager'
                                          ? teamId
                                          : Helper.sharedRoleId.toString() ==
                                                  'TeamLead'
                                              ? Helper.sharedteamId
                                              : "00000000-0000-0000-0000-000000000000";

                                      ref
                                          .read(addUserNotifier.notifier)
                                          .addUser(
                                              ProjectManagementProcessUserRegistration(
                                            userName: userName.text.toString(),
                                            email: email.text.toString(),
                                            employeCode:
                                                employeeId.text.toString(),
                                            password: password.text.toString(),
                                            mobileNo: mobileNo.text.toString(),
                                            isActive: is_active,
                                            type: type,
                                            avatar: Helper.avatar,
                                            departmentId: depId,
                                            createdId: Helper.sharedCreatedId,
                                            teamId: teamId,
                                          ));

                                      ref.refresh(userListStateProvider);
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Visibility(
              visible: visibility,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  bool validateField() {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    String mobilepattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExpMobile = RegExp(mobilepattern);
    depId = Helper.sharedRoleId.toString() == 'SuperAdmin'
        ? splitDepartment[dep]
        : Helper.shareddepId;

    if (userName.text.isEmpty) {
      displayErrorMessages('Enter the Name');
      return false;
    } else if (userName.text.length < 3) {
      displayErrorMessages('Enter the valid name with minimum 3 characters');
      return false;
    } else if (type == null || type.toString().isEmpty) {
      displayErrorMessages('Please select the Role');
      return false;
    } else if (depId == null || depId.toString().isEmpty) {
      displayErrorMessages('Please select the department');
      return false;
    } else if ((Helper.sharedRoleId == 'Manager') && teamId == null ||
        teamId.toString().isEmpty) {
      displayErrorMessages('Please select the team');
      return false;
    } else if (!regex.hasMatch(email.text)) {
      displayErrorMessages('Please enter the valid email address');
      return false;
    } else if (email.text.isEmpty) {
      displayErrorMessages('Email address should not be empty');
      return false;
    } else if (employeeId.text.isEmpty) {
      displayErrorMessages('Please enter the valid employee code');
      return false;
    } else if (employeeId.text.length < 5) {
      displayErrorMessages('Please enter the valid employee code');
      return false;
    } else if (mobileNo.text.isEmpty) {
      displayErrorMessages('Please enter the valid mobile number');
      return false;
    } else if (mobileNo.text.length != 10) {
      displayErrorMessages('Please enter the valid mobile number');
      return false;
    } else if (!regExpMobile.hasMatch(mobileNo.text)) {
      displayErrorMessages('Please enter the valid mobile number');
      return false;
    } else if (password.text.isEmpty) {
      displayErrorMessages('Password should not be empty');
      return false;
    } else if (password.text.length != 6) {
      displayErrorMessages('Password length should be 6 characters');
      return false;
    }
    return true;
  }

  displayErrorMessages(String errormessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errormessage)));
  }

  bool validateTextField(String userInput, String text) {
    if (userInput.isEmpty) {
      setState(() {
        _validate = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(text),
        ));
      });
      return false;
    }
    setState(() {
      _validate = false;
    });
    return true;
  }

  bool validateEmail(String? value, String message) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      setState(() {
        _validate = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
      return false;
    }
    setState(() {
      _validate = false;
    });
    return true;
  }

  bool validateMobile(String value, String message) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      setState(() {
        _validate = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
      return false;
    }
    setState(() {
      _validate = false;
    });
    return true;
  }

  mobileDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text('Select Your Avatar'),
                  actions: <Widget>[
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_4.png?alt=media&token=b784db97-1d91-4b6d-92fe-5c5498cc299a';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_4.png?alt=media&token=b784db97-1d91-4b6d-92fe-5c5498cc299a'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_7.png?alt=media&token=a474e769-1123-4fcd-b61a-08f5b142f18b';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_7.png?alt=media&token=a474e769-1123-4fcd-b61a-08f5b142f18b'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_6.png?alt=media&token=bf919fcd-d6b4-42a7-b67f-20653d51d4b4';
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_6.png?alt=media&token=bf919fcd-d6b4-42a7-b67f-20653d51d4b4'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_5.png?alt=media&token=6cc73b49-c348-436a-a7a2-66f67fe3a808';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_5.png?alt=media&token=6cc73b49-c348-436a-a7a2-66f67fe3a808'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_7.png?alt=media&token=a474e769-1123-4fcd-b61a-08f5b142f18b';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_7.png?alt=media&token=a474e769-1123-4fcd-b61a-08f5b142f18b'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_3.png?alt=media&token=05600dda-67d7-4a0c-a6e7-fc6c09fe4a95';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar_3.png?alt=media&token=05600dda-67d7-4a0c-a6e7-fc6c09fe4a95'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar%20(1).png?alt=media&token=87d0524b-4e5b-408e-9005-0a43916be27e';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar%20(1).png?alt=media&token=87d0524b-4e5b-408e-9005-0a43916be27e'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Helper.avatar =
                                      'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar%20(2).png?alt=media&token=af363ea3-e46e-4c79-9ea7-b3452cc45913';
                                  ref
                                      .read(avatarNotifier.notifier)
                                      .currentAvatar(Helper.avatar);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/projectmanagement-process.appspot.com/o/avatar%20(2).png?alt=media&token=af363ea3-e46e-4c79-9ea7-b3452cc45913'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));

  itemBuilder(avatarList) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(avatarList),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
