import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmp/res/screensize.dart';
import 'package:intl/intl.dart';
import '../../../helper.dart';
import '../../../model/project_management_project_creation.dart';
import '../../../model/projectmanagementdetails.dart';
import '../../../provider/changenotifier/widget_notifier.dart';
import '../../../provider/project_creation_provider/project_creation_provider.dart';
import '../../../res/colors.dart';

class ProjectUpdate extends ConsumerStatefulWidget {
  ProjectManagementProcessProjectCreationDetails? data;

  ProjectUpdate({this.data});

  @override
  _ProjectCreateState createState() => _ProjectCreateState();
}

class _ProjectCreateState extends ConsumerState<ProjectUpdate> {
  bool? is_active = false;
  TextEditingController plannedHrs = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController projectCode = TextEditingController();
  TextEditingController totalManHrs = TextEditingController();
  TextEditingController deliveryDate = TextEditingController();
  TextEditingController description = TextEditingController();

  String? plannedHrsStr,
      nameStr,
      projectCodeStr,
      totalManHrsStr,
      deliveryDateStr,
      descriptionStr;

  @override
  void initState() {
    if (widget.data != null) {
      plannedHrsStr = widget.data!.plannedHrs;
      nameStr = widget.data!.projectName;
      projectCodeStr = widget.data!.projectCode;
      totalManHrsStr = widget.data!.plannedHrs;
      deliveryDateStr = widget.data!.deliveryDate;
      descriptionStr = widget.data!.description;
      is_active = widget.data!.isActive;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'IsActive',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Consumer(builder: (context, ref, child) {
                  ref.watch(counterModelProvider);
                  return Checkbox(
                    checkColor: AppColors.primary,
                    activeColor: Colors.black,
                    value: is_active,
                    onChanged: (value) {
                      ref.read(counterModelProvider.notifier).press();
                      is_active = value!;
                    },
                  );
                }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: TextFormField(
                controller: name..text = nameStr.toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(25),
                ],
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  fillColor: Colors.white,
                  isDense: true,
                  filled: true,
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.person,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                controller: projectCode..text = projectCodeStr.toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: const InputDecoration(
                  labelText: 'Project Code',
                  fillColor: Colors.white,
                  isDense: true,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.list,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                controller: totalManHrs..text = totalManHrsStr.toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  /*LengthLimitingTextInputFormatter(4),*/
                ],
                decoration: const InputDecoration(
                  labelText: 'Total Man hrs',
                  fillColor: Colors.white,
                  isDense: true,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.timelapse_rounded,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                controller: deliveryDate..text = deliveryDateStr.toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Delivery Date',
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
                    var inputFormat = DateFormat('dd-MM-yyyy');
                    var outputFormat = DateFormat('yyyy-MM-dd');
                    FocusScope.of(context).requestFocus(new FocusNode());
                    date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 0)),
                        lastDate: DateTime(2100));
                    deliveryDate.text = inputFormat.format(outputFormat.parse(date.toString().substring(0,10)));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: TextFormField(
                controller: description..text = descriptionStr.toString(),
                textInputAction: TextInputAction.done,
                maxLines: 5,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  isDense: true,
                  filled: true,
                  contentPadding: EdgeInsets.only(bottom: 20, left: 10, top: 5),
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        if (validateField()) {
                          ref
                              .read(projectCreationNotifierProvider.notifier)
                              .getUpdateValue(
                                ProjectManagementProcessProjectCreation(
                                  id: widget.data!.id!,
                                  projectName: name.text.toString(),
                                  projectCode: projectCode.text.toString(),
                                  description: description.text.toString(),
                                  createDate: getDate(),
                                  updateDate: getDate(),
                                  isActive: is_active,
                                  deliveryDate: deliveryDate.text.toString(),
                                  plannedHrs: totalManHrs.text.toString(),
                                  departmentId: Helper.shareddepId,
                                ),
                              );
                        }
                      },
                      child: const Text('SAVE'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(ScreenSize.screenHeight *
                            0.07), // fromHeight use double.infinity as width and 40 is the height
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  bool validateField() {
    if (name.text.isEmpty) {
      displayErrorMessages('Project Name should not be empty');
      return false;
    } else if (projectCode.text.isEmpty) {
      displayErrorMessages('Project Code should not be empty');
      return false;
    } else if (totalManHrs.text.isEmpty) {
      displayErrorMessages('Enter the valid man hours');
      return false;
    } else if (deliveryDate.text.isEmpty) {
      displayErrorMessages('Delivery Date should not be empty');
      return false;
    } else if (description.text.isEmpty) {
      displayErrorMessages('Description  should not be empty');
      return false;
    } else if (description.text.length < 20) {
      displayErrorMessages('Enter minimum 20 characters in Description');
      return false;
    }
    return true;
  }

  displayErrorMessages(String errormessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errormessage)));
  }

  String getDate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }
}
