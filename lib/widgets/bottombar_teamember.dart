import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/id.dart';

import '../helper.dart';
import '../provider/navigation_provider.dart';
import '../provider/project_creation_provider/project_creation_provider.dart';
import '../res/screensize.dart';

class BottomBarTeamMember extends StatefulWidget {
  const BottomBarTeamMember({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBarTeamMember> {
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
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(0);
                            },
                            icon: Icon(
                              Icons.home,
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
                          child: IconButton(
                            onPressed: () {
                              ref.read(navNotifier.notifier).currentIndex(2);

                            },
                            icon: Icon(
                              Icons.person,
                              color: currentIndex == 2
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
        ],
      );
    });
  }
}
