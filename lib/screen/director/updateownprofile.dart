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
import '../../provider/user_creation/update_user_provider.dart';
import '../../provider/user_creation/user_creation_provider.dart';
import '../../responsive/responsive.dart';
import '../../widgets/shimmer/shimmeruserlist.dart';
import '../../widgets/shimmer/shimmeruseruupdate.dart';

class UpdateOwnProfile extends ConsumerStatefulWidget {
  const UpdateOwnProfile({Key? key}) : super(key: key);

  @override
  _GeneralSettingScreenState createState() => _GeneralSettingScreenState();
}

class _GeneralSettingScreenState extends ConsumerState<UpdateOwnProfile> {
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
  bool visibility = false;
  int tempInt = 0;

  @override
  void initState() {
    tempInt = 0;
    super.initState();
  }

  getValue(List<ProjectManagementProcessUserRegistration> data) {
    userNameStr = data[0].userName.toString();
    emailStr = data[0].email;
    employeeCodeStr = data[0].employeCode;
    mobileNoStr = data[0].mobileNo;
    roleStr = data[0].type;
    passwordStr = data[0].password;
    isActive = data[0].isActive;
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Responsive.isDesktop(context)
        ? windowUi(context)
        : Responsive.isMobile(context)
            ? mobileUi(context)
            : windowUi(context);
  }

  windowUi(BuildContext context) {
    return ref.watch(getCurrentUser).when(data: (data) {
      tempInt++;
      if (tempInt == 1) {
        getValue(data);
      }
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.cream,
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children:  [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Text(
                              "Update My Profile",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.02),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: TextFormField(
                                controller: userName
                                  ..text = userNameStr.toString(),
                                onChanged: (value) {
                                  userNameStr = value;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                textInputAction: TextInputAction.next,
                                //
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
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
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  passwordStr = value;
                                },
                                textInputAction: TextInputAction.next,
                                //
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                controller: password
                                  ..text = passwordStr.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  mobileNoStr = value;
                                },
                                textInputAction: TextInputAction.done,
                                //
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                keyboardType: TextInputType.number,
                                controller: mobileNo
                                  ..text = mobileNoStr.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Mobile No',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Consumer(builder: (context, ref, child) {
                            var state = ref.watch(updateUserNotifier);
                            if (state.error == 'initial') {
                              visibility = false;
                            } else if (state.error == 'Update Failed') {
                              visibility = false;
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Update Failed")));
                                  ref.refresh(addUserNotifier);
                                },
                              );
                            }
                            state.id.when(data: (data) {
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                    () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Update Successfully")));
                                  ref.refresh(updateUserNotifier);
                                  ref.refresh(addUserNotifier);
                                },
                              );
                           /*   Future.delayed(
                                  const Duration(milliseconds: 400), () {
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content:
                                                Text("Update Successfully")));

                                  },
                                );
                                Navigator.pop(context);
                              });*/
                            }, error: (error, s) {
                              visibility = false;
                            }, loading: () {
                              visibility = false;
                            });

                            if (state.isLoading) {
                              visibility = true;
                            }
                            return SizedBox(
                              width: MediaQuery.of(context).size.width*0.2,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (validateField()) {
                                    ref
                                        .read(updateUserNotifier.notifier)
                                        .updateUser(
                                            ProjectManagementProcessUserRegistration(
                                          isActive: isActive,
                                          userName: userNameStr,
                                          email: emailStr,
                                          password: passwordStr,
                                          mobileNo: mobileNoStr,
                                          employeCode: employeeCodeStr,
                                        ));
                                  }
                                },
                                child: const Text('UPDATE'),
                                // fromHeight use double.infinity as width and 40 is the height

                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }, error: (e, s) {
      return Center(
        child: Text(e.toString()),
      );
    }, loading: () {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        backgroundColor: AppColors.cream,
        body: ShimmerForUserList(),
      );
    });
  }

  mobileUi(BuildContext context) {
    return ref.watch(getCurrentUser).when(data: (data) {
      tempInt++;
      if (tempInt == 1) {
        getValue(data);
      }
      return Scaffold(
        backgroundColor: AppColors.cream,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                          textInputAction: TextInputAction.next,
                          //
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
                          textInputAction: TextInputAction.done,
                          //
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          keyboardType: TextInputType.number,
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
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Consumer(builder: (context, ref, child) {
                                var state = ref.watch(updateUserNotifier);
                                if (state.error == 'initial') {
                                  visibility = false;
                                } else if (state.error == 'Update Failed') {
                                  visibility = false;
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Update Failed")));
                                      ref.refresh(addUserNotifier);
                                    },
                                  );
                                }
                                state.id.when(data: (data) {

                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                        () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Update Successfully")));
                                      ref.refresh(updateUserNotifier);
                                      ref.refresh(addUserNotifier);
                                    },
                                  );

                              /*    Future.delayed(
                                      const Duration(milliseconds: 400), () {
                                    Future.delayed(
                                      const Duration(milliseconds: 200),
                                      () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Update Successfully")));
                                        ref.refresh(updateUserNotifier);
                                        ref.refresh(addUserNotifier);
                                      },
                                    );
                                    Navigator.pop(context);
                                  });*/
                                }, error: (error, s) {
                                  visibility = false;
                                }, loading: () {
                                  visibility = false;
                                });

                                if (state.isLoading) {
                                  visibility = true;
                                }
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (validateField()) {
                                      ref
                                          .read(updateUserNotifier.notifier)
                                          .updateUser(
                                              ProjectManagementProcessUserRegistration(
                                            isActive: isActive,
                                            userName: userNameStr,
                                            email: emailStr,
                                            password: passwordStr,
                                            mobileNo: mobileNoStr,
                                            employeCode: employeeCodeStr,
                                          ));
                                    }
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
    }, error: (e, s) {
      return Center(
        child: Text(e.toString()),
      );
    }, loading: () {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
        ),
        backgroundColor: AppColors.cream,
        body: ShimmerForUserList(),
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
