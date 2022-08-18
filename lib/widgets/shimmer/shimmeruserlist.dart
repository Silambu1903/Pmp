import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerForUserList extends StatelessWidget {
  ShimmerForUserList({Key? key}) : super(key: key);
  int _offSet = 0;
  int _time = 800;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3, // list length
      itemBuilder: (context, index) {
        print("Rebuilding ...");
        _offSet += 20;
        _time = 800 + _offSet;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,

                          ),
                        ),
                        Expanded(child: Container()),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
