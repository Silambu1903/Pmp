import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pmp/helper.dart';

import 'package:pmp/res/screensize.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_model.dart';
import '../provider/excepationn_handle/socket_expection.dart';
import '../provider/providerLogin.dart';
import '../res/colors.dart';
import '../res/id.dart';
import '../responsive/responsive.dart';

final loginPasswordToggle = StateProvider<bool>((ref) => true);

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final usernameController = TextEditingController(text: 'EID');
  final passwordController = TextEditingController(text: '');
  bool canLogin = false;
  bool visibility = false;

  @override
  void initState() {
    super.initState();

     keepMeSingedIn();
  }



  keepMeSingedIn() async {
    String employeeCodeStr = '';
     employeeCodeStr =
        await Helper().getStringFormSharePreferences(Helper.employeeCode);
    String passwordStr =
    await Helper().getStringFormSharePreferences(Helper.password);
    if (employeeCodeStr.isEmpty ) {
    } else if (employeeCodeStr.isNotEmpty) {
      usernameController.text = employeeCodeStr;
      passwordController.text = passwordStr;
      sendData();
    }
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

  sendData() {
    canLogin = true;
    ref.read(loginNotifier.notifier).fetchUser(
        usernameController.text.toString(), passwordController.text.toString());
    Helper.logout = false;
  }

  bool validateLoginField() {
    if (usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter the valid employee code')));
      return false;
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password should not be empty')));
      return false;
    }
    return true;
  }

  saveUserDetails(
      String username,
      String password,
      String type,
      String empCode,
      var dep,
      var createdId,
      String email,
      String mobileNo,
      String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Helper.employeeCode, empCode);
    prefs.setString(Helper.password, password);
  }

  getApiValue(List<ProjectManagementProcessUserRegistration> data) async {
    Helper.sharedRoleId = data[0].type;
    Helper.shareddepId = data[0].departmentId;
    Helper.sharedteamId = data[0].teamId;
    Helper.sharedCreatedId = data[0].id;
    Helper.shareduserName = data[0].userName;
    Helper.sharedpassword = data[0].password;
    Helper.sharedEmployeeCode = data[0].employeCode;
    Helper.sharedMobile = data[0].mobileNo;
    Helper.sharedEmail = data[0].email;
    Helper.sharedAvatar = data[0].avatar;
    Helper.sharedisActive = data[0].isActive;
  }

  windowsUi(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.primary,
      body: Consumer(builder: (context, ref, child) {
        var state = ref.watch(loginNotifier);
        if (state.error == 'initial') {
          visibility = false;
        } else {
          print('error');
        }
        state.projectManagementProcessUserRegistration.when(data: (data) {
          visibility = false;
          if (data.isNotEmpty) {
            getApiValue(data);
          }
          if (data.isEmpty) {
            Future.delayed(
              const Duration(milliseconds: 200),
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid User,Try Again")));
              },
            );
            ref.refresh(loginNotifier);
          }
          if (canLogin) {
            if (!Helper.logout) {
              if (data.isNotEmpty) {
                canLogin = false;
                if (data[0].password.toString() ==
                        passwordController.text.toString() &&
                    data[0].employeCode.toString() ==
                        usernameController.text.toString()) {
                  saveUserDetails(
                      data[0].userName.toString(),
                      data[0].password.toString(),
                      data[0].type.toString(),
                      data[0].employeCode.toString(),
                      data[0].departmentId,
                      data[0].id,
                      data[0].email.toString(),
                      data[0].mobileNo.toString(),
                      data[0].avatar.toString());
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AppId.DASHBOARD_SCREEN_ID,
                        (Route<dynamic> route) => false);
                  });
                }
              }
            }
          }
        }, error: (error, s) {
          print('error');
        }, loading: () {
          print('load');
        });

        if (state.isLoading) {
          visibility = true;
        }

        final data = ref.watch(socketHandleStateNotifierProvider);
        if (data.isNotEmpty) {
          if (data == 'Connection failed') {
            visibility = false;
            Future.delayed(
              const Duration(milliseconds: 200),
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Connection Failed")));
              },
            );
          }
        }
        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/logo.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Rax - Tech International',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.009),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () async {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 25.0,
                                                      decoration:
                                                          const BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/android-logo.png'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 8,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Download on the\nPlay Store',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.006),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                          // fromHeight use double.infinity as width and 40 is the height
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 60.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () async {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 25.0,
                                                      decoration:
                                                          const BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/apple.png'),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 8,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'Download on the\n App Store',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.006),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                          // fromHeight use double.infinity as width and 40 is the height
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*       Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '20+',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        'Years Of\nExperience in IOT ',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 300,
                                        width: 350,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/successful-businessman.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Project\nManagement\nProcess',
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.027,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),*/

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.33,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: Helper.boxShadow),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Login Now',
                                        style: TextStyle(
                                            fontSize:
                                                ScreenSize.screenWidth * 0.03,
                                            color: AppColors.secondary,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    controller: usernameController,
                                    decoration: const InputDecoration(
                                      suffixIcon:
                                          Icon(Icons.account_circle_rounded),
                                      border: OutlineInputBorder(),
                                      labelText: 'Employee Code',
                                      hintText: 'Enter your Employee Code',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: TextField(
                                    controller: passwordController,
                                    textInputAction: TextInputAction.done,
                                    obscureText: ref.watch(loginPasswordToggle),
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'Password',
                                      hintText: 'Enter your password',
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          ref
                                                  .read(loginPasswordToggle
                                                      .notifier)
                                                  .state =
                                              !ref.watch(loginPasswordToggle);
                                        },
                                        child: Icon(
                                          ref.watch(loginPasswordToggle) == true
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    'Having trouble while login ?',
                                    style: TextStyle(
                                        fontSize:
                                            ScreenSize.screenWidth * 0.01),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                          value: true,
                                          onChanged: (isChecked) {
                                            /*  ref
                                                                  .read(loginStateNotifier
                                                                      .notifier)
                                                                  .state = {
                                                                'passwordToggle': ref.watch(
                                                                        loginStateNotifier)[
                                                                    'passwordToggle']!,
                                                                'keepMeSignedIn': isChecked!*/
                                          }),
                                      Text(
                                        'Keep me signed in',
                                        style: TextStyle(
                                            fontSize:
                                                ScreenSize.screenWidth * 0.01,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              ref.refresh(
                                                  socketHandleStateNotifierProvider);
                                              if (validateLoginField()) {
                                                canLogin = true;
                                                ref
                                                    .read(
                                                        loginNotifier.notifier)
                                                    .fetchUser(
                                                        usernameController.text
                                                            .toString(),
                                                        passwordController.text
                                                            .toString());
                                                Helper.logout = false;
                                              }
                                            },
                                            child: const Text('LOGIN '),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size.fromHeight(
                                                  ScreenSize.screenHeight *
                                                      0.06), // fromHeight use double.infinity as width and 40 is the height
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Terms & Conditions |  Privacy Policy',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  '© Rax-Tech International',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: visibility,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    ));
  }

  mobileUi(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.primary,
            body: SingleChildScrollView(
              child: Consumer(builder: (context, ref, child) {
                var state = ref.watch(loginNotifier);
                if (state.error == 'initial') {
                  visibility = false;
                } else {
                  print('error');
                }

                state.projectManagementProcessUserRegistration.when(
                    data: (data) {
                  visibility = false;
                  if (data.isNotEmpty) {
                    getApiValue(data);
                  }
                  if (data.isEmpty) {
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Invalid User,Try Again")));
                      },
                    );
                    ref.refresh(loginNotifier);
                  }
                  if (canLogin) {
                    if (!Helper.logout) {
                      if (data.isNotEmpty) {
                        canLogin = false;
                        if (data[0].password.toString() ==
                                passwordController.text.toString() &&
                            data[0].employeCode.toString() ==
                                usernameController.text.toString()) {
                          saveUserDetails(
                              data[0].userName.toString(),
                              data[0].password.toString(),
                              data[0].type.toString(),
                              data[0].employeCode.toString(),
                              data[0].departmentId,
                              data[0].id,
                              data[0].email.toString(),
                              data[0].mobileNo.toString(),
                              data[0].avatar.toString());
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AppId.DASHBOARD_SCREEN_ID,
                                (Route<dynamic> route) => false);
                          });
                        }
                      }
                    }
                  }
                }, error: (error, s) {
                  print('error');
                }, loading: () {
                  print('load');
                });

                if (state.isLoading) {
                  visibility = true;
                }

                final data = ref.watch(socketHandleStateNotifierProvider);
                if (data.isNotEmpty) {
                  if (data == 'Connection failed') {
                    visibility = false;
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Connection Failed")));
                      },
                    );
                  }
                }
                return SizedBox(
                  height: ScreenSize.safeBlockVertical * 100,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 15.0, right: 15.0),
                            child: Container(
                              height: ScreenSize.screenHeight * 0.6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  boxShadow: Helper.boxShadow),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Login Now',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.07,
                                                color: AppColors.secondary,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: TextField(
                                        textInputAction: TextInputAction.next,
                                        controller: usernameController,
                                        decoration: const InputDecoration(
                                          suffixIcon: Icon(
                                              Icons.account_circle_rounded),
                                          border: OutlineInputBorder(),
                                          labelText: 'Employee Code',
                                          hintText: 'Enter your Employee Code',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: TextField(
                                        controller: passwordController,
                                        textInputAction: TextInputAction.done,
                                        obscureText:
                                            ref.watch(loginPasswordToggle),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Password',
                                          hintText: 'Enter your password',
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              ref
                                                      .read(loginPasswordToggle
                                                          .notifier)
                                                      .state =
                                                  !ref.watch(
                                                      loginPasswordToggle);
                                            },
                                            child: Icon(
                                              ref.watch(loginPasswordToggle) ==
                                                      true
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Text(
                                        'Having trouble while login ?',
                                        style: TextStyle(
                                            fontSize:
                                                ScreenSize.screenWidth * 0.03),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                              value: true,
                                              onChanged: (isChecked) {
                                                /*  ref
                                                        .read(loginStateNotifier
                                                            .notifier)
                                                        .state = {
                                                      'passwordToggle': ref.watch(
                                                              loginStateNotifier)[
                                                          'passwordToggle']!,
                                                      'keepMeSignedIn': isChecked!*/
                                              }),
                                          Text(
                                            'Keep me signed in',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenSize.screenWidth *
                                                        0.04,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, bottom: 10.0),
                                      child: Consumer(
                                          builder: (context, ref, child) {
                                        return ElevatedButton(
                                          onPressed: () async {
                                            ref.refresh(
                                                socketHandleStateNotifierProvider);
                                            if (validateLoginField()) {
                                              canLogin = true;
                                              ref
                                                  .read(loginNotifier.notifier)
                                                  .fetchUser(
                                                      usernameController.text
                                                          .toString(),
                                                      passwordController.text
                                                          .toString());
                                              Helper.logout = false;
                                            }
                                          },
                                          child: const Text('LOGIN'),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size.fromHeight(ScreenSize
                                                    .screenHeight *
                                                0.07), // fromHeight use double.infinity as width and 40 is the height
                                          ),
                                        );
                                      }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: ScreenSize.screenHeight * 0.525,
                        right: ScreenSize.screenWidth * 0.0525,
                        child: SizedBox(
                            width: ScreenSize.screenWidth * 0.28,
                            child: const Image(
                                image: AssetImage('assets/loginGirl.png'))),
                      ),
                      Positioned(
                        top: ScreenSize.screenHeight * 0.01,
                        left: ScreenSize.screenWidth * 0.01,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RichText(
                            text: TextSpan(
                                text: 'RAX\n',
                                style: GoogleFonts.montserrat(
                                  color: Colors.red,
                                  fontSize: ScreenSize.screenWidth * 0.1,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Process\n',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.07,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200)),
                                  TextSpan(
                                      text: 'Management\n',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.07,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200)),
                                  TextSpan(
                                      text: 'Project',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.07,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200)),
                                ]),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visibility,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            )));
  }



}
