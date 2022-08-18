import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerForProjectList extends StatelessWidget {
    ShimmerForProjectList({Key? key}) : super(key: key);
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
              color: Colors.white,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        );
      },
    );
  }
}
