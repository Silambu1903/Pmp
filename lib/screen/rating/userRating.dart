import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/model/login_model.dart';
import 'package:pmp/model/ratingvalue.dart';
import 'package:pmp/provider/ratingProvider.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/service/apiService.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../model/ratingModel.dart';
import '../../provider/ratingproider/useratingprovider.dart';
import '../../res/colors.dart';
import '../../res/id.dart';
import '../../responsive/responsive.dart';

class UserRating extends ConsumerStatefulWidget {
  final ProjectManagementProcessUserRegistration? userListData;

  const UserRating({this.userListData, Key? key}) : super(key: key);

  @override
  ConsumerState<UserRating> createState() => _UserRatingState();
}

class _UserRatingState extends ConsumerState<UserRating> {
  final formKey = GlobalKey<FormState>();
  RatingValue? ratingModel = RatingValue();

  @override
  void initState() {
    ref.read(ratingNotifierProvider.notifier).getRatingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    ref.refresh(ratingNotifier);
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
                  Consumer(builder: (context, ref, child) {
                    List<RatingModel> ratingList =
                        ref.watch(ratingNotifierProvider);
                    return Form(
                      key: formKey,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ratingList.length,
                          itemBuilder: (context, index) =>
                              getRatingItem(ratingList, index)),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (validation()) {
                            updateRating(context);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please check the rating")));
                        }
                      },
                      child: const Text('RATE'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                            0.07), // fromHeight use double.infinity as width and 40 is the height
                      ),
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
                      Consumer(builder: (context, ref, child) {
                        List<RatingModel> ratingList =
                            ref.watch(ratingNotifierProvider);
                        return MasonryGridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            shrinkWrap: true,
                            itemCount: ratingList.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return getRatingItem(ratingList, index);
                            });
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      if (validation()) {
                        updateRating(context);
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

  getRatingItem(List<RatingModel> item, int index) {
    return Container(
      color: AppColors.white,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      item[index].title == null
                          ? ""
                          : item[index].title.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  maxRating: 30,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    num value = 0;
                    if (item[index].maxValue!.isNotEmpty) {
                      value = int.parse(item[index].maxValue!);
                    }
                    var divide = value / 5;
                    var multiple = rating * divide;
                    changeRating(multiple, item, index);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  changeRating(double val, List<RatingModel> model, int index) {
    if (model[index].title == 'Quality of Work') {
      ratingModel!.setValueQualityOfWork(val);
    } else if (model[index].title == 'On Time Delivery') {
      ratingModel!.setValueOnTimeDelivery(val);
    } else if (model[index].title == 'Smartness') {
      ratingModel!.setValueSmartness(val);
    } else if (model[index].title == 'Attitude') {
      ratingModel!.setValueAttitude(val);
    } else if (model[index].title == 'Workstation Neatness') {
      ratingModel!.setValueWorkstationNeatness(val);
    } else if (model[index].title == 'Punctuality') {
      ratingModel!.setValuePunctuality(val);
    }
  }

  void updateRating(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: Stack(
              children: const [
                Text('You can\'t able to update it.\nAre you sure to submit?'),
              ],
            ),
            actions: [
              Consumer(builder: (context, ref, child) {
                return ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'));
              }),
              ElevatedButton(
                  onPressed: () async {
                    num total = 0;
                    total = ratingModel!.attitude +
                        ratingModel!.workstation_neatness +
                        ratingModel!.smartness +
                        ratingModel!.on_time_delivery +
                        ratingModel!.punctuality +
                        ratingModel!.quality_of_work;
                    ref.read(ratingNotifier.notifier).insertRating(
                        empId: widget.userListData!.id,
                        depId: widget.userListData!.departmentId,
                        teamId: widget.userListData!.teamId,
                        ratingModel: ratingModel!,
                        total: total);
                    Navigator.pop(context);
                  },
                  child: const Text('CONFIRM'))
            ],
          );
        });
  }

  bool validation() {
    if (ratingModel!.attitude == null ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Rating for all'),
      ));
      return false;
    } else if (
    ratingModel!.smartness == null ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Rating for all'),
      ));
      return false;
    }else if (
    ratingModel!.on_time_delivery == null ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Rating for all'),
      ));
      return false;
    }else if (
    ratingModel!.quality_of_work == null ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Rating for all'),
      ));
      return false;
    }else if (
    ratingModel!.punctuality == null ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Rating for all'),
      ));
      return false;
    }else if (
    ratingModel!.workstation_neatness == null ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please Rating for all'),
      ));
      return false;
    }
    return true;
  }
}
