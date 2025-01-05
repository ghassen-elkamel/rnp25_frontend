# eco trans
## Build AAB PROD
```fvm flutter build appbundle --release --dart-define=PROTOCOL=https --dart-define=HOST=stg-trans.mypartner-isc.com```

## Build apk PROD
```fvm flutter build apk --release --dart-define=PROTOCOL=https --dart-define=HOST=stg-trans.mypartner-isc.com```

## Build apk DEV
```fvm flutter build apk --release --dart-define=PROTOCOL=https --dart-define=HOST=dev-trans.mypartner-isc.com```

## Run local
```fvm flutter run --dart-define=PROTOCOL=http --dart-define=PORT=4000 --dart-define=HOST=localhost```

## Run dev
```fvm flutter run --dart-define=PROTOCOL=https --dart-define=HOST=dev-trans.mypartner-isc.com```

## Build apk DEV
```fvm flutter build apk --release --dart-define=PROTOCOL=https --dart-define=HOST=dev-trans.mypartner-isc.com```

## Fix errors
# POD
rm -Rf ios/Pods                                                                                             
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec
rm -Rf ios/Podfile.lock
pod install --repo-update

# Migration to IOS 17
renames all DT_TOOLCHAIN_DIR to TOOLCHAIN_DIR

