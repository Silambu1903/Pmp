import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return windowsUi(context);
  }

  windowsUi(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children:  [
                   Text('TimeSheet - ',style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.02),),
                   Text('April - 2022',style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.01),),
                   IconButton(onPressed: (){}, icon: const Icon(Icons.date_range_outlined))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
