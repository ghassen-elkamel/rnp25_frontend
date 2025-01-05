import 'package:eco_trans/app/core/extensions/map/map_extension.dart';
import '../models/entities/car.dart';
import '../models/entities/user.dart';
import '../providers/external/api_provider.dart';

class CarService {

  Future<List<Car>> getAll() async {
    final response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/car/all",
        withLoadingAlert: false
      ),
    );
    if (response.containsKeyNotNull('items')) {
      return carsFromJson(response);
    }
    return [];
  }

  Future<Car?> createOrUpdate({required Car item}) async {
    if (item.id != null) {
      return await update(item: item);
    }
    return await create(item: item);
  }
  
  Future<Car?> create({
    required Car item,
    bool withLoadingAlert = true,
  }) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/car",
        body: item.toJson(),
        withLoadingAlert: withLoadingAlert,
      ),
    );
    if (response != null) {
      return Car.fromJson(response,);
    }
    return null;
  }

  Future<Car?> update({required Car item}) async {
    var response = await ApiProvider().patch(
      HttpParamsPostPut(
        endpoint: "/v1/car",
        body: item.toJson(),
      ),
    );

    if (response != null) {
      return Car.fromJson(response);
    }
    return null;
  }

  Future<bool> deleteItem([
    int? id,
  ]) async {
    var response = await ApiProvider().delete(
      HttpParamsGetDelete(
        endpoint: "/v1/car${id == null ? "" : "/$id"}",
      ),
    );
    return response != null;
  }

  updateAffectedDriver({required int? id, required List<User> usersId}) async {
    var response = await ApiProvider().post(
      HttpParamsPostPut(
        endpoint: "/v1/car/affect-driver/$id",
        body: {
          "usersId": usersId.map((e) => e.id,).whereType<int>().toList(),
        },
        withLoadingAlert: true,
      ),
    );
    if (response != null) {
      return true;
    }
    return false;
  }

}
