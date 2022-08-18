import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../res/ScreenSize.dart';
import '../../../res/colors.dart';

class UpdateProject extends StatefulWidget {
  const UpdateProject({Key? key}) : super(key: key);

  @override
  _UpdateProjectState createState() => _UpdateProjectState();
}

class _UpdateProjectState extends State<UpdateProject> {
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primary,
        body: mobileUi(context),
      ),
    );
  }

  Widget mobileUi(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 50.0, bottom: 15),
                            child: Text(
                              "Update Project",
                              style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: ScreenSize.screenWidth * 0.075,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: SvgPicture.asset(
                              'assets/project_creation.svg',
                              width: ScreenSize.screenWidth * 0.15,
                              height: ScreenSize.screenHeight * 0.15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0)),
            ),
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10.0, right: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Project Name',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Project Code',
                            suffixIcon: Icon(
                              Icons.list,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          width: ScreenSize.screenWidth,
                          height: MediaQuery.of(context).size.height * 0.09,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                iconSize: 24,
                                elevation: 16,
                                hint: const Text('Project is Active'),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {});
                                },
                                items: <String>[
                                  'Yes',
                                  'No',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Delivery Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.date_range_sharp,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          width: ScreenSize.screenWidth,
                          height: ScreenSize.screenWidth * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: AppColors.primary,
                            boxShadow: [
                              const BoxShadow(
                                  offset: Offset(10, 10),
                                  color: Colors.black38,
                                  blurRadius: 20),
                              BoxShadow(
                                  offset: Offset(-5, -5),
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 20)
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    left: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Project Owners',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ScreenSize.screenWidth * 0.05),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: IconButton(
                                          onPressed: () {
                                            mobileDialog(context);
                                          },
                                          icon: const Icon(
                                            Icons.add_box_rounded,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Divider(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                flex: 6,
                                child: ListView.builder(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 70.0,
                                              height: 70.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      "https://images.unsplash.com/photo-1597466765990-64ad1c35dafc"),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 5.0),
                                              child: Text(
                                                'Mobile Team',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(
                          maxLines: 5,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            isDense: true,
                            filled: true,
                            contentPadding:
                                EdgeInsets.only(bottom: 20, left: 10, top: 5),
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: ElevatedButton(
                                onPressed: () {},
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
    );
  }

  mobileDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  title: const Text('Add Team'),
                  actions: <Widget>[
                    Container(
                      width: ScreenSize.screenWidth,
                      height: MediaQuery.of(context).size.height * 0.09,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            iconSize: 24,
                            elevation: 16,
                            hint: const Text('Department'),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {});
                            },
                            items: <String>[
                              'Yes',
                              'No',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Planned Hours',
                          suffixIcon: Icon(
                            Icons.timer,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('ADD'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                              0.07), // fromHeight use double.infinity as width and 40 is the height
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
