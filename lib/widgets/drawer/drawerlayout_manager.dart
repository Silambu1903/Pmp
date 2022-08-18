import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helper.dart';
import '../../provider/navigation_provider.dart';
import '../../provider/user_creation/user_creation_provider.dart';
import '../../res/ScreenSize.dart';
import '../../res/colors.dart';
import '../../res/id.dart';

class DrawerLayoutManager extends StatefulWidget {





  static String? currentPage;
  int? lastSelectedIndex;

  @override
  _DrawerLayoutState createState() => _DrawerLayoutState();
}

class _DrawerLayoutState extends State<DrawerLayoutManager> {



  Widget drawerLayout(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0,top: 15,bottom: 5,right: 5),
        child: Consumer(builder: (context, ref, child) {
          final currentIndex = ref.watch(navNotifier);
          return Column(
            children: [
              Expanded(
                  flex: 1,
                  child:Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(Helper.sharedAvatar),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Helper.shareduserName.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenSize.screenWidth * 0.01),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Helper.sharedEmployeeCode.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenSize.screenWidth * 0.01),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text(
                                'General Menu',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
                            onTap: (){
                              ref.read(navNotifier.notifier).currentIndex(0);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8),bottomRight:Radius.circular(8) ),
                                    color: currentIndex == 0
                                        ? AppColors.bg
                                        : Colors.white,

                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.home_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0,left: 6.0),
                                  child: Text(
                                    'Dashboard',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
                            onTap: (){
                              ref.read(navNotifier.notifier).currentIndex(1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8),bottomRight:Radius.circular(8) ),
                                    color: currentIndex == 1
                                        ? AppColors.bg
                                        : Colors.white,

                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0,left: 6.0),
                                  child: Text(
                                    'Projects',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
                            onTap: (){
                              ref.read(navNotifier.notifier).currentIndex(2);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight:const Radius.circular(8) ),
                                    color: currentIndex == 2
                                        ? AppColors.bg
                                        : Colors.white,

                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.add_to_photos_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0,left: 6.0),
                                  child: Text(
                                    'Create Users',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
                            onTap: (){
                              ref.read(navNotifier.notifier).currentIndex(4);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8),bottomRight:Radius.circular(8) ),
                                    color: currentIndex == 4
                                        ? AppColors.bg
                                        : Colors.white,

                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.date_range_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0,left: 6.0),
                                  child: Text(
                                    'Conference Booking',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Text(
                                'Settings Menu',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
                            onTap: (){
                              ref.refresh(getCurrentUser);
                              ref.read(navNotifier.notifier).currentIndex(3);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8),bottomRight:Radius.circular(8) ),
                                    color: currentIndex == 3
                                        ? AppColors.bg
                                        : Colors.white,

                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.settings_applications_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0,left: 6.0),
                                  child: Text(
                                    'Profile Settings',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: InkWell(
                            onTap: (){
                              Helper().removeStringFormSharePreferences(Helper.employeeCode);
                              Helper().removeStringFormSharePreferences(Helper.password);
                            //  Helper.logout = true;
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration:  const BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight:Radius.circular(8) ),
                                    color:
                                         Colors.white,

                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.logout_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2.0,left: 6.0),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  )),
            ],
          );
        }),
      ),
    );
  }

  //drawerItem

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Container(
        color: AppColors.cream,
        child: drawerLayout(context));
  }
}
