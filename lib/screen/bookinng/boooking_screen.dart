import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/colors.dart';
import 'package:intl/intl.dart';
import 'package:pmp/res/screensize.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TimeOfDay startSelectedTime = TimeOfDay.now();
  TimeOfDay endSelectedTime = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController descripition = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.cream,
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Conference Hall Booking',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .width *
                                              0.02),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [],
                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10.0, right: 10.0, bottom: 5),
                      child: Card(
                        elevation: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 25),
                                child: SizedBox(
                                  width: ScreenSize.screenWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/booking.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 15.0, right: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: const [
                                          Text('Select date & Time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),)
                                        ],

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0),
                                        child: TextFormField(
                                            controller: dateController,
                                            textInputAction: TextInputAction
                                                .next,
                                            keyboardType: TextInputType
                                                .datetime,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'Date',
                                              hintText: 'DD-MM-YYYY',
                                              fillColor: Colors.white,
                                              isDense: true,
                                              filled: true,
                                              border: OutlineInputBorder(),
                                              suffixIcon: Icon(
                                                Icons.date_range_sharp,
                                              ),
                                            ),
                                            onTap: () async {
                                              DateTime? date = DateTime(1900);
                                              var inputFormat = DateFormat(
                                                  'dd-MM-yyyy');
                                              var outputFormat = DateFormat(
                                                  'yyyy-MM-dd');
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                  new FocusNode());
                                              date = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now()
                                                      .subtract(
                                                      Duration(days: 0)),
                                                  lastDate: DateTime(2100));
                                              dateController.text =
                                                  inputFormat.format(
                                                      outputFormat.parse(
                                                          date.toString()
                                                              .substring(
                                                              0, 10)));
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0),
                                        child: TextFormField(
                                            controller: startTimeController,
                                            textInputAction: TextInputAction
                                                .next,
                                            keyboardType: TextInputType
                                                .datetime,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'StartTime',
                                              hintText: 'HH:MM',
                                              fillColor: Colors.white,
                                              isDense: true,
                                              filled: true,
                                              border: OutlineInputBorder(),
                                              suffixIcon: Icon(
                                                Icons.timer_sharp,
                                              ),
                                            ),
                                            onTap: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              _selectStartTime(context);
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0),
                                        child: TextFormField(
                                            controller: endTimeController,
                                            textInputAction: TextInputAction
                                                .next,
                                            keyboardType: TextInputType
                                                .datetime,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            decoration: const InputDecoration(
                                              labelText: 'EndTime',
                                              hintText: 'HH:MM',
                                              fillColor: Colors.white,
                                              isDense: true,
                                              filled: true,
                                              border: OutlineInputBorder(),
                                              suffixIcon: Icon(
                                                Icons.timer_sharp,
                                              ),
                                            ),
                                            onTap: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              _selectEndTime(context);
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0),
                                        child: TextFormField(
                                          controller: descripition,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.name,
                                          inputFormatters: <TextInputFormatter>[
                                            LengthLimitingTextInputFormatter(
                                                25),
                                          ],
                                          decoration: const InputDecoration(
                                            labelText: 'Description',
                                            fillColor: Colors.white,
                                            isDense: true,
                                            filled: true,
                                            suffixIcon: Icon(
                                              Icons.message,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: ScreenSize.screenHeight * 0.05,
                                        child: MaterialButton(
                                          color: Colors.black,
                                          onPressed: () {},
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(4)),
                                          child: const Text(
                                            'Book',
                                            style:
                                            TextStyle(color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: startSelectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if (timeOfDay != null && timeOfDay != startSelectedTime) {
      return startTimeController.text = timeOfDay.hour.toString() + ' : '+ timeOfDay.minute.toString();
    }
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: startSelectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if (timeOfDay != null && timeOfDay != startSelectedTime) {
      return endTimeController.text = timeOfDay.hour.toString() + ' : '+ timeOfDay.minute.toString();
    }
  }
}
