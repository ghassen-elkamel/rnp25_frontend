const String appName = "RNP";
const String protocol = String.fromEnvironment('PROTOCOL');
const String host = String.fromEnvironment('HOST');
final int? port = int.tryParse(const String.fromEnvironment('PORT').toString());

const String apiPrefix = "/api";
final String hostPath = "$protocol://$host${port == null ? "" : ":$port"}";

final String downloadTransactionQrPath =
    "$hostPath$apiPrefix/v1/transfer-request";

final String hostPhoto = "$hostPath/api/public/image";
const String uploads = "uploads";
final String hostUploadPhotoNews = "$hostPath$apiPrefix/v1/news/uploads/news";
final String hostUploadPhotoProfile =
    "$hostPath$apiPrefix/v1/users/uploads/profiles";

final String hostCompanyPhotos = "$hostPath$apiPrefix/v1/company/company-photo";

const Duration timeoutDuration = Duration(seconds: 30);

//Local Storage
const String storageGlobalKey = appName;
const String storageAccessUserKey = "accessUser";

const String storageLocaleKey = "locale";

const double appBarHeight = 100;

const String stripePublishableKey =
    "pk_test_51NNBjbItp882xOIgPx2g4BrTQymvsP9r4NYY6U0315ucGZzXOKPpQSteWnzjRioLwBRRk3kq4Ax5dr8bVnQsBk7300k5EtV5U0";
const String contactUrl = "https://mypartner-isc.com/contact";
const String termsOfUseUrl =
    "https://policy.mypartner-isc.com/exchange-terms-conditions";

const String currencyAbbreviation = "LYD";
const String secondCurrencyAbbreviation = "Pts";
const numberOfDaysStatistic = 5;
const String loginBackground = "login.png";
