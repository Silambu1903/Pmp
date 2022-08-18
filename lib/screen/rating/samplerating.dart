// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pmp/model/login_model.dart';
// import 'package:pmp/provider/ratingProvider.dart';
// import 'package:pmp/res/screensize.dart';
// import 'package:pmp/service/apiService.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import '../../model/ratingModel.dart';
// import '../../res/colors.dart';
// import '../../res/id.dart';
// import 'package:intl/intl.dart';
// import '../../responsive/responsive.dart';
//
// class SampleRating extends ConsumerStatefulWidget {
//   final ProjectManagementProcessUserRegistration? userListData;
//
//   const SampleRating({this.userListData, Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<SampleRating> createState() => _UserRatingState();
// }
//
// class _UserRatingState extends ConsumerState<SampleRating> {
//   final formKey = GlobalKey<FormState>();
//   var currentdate ;
//   @override
//   void initState() {
//     ref.read(ratingNotifierProvider.notifier).getRatingList();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenSize().init(context);
//
//     return Responsive.isDesktop(context)
//         ? windowUi(context)
//         : Responsive.isMobile(context)
//             ? mobileUi(context)
//             : windowUi(context);
//   }
//
//   mobileUi(BuildContext context) {
//     ProjectManagementProcessUserRegistration user = widget.userListData!;
//     return SafeArea(
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               floating: false,
//               pinned: true,
//               snap: false,
//               automaticallyImplyLeading: false,
//               expandedHeight: 190,
//               backgroundColor: Colors.black,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       color: Colors.black,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Text('User Information',
//                                     style: TextStyle(
//                                         fontSize:
//                                             ScreenSize.screenWidth * 0.045,
//                                         color: AppColors.white,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Row(
//                                     children: [
//                                       const Text('Name : ',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold)),
//                                       Text(user.userName.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontWeight: FontWeight.w500))
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Row(
//                                     children: [
//                                       const Text('Emp Code : ',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold)),
//                                       Text(user.employeCode.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontWeight: FontWeight.w500))
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Row(
//                                     children: [
//                                       const Text('Contact No : ',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold)),
//                                       Text(user.mobileNo.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontWeight: FontWeight.w500))
//                                     ],
//                                   ),
//                                 ),
//                                 Visibility(
//                                     visible: false,
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(top: 8.0),
//                                       child: Row(
//                                         children: [
//                                           const Text('Team : ',
//                                               style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold)),
//                                           Text('Dummy Team'.toString(),
//                                               style: const TextStyle(
//                                                   color: Colors.grey,
//                                                   fontWeight: FontWeight.w500))
//                                         ],
//                                       ),
//                                     )),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Row(
//                                     children: [
//                                       const Text('Email : ',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold)),
//                                       Text(user.email.toString(),
//                                           style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontWeight: FontWeight.w500))
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.date_range,
//                       ),
//                       iconSize: 50,
//                       onPressed: () async {
//                         DateTime? date = DateTime(1900);
//                         var inputFormat = DateFormat('dd-MM-yyyy');
//                         var outputFormat = DateFormat('yyyy-MM-dd');
//                         FocusScope.of(context)
//                             .requestFocus(new FocusNode());
//                         date = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate:
//                             DateTime.now().subtract(Duration(days: 0)),
//                             lastDate: DateTime(2100));
//                         if(date!=null){
//                           currentdate = inputFormat.format(outputFormat
//                               .parse(date.toString().substring(0, 10)));
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 Consumer(builder: (context, ref, child) {
//                   List<RatingModel> ratingList =
//                       ref.watch(ratingNotifierProvider);
//                   return Form(
//                     key: formKey,
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: ratingList.length,
//                         itemBuilder: (context, index) =>
//                             getRatingItem(ratingList, index)),
//                   );
//                 }),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (currentdate!=null) {
//                         updateRating(currentdate);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text("Please select the date")));
//                       }
//                     },
//                     child: const Text('RATE'),
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size.fromHeight(ScreenSize.screenHeight *
//                           0.07), // fromHeight use double.infinity as width and 40 is the height
//                     ),
//                   ),
//                 )
//               ]),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   windowUi(BuildContext context) {
//     ProjectManagementProcessUserRegistration user = widget.userListData!;
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Expanded(
//               flex: 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     color: Colors.black,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: const Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Colors.white,
//                                   )),
//                               Text('User Information',
//                                   style: TextStyle(
//                                       fontSize: ScreenSize.screenWidth * 0.02,
//                                       color: AppColors.white,
//                                       fontWeight: FontWeight.bold)),
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Row(
//                                   children: [
//                                     const Text('Name : ',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold)),
//                                     Text(user.userName.toString(),
//                                         style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Row(
//                                   children: [
//                                     const Text('Emp Code : ',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold)),
//                                     Text(user.employeCode.toString(),
//                                         style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Row(
//                                   children: [
//                                     const Text('Contact No : ',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold)),
//                                     Text(user.mobileNo.toString(),
//                                         style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                               ),
//                               Visibility(
//                                   visible: false,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(top: 8.0),
//                                     child: Row(
//                                       children: [
//                                         const Text('Team : ',
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold)),
//                                         Text('Dummy Team'.toString(),
//                                             style: const TextStyle(
//                                                 color: Colors.grey,
//                                                 fontWeight: FontWeight.w500))
//                                       ],
//                                     ),
//                                   )),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Row(
//                                   children: [
//                                     const Text('Email : ',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold)),
//                                     Text(user.email.toString(),
//                                         style: const TextStyle(
//                                             color: Colors.grey,
//                                             fontWeight: FontWeight.w500))
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 7,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           icon: const Icon(
//                             Icons.date_range,
//                           ),
//                           iconSize: 50,
//                           onPressed: () async {
//                             DateTime? date = DateTime(1900);
//                             var inputFormat = DateFormat('dd-MM-yyyy');
//                             var outputFormat = DateFormat('yyyy-MM-dd');
//                             FocusScope.of(context)
//                                 .requestFocus(new FocusNode());
//                             date = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate:
//                                     DateTime.now().subtract(Duration(days: 0)),
//                                 lastDate: DateTime(2100));
//                             if(date!=null){
//                               currentdate = inputFormat.format(outputFormat
//                                   .parse(date.toString().substring(0, 10)));
//
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     Consumer(builder: (context, ref, child) {
//                       List<RatingModel> ratingList =
//                           ref.watch(ratingNotifierProvider);
//                       return MasonryGridView.count(
//                           crossAxisCount: 3,
//                           mainAxisSpacing: 4,
//                           crossAxisSpacing: 4,
//                           shrinkWrap: true,
//                           itemCount: ratingList.length,
//                           itemBuilder: (BuildContext ctx, index) {
//                             return getRatingItem(ratingList, index);
//                           });
//                     }),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//         bottomNavigationBar: Padding(
//           padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               SizedBox(
//                 width: 300,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if(currentdate!=null){
//                       updateRating(currentdate);
//                     }else{
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("Please select the date")));
//                     }
//
//                   },
//                   child: const Text('RATE'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size.fromHeight(ScreenSize.screenHeight *
//                         0.07), // fromHeight use double.infinity as width and 40 is the height
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   getRatingItem(List<RatingModel> item, int index) {
//     double rate = item[index].givenValue!;
//     return Container(
//       color: AppColors.white,
//       margin: const EdgeInsets.all(5),
//       padding: const EdgeInsets.all(3.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Row(
//                   children: [
//                     Text(
//                       item[index].title == null
//                           ? ""
//                           : item[index].title.toString(),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 18),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: RatingBar.builder(
//                   initialRating: 0,
//                   minRating: 0,
//                   maxRating: 30,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   itemBuilder: (context, _) => const Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                   ),
//                   onRatingUpdate: (rating) {
//                     num value = 0;
//                     if (item[index].maxValue!.isNotEmpty) {
//                       value = int.parse(item[index].maxValue!);
//                     }
//                     var divide = value / 5;
//                     var multiple = rating * divide;
//
//                     changeRating(multiple, item, index);
//                   },
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   changeRating(double val, List<RatingModel> model, int index) {
//     model[index].setValue(val);
//     ref.read(ratingNotifierProvider.notifier).state = model;
//   }
//
//   void updateRating(var date) async {
//     bool status = false;
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Confirmation'),
//             content: Stack(
//               children: const [
//                 Text('You can\'t able to update it.\nAre you sure to submit?'),
//               ],
//             ),
//             actions: [
//               ElevatedButton(
//                   onPressed: () async {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('CANCEL')),
//               ElevatedButton(
//                   onPressed: () async {
//                     Navigator.pushNamed(
//                       context,
//                       AppId.DASHBOARD_SCREEN_ID,
//                     );
//                     status = await ref.read(apiProvider).updateRatingDate(
//                         widget.userListData!.id,date,widget.userListData!.departmentId!,widget.userListData!.teamId);
//
//                     if (status) {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text('Rating Updated Successfully')));
//                     }
//                   },
//                   child: const Text('CONFIRM'))
//             ],
//           );
//         });
//   }
// }
