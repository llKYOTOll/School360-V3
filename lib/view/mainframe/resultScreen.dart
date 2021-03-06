import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school360/controller/appdataController.dart';
import 'package:school360/controller/resultController.dart';
import 'package:school360/widgets/buttonLoadingAnimation.dart';
import 'package:school360/widgets/customSnackBar.dart';
import 'package:school360/widgets/loadingAnimation.dart';
import 'package:school360/widgets/result.dart';

import '../../constants/colors.dart';
import '../../constants/dimentions.dart';
import '../../constants/textStyle.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isButtonLoading = false;
  ResultController resultController = Get.find();
  AppdataController appdataController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    if (!appdataController.showResultTranscript) {
      await resultController.getYearDropDownList();
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        appdataController.isResultScreenLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(appdataController.showResultTranscript);
    return Container(
      height: Get.height,
      width: Get.width,
      child: appdataController.isResultScreenLoading
          ? Center(child: GetLoadingAnimation())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getAppBar(),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: getGlobalPadding(),
                    child: Text(
                      "Pick a year",
                      style: headerTS.copyWith(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 32, left: 25),
                    alignment: Alignment.center,
                    margin: getGlobalPadding(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: secondaryColor.withOpacity(.2),
                        width: 1,
                      ),
                    ),
                    // color: Colors.red,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: Colors.white,
                          style: defaultTS,
                          isExpanded: false,
                          elevation: 4,
                          alignment: Alignment.center,
                          value: resultController.selectedYear,
                          items: resultController.years
                              .map(buildMonthMenuItem)
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              resultController.selectedYear = value as String;
                            });
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (resultController.selectedYear != "Select year") {
                        setState(() {
                          isButtonLoading = true;
                        });
                        await resultController.getResult();
                        await Future.delayed(Duration(seconds: 2));
                        setState(() {
                          isButtonLoading = false;
                          appdataController.showResultTranscript = true;
                        });
                      } else {
                        showSnackbar(
                            title: "Error",
                            message: "Please select a valid year");
                      }
                    },
                    child: Container(
                      height: 45,
                      width: Get.width,
                      margin: getGlobalPadding(),
                      decoration: BoxDecoration(
                        color: Color(0xffEF7C8E),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: secondaryColor.withOpacity(.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: isButtonLoading
                            ? CustomLoadingAnimation(
                                loadingColor: scaffoldBackgroundColor,
                              )
                            : Text(
                                'Load',
                                style: headerTS.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: scaffoldBackgroundColor,
                                    letterSpacing: 1),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  appdataController.showResultTranscript
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: getGlobalPadding(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Report",
                                    style: headerTS,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            resultController.dataModelForResult != null &&
                                    resultController
                                            .dataModelForResult!.status !=
                                        "error"
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: resultController
                                        .dataModelForResult!.resultInfo!.length,
                                    itemBuilder: (context, index) {
                                      return GetResult(
                                        index: index,
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: getGlobalPadding(),
                                    child: Text(
                                      "Stand by for updates...",
                                      style: defaultTS.copyWith(
                                        color: secondaryColor.withOpacity(.6),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
    );
  }

  DropdownMenuItem<String> buildMonthMenuItem(String month) => DropdownMenuItem(
        value: month,
        child: Text(month),
      );

  Container getAppBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(top: 15),
      margin: getGlobalPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Transcript",
            style: headerTS,
          ),
          // InkWell(
          //   onTap: () {
          //     Get.toNamed(Routes.getAnnouncementScreenRoute);
          //   },
          //   child: Icon(
          //     FontAwesomeIcons.book,
          //   ),
          // ),
        ],
      ),
    );
  }
}
