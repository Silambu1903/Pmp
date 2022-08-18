import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmp/service/apiService.dart';

import '../../../helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/login_model.dart';
import '../../../provider/changenotifier/dataSuccess_notifier.dart';
import '../../../provider/changenotifier/widget_notifier.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/colors.dart';

class GeneralSettingScreen extends ConsumerStatefulWidget {
  ProjectManagementProcessUserRegistration? mUser;
  String? userList;

  GeneralSettingScreen({this.mUser, this.userList});

  @override
  _GeneralSettingScreenState createState() => _GeneralSettingScreenState();
}

class _GeneralSettingScreenState extends ConsumerState<GeneralSettingScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController employeeCode = TextEditingController();
  TextEditingController role = TextEditingController();
  bool? isActive = true;
  String? userNameStr,
      emailStr,
      employeeCodeStr,
      mobileNoStr,
      roleStr,
      passwordStr;

  getValue() {
    if (widget.mUser != null) {
      userNameStr = widget.mUser!.userName.toString();
      emailStr = widget.mUser!.email.toString();
      employeeCodeStr = widget.mUser!.employeCode.toString();
      mobileNoStr = widget.mUser!.mobileNo.toString();
      roleStr = widget.mUser!.type.toString();
      passwordStr = widget.mUser!.password.toString();
      isActive = widget.mUser!.isActive;
    } else {
      userNameStr = Helper.shareduserName.toString();
      emailStr = Helper.sharedEmail.toString();
      employeeCodeStr = Helper.sharedEmployeeCode.toString();
      mobileNoStr = Helper.sharedMobile.toString();
      roleStr = Helper.sharedRoleId.toString();
      passwordStr = Helper.sharedpassword.toString();
      isActive = Helper.sharedisActive;
    }
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(userNameStr! + ' Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.userList == 'userListScreen'
                        ? Row(
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
                                  value: isActive,
                                  onChanged: (value) {
                                    ref
                                        .read(counterModelProvider.notifier)
                                        .press();
                                    isActive = value!;
                                  },
                                );
                              }),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        controller: userName..text = userNameStr.toString(),
                        onChanged: (value) {
                          userNameStr = value;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        textInputAction: TextInputAction.next, //
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: email..text = emailStr.toString(),
                        onChanged: (value) {
                          emailStr = value;
                        },
                        textInputAction: TextInputAction.next, //
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        enabled: false,
                        controller: employeeCode
                          ..text = employeeCodeStr.toString(),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                        ],
                        onChanged: (value) {
                          employeeCodeStr = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Employee Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        enabled: false,
                        controller: role..text = roleStr.toString(),
                        textInputAction: TextInputAction.next,
                        //
                        onChanged: (value) {
                          roleStr = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        onChanged: (value) {
                          passwordStr = value;
                        },
                        textInputAction: TextInputAction.next,
                        //
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        controller: password..text = passwordStr.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        onChanged: (value) {
                          mobileNoStr = value;
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        //
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: mobileNo..text = mobileNoStr.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Mobile No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: Consumer(builder: (context, ref, child) {
                              final data = ref.watch(dataChangeNotifier);
                              if (data.response == 'Success') {
                                Future.delayed(Duration.zero, () {
                                  Navigator.pop(context);
                                });
                              }
                              return ElevatedButton(
                                onPressed: () async {
                                  if (validateField()) {
                                    ref.read(apiProvider).updateUser(
                                            ProjectManagementProcessUserRegistration(
                                          isActive: isActive,
                                          userName: userNameStr,
                                          email: emailStr,
                                          password: passwordStr,
                                          mobileNo: mobileNoStr,
                                          employeCode: employeeCodeStr,
                                        ));
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('UPDATE'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size.fromHeight(ScreenSize
                                          .screenHeight *
                                      0.07), // fromHeight use double.infinity as width and 40 is the height
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateField() {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    String mobilepattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExpMobile = RegExp(mobilepattern);
    if (userName.text.isEmpty) {
      displayErrorMessages('Name should not be empty');
      return false;
    } else if (userName.text.length < 3) {
      displayErrorMessages(
          'Please enter the valid name with minimum 3 characters');
      return false;
    } else if (!regex.hasMatch(email.text)) {
      displayErrorMessages('Please enter the valid email address');
      return false;
    } else if (email.text.isEmpty) {
      displayErrorMessages('Email address should not be empty');
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
}
