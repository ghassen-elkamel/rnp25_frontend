import 'package:eco_trans/app/data/enums/car_status.dart';
import 'package:eco_trans/app/data/enums/car_type.dart';
import 'package:eco_trans/app/data/enums/order.dart';
import 'package:eco_trans/app/data/enums/role_type.dart';
import 'package:eco_trans/app/data/models/entities/user.dart';
import 'package:eco_trans/app/data/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/entities/car.dart';
import '../../../data/services/car_service.dart';

class CarsController extends GetxController {
  CarService carService = CarService();
  UserService userService = UserService();

  RxBool isLoading = false.obs;

  List<Car> originItems = [];
  RxList<Car> items = <Car>[].obs;

  TextEditingController search = TextEditingController();

  TextEditingController brand = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController registrationNumber = TextEditingController();
  Rx<CarType> selectedCarType = Rx(CarType.taxi);
  Rx<CarStatus> selectedCarStatus = Rx(CarStatus.available);
  List<User> selectedDrivers = [];
  RxList<User> users = <User>[].obs;

  @override
  void onInit() async {
    isLoading.value = true;

    List result = await Future.wait(
      [
        userService.findAllByRole(
          roles: [RolesType.driver],
        ),
        loadData(false),

      ],
    );
    users.value = result[0];
    isLoading.value = false;
    super.onInit();
  }

  Future<void> loadData([bool withLoading = true]) async {
    if (withLoading) {
      isLoading.value = true;
    }
    originItems = await carService.getAll();
    searchItems();
    if (withLoading) {
      isLoading.value = false;
    }
  }

  searchItems() {
    items.value = originItems.where((item) {
      return item.fullData().toLowerCase().contains(search.text.toLowerCase());
    }).toList();
  }

  orderByFullName(Order order) {
    items.value.sort(
      (a, b) {
        int compareResult = 1;
        compareResult = a.fullName.compareTo(b.fullName);
        if (order == Order.DESC) {
          compareResult = compareResult * -1;
        }

        return compareResult;
      },
    );
    items.refresh();
  }

  orderByCode(Order order) {
    items.value.sort(
      (a, b) {
        int compareResult = 1;
        if (a.internalCode != null && b.internalCode != null) {
          compareResult = a.internalCode!.compareTo(b.internalCode!);
        }
        if (order == Order.DESC) {
          compareResult = compareResult * -1;
        }

        return compareResult;
      },
    );
    items.refresh();
  }

  Future<bool> addUpdateItem({Car? oldItem}) async {
    Car? car = Car(
      id: oldItem?.id,
      model: model.text,
      brand: brand.text,
      registrationNumber: registrationNumber.text,
      carType: selectedCarType.value,
      status: selectedCarStatus.value,
    );
    car = await carService.createOrUpdate(item: car);
    if (car == null) {
      return false;
    }
    loadData();
    return true;
  }

  Future<void> updateAffectedDriver(Car item) async {
    bool isUpdated = await carService.updateAffectedDriver(
      id: item.id,
      usersId: selectedDrivers,
    );
    if (isUpdated) {
      Get.back();
      loadData();
    }
  }

  Future<void> deleteItem(Car item) async {
    bool isUpdated = await carService.deleteItem(
      item.id,
    );
    if (isUpdated) {
      Get.back();
      loadData();
    }
  }
}
