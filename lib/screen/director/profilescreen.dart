import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/id.dart';
import 'package:pmp/res/screensize.dart';

import '../../helper.dart';
import '../../provider/changenotifier/dataSuccess_notifier.dart';
import '../../provider/changenotifier/widget_notifier.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/user_creation/user_creation_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool valuefirst = false;
  dynamic department = '';
  @override
  void initState() {
    super.initState();
    department = Helper.filterDepartment[Helper.shareddepId];
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipPath(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: ScreenSize.screenHeight * 0.2,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    left: ScreenSize.screenWidth * 0.35,
                    top: ScreenSize.screenHeight * 0.1,
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(Helper.sharedAvatar),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: ScreenSize.screenWidth * 0.42,
                    top: ScreenSize.screenHeight * 0.04,
                    child: Center(
                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenSize.screenWidth * 0.05),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Helper.shareduserName.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.screenWidth * 0.05),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            department == null ? '' : department.toString(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenSize.screenWidth * 0.025),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: const [
                            Text(
                              'General',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 10,
                                                  bottom: 5.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Profile Settings',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: ScreenSize
                                                                .screenWidth *
                                                            0.05,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Update your profile',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: ScreenSize
                                                              .screenWidth *
                                                          0.03,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons
                                                        .arrow_forward_ios_rounded),
                                                    onPressed: () {
                                                      ref.read(dataChangeNotifier.notifier).callBack('');
                                                      Navigator.pushNamed(
                                                          context,
                                                          AppId
                                                              .UPDATE_OWN_PROFILE);
                                                      ref.refresh(getCurrentUser);
                                                    },
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Expanded(
                                            child: Divider(
                                          height: 10,
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 10,
                                                bottom: 5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Report',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: ScreenSize
                                                              .screenWidth *
                                                          0.05,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'View all your reports',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenSize.screenWidth *
                                                            0.03,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons
                                                      .arrow_forward_ios_rounded),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Expanded(
                                            child: Divider(
                                          height: 10,
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 10,
                                                bottom: 15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Attendance',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: ScreenSize
                                                              .screenWidth *
                                                          0.05,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'Update your daily attendances',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenSize.screenWidth *
                                                            0.03,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .arrow_forward_ios_rounded),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 10,
                                                bottom: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'About Us',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: ScreenSize
                                                              .screenWidth *
                                                          0.05,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  'Know more about team and goal',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenSize.screenWidth *
                                                            0.03,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons
                                                      .arrow_forward_ios_rounded),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Expanded(
                                            child: Divider(
                                          height: 10,
                                        )),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  left: 10,
                                                  bottom: 15.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Logout',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: ScreenSize
                                                                .screenWidth *
                                                            0.05,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    'Logout here!',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: ScreenSize
                                                              .screenWidth *
                                                          0.03,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons
                                                      .arrow_forward_ios_rounded),
                                                  onPressed: () {
                                                    Helper().removeStringFormSharePreferences(Helper.employeeCode);
                                                    Helper().removeStringFormSharePreferences(Helper.password);
                                                    Helper.logout = true;
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          AppId.LoginID);
                                                      ref
                                                          .read(navNotifier
                                                              .notifier)
                                                          .currentIndex(0);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
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
