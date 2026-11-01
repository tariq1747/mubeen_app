import 'package:get/get.dart';
import 'app_routes.dart';
import '../bindings/home_binding.dart';
import '../bindings/create_group_binding.dart';
import '../bindings/edit_group_binding.dart';
import '../bindings/group_details_binding.dart';
import '../bindings/add_participant_binding.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/screens/create_group/create_group_screen.dart';
import '../ui/screens/edit_group/edit_group_screen.dart';
import '../ui/screens/group_details/group_details_screen.dart';
import '../ui/screens/add_participant/add_participant_screen.dart';

/// Central GetX route table: every screen, paired with the binding that
/// creates its controller.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.home;

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.home, page: () => const HomeScreen(), binding: HomeBinding()),
    GetPage(name: AppRoutes.createGroup, page: () => const CreateGroupScreen(), binding: CreateGroupBinding()),
    GetPage(name: AppRoutes.editGroup, page: () => const EditGroupScreen(), binding: EditGroupBinding()),
    GetPage(name: AppRoutes.groupDetails, page: () => const GroupDetailsScreen(), binding: GroupDetailsBinding()),
    GetPage(
      name: AppRoutes.addParticipant,
      page: () => const AddParticipantScreen(),
      binding: AddParticipantBinding(),
    ),
  ];
}
