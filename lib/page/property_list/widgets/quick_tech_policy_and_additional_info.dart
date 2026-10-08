
import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/controller/quick_tech_property_details_controller.dart';

class QuickTechPolicyAndAdditionalInfo extends StatelessWidget {
   QuickTechPolicyAndAdditionalInfo({super.key});
final controller  = locator.get<PropertyDetailsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(children: [
          12.verticalSpace,
          quickTechDetailsAppBar(title: 'Policy & Additional Info'),
          Expanded(child: Column(children: [
            70.verticalSpace,
            customTextField(
              hint: 'Check In Time',
              isSuffix: false,
              isVisible: true,
            ),
            12.verticalSpace,
            customTextField(
              hint: 'Check Out Time',
              isSuffix: false,
              isVisible: true,
            ),
            12.verticalSpace,
            customTextField(
              hint: 'Cancellation Policy',
              isSuffix: false,
              isVisible: true,
            ),
            12.verticalSpace,
            customTextField(
              hint: 'Children Policy',
              isSuffix: false,
              isVisible: true,
            ),
            12.verticalSpace,
            customTextField(
              hint: 'Pet Policy',
              isSuffix: true,
              isVisible: true,
              enabled: false,
              keyboard: TextInputType.number,
              suIcon: Icons.arrow_drop_down,
              supColor: Colors.black,
            ),
            12.verticalSpace,
            customTextField(
              hint: 'Smoking Policy',
              isSuffix: true,
              isVisible: true,
              enabled: false,
              keyboard: TextInputType.number,
              suIcon: Icons.arrow_drop_down,
              supColor: Colors.black,
            ),
            12.verticalSpace,
           Obx(()=> Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text(
                 "Verified Status",
                 style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.w600,
                 ),
               ),

               Row(
                 children: [
                   Text(
                     "Unverified",
                     style: TextStyle(
                       fontSize: 14,
                       color:
                       controller.isVerified.value ? Colors.grey : Colors.black,
                     ),
                   ),

                   Switch(
                     value: controller.isVerified.value,


                     // activeThumbColor: mainColor,
                     activeTrackColor: Colors.black,

                     onChanged: (value) {
                       controller.isVerified.value = value;
                     },
                   ),

                   Text(
                     "Verified",
                     style: TextStyle(
                       fontSize: 14,
                       color:
                       controller.isVerified.value ? Colors.black : Colors.grey,
                     ),
                   ),
                 ],
               ),
             ],
           ),),

            12.verticalSpace,

            Obx(()=>Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: controller.isChecked.value,
                  onChanged: (v) {
                    controller.isChecked.value = v ?? false;
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "By creating an account you agree to our ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "terms of services",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber[600],
                          ),
                        ),
                        const TextSpan(
                          text: " and ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "privacy policy.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
20.verticalSpace,
            customButton2(title:'Publish',icon: Icons.upload_file)
          ],))
        ],),
      )),
    );
  }
}
