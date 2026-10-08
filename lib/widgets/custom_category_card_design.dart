import '../../consts/consts.dart';

Widget customCard(BuildContext context,String image,String count) {
  return Container(
    alignment: Alignment.bottomLeft,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        image: DecorationImage(
            image: NetworkImage("${Api.imageUrl}$image"), fit: BoxFit.fill)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.edit,
          color: Colors.black,
          size: 15,
        ),
        5.widthBox,
        count.text.sm.black.make()
      ],
    )
        .box
        .padding(EdgeInsets.symmetric(horizontal: 7, vertical: 5))
        .white
        .roundedSM
        .shadowSm
        .margin(EdgeInsets.all(6))
        .make(),
  );
}
