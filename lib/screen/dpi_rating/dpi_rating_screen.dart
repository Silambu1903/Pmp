import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/dpi_rating_list_model.dart';
import 'package:pmp/service/apiService.dart';
import 'package:pmp/widgets/shimmer/shimmerprojectlist.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../helper.dart';
import '../../helper/applicationhelper.dart';
import '../../model/dpi_add_rating_model.dart';
import '../../model/login_model.dart';
import '../../model/spi_creation_model.dart';
import '../../provider/dailytaskprovider/daily_task_provider.dart';
import '../../provider/ratingproider/useratingprovider.dart';
import '../../res/ScreenSize.dart';
import '../../res/colors.dart';
import '../../res/id.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../responsive/responsive.dart';

class DPIRatingScreen extends ConsumerStatefulWidget {
  final ProjectManagementProcessUserRegistration? userListData;

  const DPIRatingScreen({this.userListData, Key? key}) : super(key: key);

  @override
  ConsumerState<DPIRatingScreen> createState() => _DPIRatingScreenState();
}

class _DPIRatingScreenState extends ConsumerState<DPIRatingScreen> {
  List<String> value = [];
  List<DpiAddRatingList> dpiList = [];
  var spiUserId, spiRatingValue = 0.0;
  var createdDate;

  @override
  void initState() {

    createdDate = ApplicationHelper().dateFormatter4(DateTime.now());
    value.clear();
    dpiList.clear();
    String currentDate = ApplicationHelper().dateFormatter4(DateTime.now());
    value.add(currentDate);
    value.add(widget.userListData!.id!);
    ref.refresh(dpiRatingListNotifier(value));
    super.initState();
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

  mobileUi(BuildContext context) {
    ProjectManagementProcessUserRegistration user = widget.userListData!;
    return Consumer(builder: (context, ref, child) {
      var state = ref.watch(ratingNotifier);
      if (state.error == 'initial') {
      } else {
        print('error');
      }
      state.id.when(
          data: (data) {
            if (data.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                Navigator.pushNamed(context, AppId.DASHBOARD_SCREEN_ID);
              });
            }
          },
          error: (error, s) {},
          loading: () {});
      return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                automaticallyImplyLeading: false,
                expandedHeight: 190,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('User Information',
                                      style: TextStyle(
                                          fontSize:
                                              ScreenSize.screenWidth * 0.045,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        const Text('Name : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(user.userName.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        const Text('Emp Code : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(user.employeCode.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        const Text('Monthly Performance: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(user.mobileNo.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: false,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            const Text('Yearly Performance : ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text('Dummy Team'.toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        const Text('Email : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(user.email.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ref.watch(dpiRatingListNotifier(value)).when(data: (data) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                            10.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Daily Performance Index ',
                                style: TextStyle(
                                    color: Colors.black,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.grey,
                                          offset: Offset(0, -1))
                                    ],
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) =>
                                getRatingItem(data[index], index)),
                        Padding(
                          padding: const EdgeInsets.all(
                            10.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Supervisors Performance Index ',
                                style: TextStyle(
                                    color: Colors.black,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.grey,
                                          offset: Offset(0, -1))
                                    ],
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: AppColors.white,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Smartness in work ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Dress code  ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'WorkStation Neatness ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Team Supports ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: RatingBar.builder(
                                      initialRating: 0.5,
                                      minRating: 0,
                                      maxRating: 5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        spiUserId = widget.userListData!.id;
                                        spiRatingValue = rating;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }, error: (error, s) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  }, loading: () {
                    return ShimmerForProjectList();
                  }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              var newDate =  DateTime(now.year, now.month , now.day-1);
                              bool data = await ref
                                  .read(apiProvider)
                                  .checkRatingDateSend(widget.userListData!.id,newDate.toString());
                              if (data == false) {
                                createdDate = ApplicationHelper().dateFormatter4((DateTime(now.year, now.month , now.day-1)));
                                value.clear();
                                value.add(newDate.toString());
                                value.add(widget.userListData!.id!);
                                ref.refresh(dpiRatingListNotifier(value));
                              } else {
                                createdDate = ApplicationHelper().dateFormatter4(DateTime.now());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Already rating given for ' +
                                          widget.userListData!.userName!,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text('Previous Date'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                                  0.07), // fromHeight use double.infinity as width and 40 is the height
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () async {
                              DateTime now = DateTime.now();
                              var newDate =  DateTime(now.year, now.month , now.day);
                              createdDate = ApplicationHelper().dateFormatter4(DateTime.now());
                              value.clear();
                              value.add(newDate.toString());
                              value.add(widget.userListData!.id!);
                              ref.refresh(dpiRatingListNotifier(value));
                            },
                            child: const Text('Current Date'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                                  0.07), // fromHeight use double.infinity as width and 40 is the height
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              if(validation(dpiList)){
                                for (var data in dpiList) {
                                  ref.read(apiProvider).insertDpi(
                                      data.userId,
                                      data.taskId,
                                      data.ratingValue,
                                      widget.userListData!.teamId!,
                                      widget.userListData!.departmentId!,createdDate);
                                }
                                ref.read(apiProvider).insertSpi(
                                    spiUserId,
                                    spiRatingValue,
                                    widget.userListData!.teamId!,
                                    widget.userListData!.departmentId!,createdDate);
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Update Successfully'),
                                  ));
                                  Navigator.pop(context);
                                });
                              }

                            },
                            child: const Text('RATE'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                                  0.07), // fromHeight use double.infinity as width and 40 is the height
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      );
    });
  }

  getRatingItem(DpiRatingDailyReport data, int index) {
    return Container(
      color: AppColors.white,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Project Name :  ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              Expanded(
                child: Text(
                  data.projectCreation!.projectName != null
                      ? data.projectCreation!.projectName.toString()
                      : '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Task Name :  ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              Expanded(
                child: Text(
                  data.taskAssign!.taskCreation != null
                      ? data.taskAssign!.taskCreation!.taskName.toString()
                      : '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Task Assign Hours  : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              Text(
                data.taskAssign!.taskAssignHrs != null
                    ? data.taskAssign!.taskAssignHrs!.toString() + ' hrs'
                    : '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.green),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Task Spent Hours  : ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),
              ),
              Text(
                data.spentHrs != null ? data.spentHrs!.toString() + ' hrs' : '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.red),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: RatingBar.builder(
                  initialRating: 0.1,
                  minRating: 0,
                  maxRating: 100,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    num value = rating;
                    double setValue = value * 20;
                    num dpiValue = 0;
                    dpiValue = data.projectCreation!.project_weightage! *
                        data.spentHrs! *
                        setValue /
                        (8 * 100);
                    dpiList[index].setRatingId(dpiValue);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  windowUi(BuildContext context) {
    ProjectManagementProcessUserRegistration user = widget.userListData!;
    return Consumer(builder: (context, ref, child) {
      var state = ref.watch(ratingNotifier);
      if (state.error == 'initial') {
      } else {
        print('error');
      }
      state.id.when(
          data: (data) {
            if (data.isNotEmpty) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                Navigator.pushNamed(context, AppId.DASHBOARD_SCREEN_ID);
              });
            }
          },
          error: (error, s) {},
          loading: () {});
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    )),
                                Text('User Information',
                                    style: TextStyle(
                                        fontSize: ScreenSize.screenWidth * 0.02,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Text('Name : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(user.userName.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Text('Emp Code : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(user.employeCode.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Text('Contact No : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(user.mobileNo.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Text('Email : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(user.email.toString(),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Daily Performance Index ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            shadows: const [
                                              Shadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0, -1))
                                            ],
                                            decoration:
                                                TextDecoration.underline,
                                            decorationStyle:
                                                TextDecorationStyle.dashed,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                      )
                                    ],
                                  ),
                                ),
                                ref.watch(dpiRatingListNotifier(value)).when(
                                    data: (data) {
                                  for (var value in data) {
                                    dpiList.add(DpiAddRatingList(
                                        userId: value.userId,
                                        taskId: value.taskAssign!.id,
                                        ratingValue: 0));
                                  }
                                  return MasonryGridView.count(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return getRatingItem(
                                            data[index], index);
                                      });
                                }, error: (error, s) {
                                  return Container();
                                }, loading: () {
                                  return ShimmerForProjectList();
                                }),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Supervisors Performance Index ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            shadows: const [
                                              Shadow(
                                                  color: Colors.grey,
                                                  offset: Offset(0, -1))
                                            ],
                                            decoration:
                                                TextDecoration.underline,
                                            decorationStyle:
                                                TextDecorationStyle.dashed,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: AppColors.white,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: const [
                                          Text(
                                            'Smartness in work ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            'Dress code  ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            'WorkStation Neatness ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Text(
                                            'Team Supports ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RatingBar.builder(
                                              initialRating: 0.5,
                                              minRating: 0,
                                              maxRating: 5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                spiUserId =
                                                    widget.userListData!.id;
                                                spiRatingValue = rating;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      var newDate =  DateTime(now.year, now.month , now.day-1);
                         bool data = await ref
                          .read(apiProvider)
                          .checkRatingDateSend(widget.userListData!.id,newDate.toString());
                      if (data == false) {
                        createdDate = ApplicationHelper().dateFormatter4((DateTime(now.year, now.month , now.day-1)));
                        value.clear();
                        value.add(newDate.toString());
                        value.add(widget.userListData!.id!);
                        ref.refresh(dpiRatingListNotifier(value));
                      } else {
                        createdDate = ApplicationHelper().dateFormatter4(DateTime.now());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Already rating given for ' +
                                  widget.userListData!.userName!,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Previous Date'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                          0.07), // fromHeight use double.infinity as width and 40 is the height
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      var newDate =  DateTime(now.year, now.month , now.day);
                      createdDate = ApplicationHelper().dateFormatter4(DateTime.now());
                      value.clear();
                      value.add(newDate.toString());
                      value.add(widget.userListData!.id!);
                      ref.refresh(dpiRatingListNotifier(value));
                    },
                    child: const Text('Current Date'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                          0.07), // fromHeight use double.infinity as width and 40 is the height
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      if(validation(dpiList)){
                        for (var data in dpiList) {
                          ref.read(apiProvider).insertDpi(
                              data.userId,
                              data.taskId,
                              data.ratingValue,
                              widget.userListData!.teamId!,
                              widget.userListData!.departmentId!,createdDate);
                        }
                        ref.read(apiProvider).insertSpi(
                            spiUserId,
                            spiRatingValue,
                            widget.userListData!.teamId!,
                            widget.userListData!.departmentId!,createdDate);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Update Successfully'),
                          ));
                          Navigator.pop(context);
                        });
                      }

                    },
                    child: const Text('RATE'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                          0.07), // fromHeight use double.infinity as width and 40 is the height
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  bool validation(List<DpiAddRatingList> dpiList) {
    if (dpiList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text('No DPI records Found for the user '+ widget.userListData!.userName!.toUpperCase()+ ' | '+widget.userListData!.employeCode!),
      ));
      return false;
    }
    return true;
  }
}
