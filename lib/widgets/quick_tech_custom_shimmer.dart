import '../../consts/consts.dart';

Widget customShimmer(){
  return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.heightBox,
            Shimmer.fromColors(
              baseColor: mainColor.withValues(alpha: 0.8),
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 100.0,
                color: mainColor,
              ),
            ).box.rounded.clip(Clip.antiAlias).make(),
            16.heightBox,
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 150.0, height: 20.0, color: mainColor),
            ).box.rounded.clip(Clip.antiAlias).make(),
            8.heightBox,
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 100.0, height: 20.0, color: mainColor),
            ).box.rounded.clip(Clip.antiAlias).make(),
          ],
        ).animate().fadeIn(duration: 250.ms).move(
            begin: const Offset(300, 0),
            end: const Offset(0, 0),
            delay: (100 * index).ms,
            duration: 300.ms);
      });
}