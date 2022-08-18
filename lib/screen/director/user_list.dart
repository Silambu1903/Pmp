import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pmp/helper.dart';
import 'package:pmp/provider/created_user_provider/created_user_list_provider.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/id.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/screen/dpi_rating/dpi_rating_screen.dart';
import 'package:pmp/screen/rating/samplerating.dart';
import 'package:pmp/service/apiService.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../model/login_model.dart';
import '../../provider/changenotifier/dataSuccess_notifier.dart';
import '../../responsive/responsive.dart';
import '../../widgets/shimmer/shimmeruserlist.dart';
import '../pofilescreen/general/general_settinngs_screen.dart';
import '../rating/userRating.dart';

class UserList extends ConsumerStatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends ConsumerState<UserList> {
  TextEditingController searchtextController = TextEditingController();

  @override
  void initState() {
    ref.refresh(userListStateProvider);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void deleteUser(
      BuildContext context, ProjectManagementProcessUserRegistration user) {
    ref.read(apiProvider).deleteUser(user.employeCode.toString());
  }

  void updateUser(ProjectManagementProcessUserRegistration user) {
    ref.read(dataChangeNotifier.notifier).callBack('');
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: AppId.GENERAL_SETTINGS__SCREEN_ID),
        builder: (context) => GeneralSettingScreen(
          mUser: user,
          userList: 'userListScreen',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return ref.watch(userListStateProvider).when(data: (data) {
      return Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: SizedBox(
                height: ScreenSize.screenHeight * 0.05,
                child: TextField(
                  controller: searchtextController,
                  onChanged: (value) {
                    filterSearchResults(value, data);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchtextController.text = "";
                        filterSearchResults("", data);
                      },
                    ),
                    hintText: 'Search...',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 35,
                      child: MaterialButton(
                        color: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppId.CREATE_USER_SCREEN_ID,
                          );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Create User",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Visibility(
                visible: data.isEmpty ? true : false,
                child: const Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Expanded(
            flex: 7,
            child: Responsive.isDesktop(context)
                ? MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: data.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return itemBuilderWindows(data[index]);
                    })
                : Responsive.isMobile(context)
                    ? ListView.builder(
                        itemCount: data.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return itemBuilder(data[index]);
                        })
                    : MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                          itemCount: data.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return itemBuilderWindows(data[index]);
                        }),
          ),
        ],
      );
    }, error: (e, s) {
      return const Center(
        child: Text('Try Again'),
      );
    }, loading: () {
      return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.cream,
              appBar: AppBar(
                title: const Text('Assign'),
              ),
              body: ShimmerForUserList()));
    });
  }

  Widget itemBuilder(ProjectManagementProcessUserRegistration userListData) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              updateUser(userListData);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.add_box,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteUser(context, userListData);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: SizedBox(
          child: InkWell(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 12.0, right: 12.0, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(userListData.avatar),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userListData.userName!,
                                  style: TextStyle(
                                      color: userListData.isActive == true
                                          ? Colors.black
                                          : Colors.red,
                                      fontSize: ScreenSize.screenWidth * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Helper.filterDepartment[
                                      userListData.departmentId],
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenSize.screenWidth * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      bool data = await ref
                                          .read(apiProvider)
                                          .checkRatingDate(userListData
                                          .id);
                                      if (data == false) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            settings: RouteSettings(
                                                name: AppId.RATING_SCREEN_ID),
                                            builder: (context) => DPIRatingScreen(
                                                userListData: userListData),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(
                                                'Already rating given for ' +
                                                    userListData
                                                        .userName!)));
                                      }
                                    },
                                    child: const Icon(
                                      Icons.star,
                                      size: 35.0,
                                      color: AppColors.primary,
                                    )),
                              ],
                            )),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemBuilderWindows(
      ProjectManagementProcessUserRegistration userListData) {

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              updateUser(userListData);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.add_box,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteUser(context, userListData);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: SizedBox(
          child: InkWell(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12.0, left: 12.0, right: 12.0, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(userListData.avatar),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userListData.userName!,
                                  style: TextStyle(
                                      color: userListData.isActive == true
                                          ? Colors.black
                                          : Colors.red,
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  Helper.filterDepartment[
                                      userListData.departmentId],
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenSize.screenWidth * 0.01,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      bool data = await ref
                                          .read(apiProvider)
                                          .checkRatingDate(userListData.id);
                                      if (data ==false) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            settings: RouteSettings(
                                                name: AppId.RATING_SCREEN_ID),
                                            builder: (context) => DPIRatingScreen(
                                                userListData: userListData),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Already rating given for ' +
                                                        userListData
                                                            .userName!)));
                                      }
                                    },
                                    child: const Icon(
                                      Icons.star,
                                      size: 35.0,
                                      color: AppColors.primary,
                                    )),
                              ],
                            )),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void doNothing(BuildContext context) {}

  void filterSearchResults(
      String value, List<ProjectManagementProcessUserRegistration> userList) {
    List<ProjectManagementProcessUserRegistration> results = [];
    if (value.isEmpty) {
      results = userList;
    } else {
      results = userList
          .where((user) => user.userName
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    }
    userList = results;
    setState(() {
      userList = results;
    });
  }
}
