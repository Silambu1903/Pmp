import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/id.dart';

import '../helper.dart';
import '../provider/navigation_provider.dart';
import '../provider/project_creation_provider/project_creation_provider.dart';
import '../res/screensize.dart';
import '../screen/director/project/project_stepper.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final currentIndex = ref.watch(navNotifier);
      return Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Container(
              margin:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 23),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.09,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(0);
                            },
                            icon: Icon(
                              Icons.home_rounded,
                              color: currentIndex == 0
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(1);
                            },
                            icon: Icon(
                              Icons.search,
                              color: currentIndex == 1
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox.fromSize(),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(2);
                            },
                            icon: Icon(
                              Icons.add_box_sharp,
                              color: currentIndex == 2
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(3);
                            },
                            icon: Icon(
                              Icons.person,
                              color: currentIndex == 3
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: ScreenSize.screenHeight * 0.038,
            left: MediaQuery.of(context).size.width * 0.37,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.085,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Container(
                margin: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      ref.refresh(projectCreationNotifierProvider);
                      ProjectStepper.allocationList.clear();
                      Navigator.pushNamed(context, AppId.PROJECT_CREATION_ID);
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
