import 'package:get/get.dart';
import 'package:portfolio/model/Project.dart';

class ProjectsController extends GetxController{
  RxBool projectsFetch = false.obs;
  List<Project>? projects;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


}