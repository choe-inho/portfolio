import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/util/config/App_Constants.dart';

import '../../controller/App_Controller.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final constants = AppConstants.of(context);
    return Scaffold(
      body: Padding(
        padding: constants.,
        child: CustomScrollView(
          slivers: [

          ],
        ),
      ),
    );
  }
}
