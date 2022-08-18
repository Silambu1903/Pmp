import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pmp/model/projectcommentmodel.dart';
import 'package:pmp/res/colors.dart';
import 'package:pmp/res/screensize.dart';
import 'package:pmp/widgets/shimmer/shimmeruserlist.dart';

import '../../helper.dart';
import '../../provider/comment_provider.dart';
import '../../responsive/responsive.dart';

class CommentScreen extends ConsumerStatefulWidget {
  var projectId;
  String? projectName, projectCode, deliveryDate, status, totalHrs, des;


  CommentScreen(
      {Key? key,
      this.projectId,
      this.projectName,
      this.projectCode,
      this.deliveryDate,
      this.status,
      this.totalHrs,
      this.des,
      })
      : super(key: key);

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    ref.refresh(getCommentListNotifier(widget.projectId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.icon,
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 8,
                  child: ref
                      .watch(getCommentListNotifier(widget.projectId))
                      .when(data: (data) {
                    return data.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Scrollbar(
                                isAlwaysShown: true,
                                showTrackOnHover: false,
                                hoverThickness: 30.0,
                                child: ListView.builder(
                                    itemCount: data.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return itemBuilder(data[index]);
                                    }),
                              ),
                            ],
                          )
                        : const Center(
                            child: Text('No Comments,Please Add your Comment'));
                  }, error: (error, s) {
                    return Center(child: Text(error.toString()));
                  }, loading: () {
                    return ShimmerForUserList();
                  })),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.arrow_back_ios)),
                                Text(
                                  'Comments',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenSize.screenWidth * 0.015),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Project Name : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        widget.projectName.toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          overflow: TextOverflow.ellipsis,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Project Code : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      widget.projectCode.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery Date : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      widget.deliveryDate.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Status : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      widget.status.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Hrs : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      widget.totalHrs.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Description : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                widget.des.toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                controller: comment,
                                textInputAction: TextInputAction.done,
                                maxLines: 8,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  isDense: true,
                                  filled: true,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 20, left: 10, top: 5),
                                  labelText: 'Add Comment',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        ref
                                            .read(
                                                insertCommentNotifier.notifier)
                                            .insertCommentData(
                                                widget.projectId,
                                                Helper.sharedCreatedId,
                                                comment.text.toString());
                                        Future.delayed(
                                            const Duration(milliseconds: 1000),
                                            () {
                                          ref.refresh(getCommentListNotifier(
                                              widget.projectId));

                                          comment.clear();
                                        });
                                      },
                                      child: const Text('SAVE'),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(ScreenSize
                                                .screenHeight *
                                            0.07), // fromHeight use double.infinity as width and 40 is the height
                                      ),
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  itemBuilder(ProjectManagementProcessProjectComment data) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(data.userRegistration!.avatar!),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.userRegistration!.userName.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Text(
                            'comment on ' + data.date!.toString(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              data.comment.toString(),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
