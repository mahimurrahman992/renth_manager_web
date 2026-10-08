import 'package:get_it/get_it.dart';
import 'package:renth_manager/consts/consts.dart';
import 'package:renth_manager/controller/quick_tech_property_details_controller.dart';
import 'package:renth_manager/controller/quick_tech_property_room_store_controller.dart';

import 'controller/quick_tech_withdraw_controller.dart';

final locator = GetIt.instance;
void setUp (){
  locator.registerLazySingleton<DashboardController>(()=> DashboardController());
  locator.registerLazySingleton<AuthController>(()=> AuthController());
  locator.registerLazySingleton<CommonController>(()=> CommonController());
  locator.registerLazySingleton<WithdrawController>(()=> WithdrawController());
  locator.registerLazySingleton<PropertyDetailsController>(()=> PropertyDetailsController());
  locator.registerLazySingleton<QuickTechPropertyRoomController>(()=> QuickTechPropertyRoomController());
  locator.registerLazySingleton<EditPropertyController>(()=> EditPropertyController());
  locator.registerLazySingleton<QuickTechRoomController>(()=> QuickTechRoomController());
  locator.registerLazySingleton<BookingOrderController>(()=> BookingOrderController());


}