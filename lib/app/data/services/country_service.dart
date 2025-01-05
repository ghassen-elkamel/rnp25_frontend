import '../models/entities/country.dart';
import '../models/entities/region.dart';
import '../providers/external/api_provider.dart';

class CountryService {
  Future<List<Country>> findAllCountries({bool withLoadingAlert = true}) async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/country",
        withLoadingAlert: withLoadingAlert
      ),
    );
    if (response != null) {
      return countryFromJson(response);
    }
    return [];
  }

  Future<List<Region>> findAllRegionsByCountry({required int? countryId,bool withLoadingAlert=true}) async {
    var response = await ApiProvider().get(
      HttpParamsGetDelete(
        endpoint: "/v1/region",
        queryParam: {'countryId': countryId.toString()},
        withLoadingAlert: withLoadingAlert
      ),
    );
    if (response != null) {
      return regionFromJson(response);
    }
    return [];
  }
}
