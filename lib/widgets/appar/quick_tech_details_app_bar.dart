
import '../../consts/consts.dart';

Widget quickTechDetailsAppBar({String? title}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Container(
          height: 38.h,
          width: 38.h,
          decoration: BoxDecoration(shape: BoxShape.circle,color: mainColor),
          child: Icon(Icons.arrow_back_sharp,size: 30.h,),
        ),
      ),
      Text(title?? 'Room Categories & Details',style: QuickTechAppTextStyle.headline4(),),
      SizedBox()
    ],);
}