// import 'package:mapbox_search/mapbox_search.dart';
// import 'package:mapbox_search/mapbox_search.dart' as mbs;

// import 'package:pikquick/app_variable.dart';

// class MapboxGeocodingHandler {
//   Future<List<MapBoxPlace>?> searchAddress(String queryText) async {
//     final p = mbs.PlacesSearch(apiKey: MAPBOX_ACCESS_TOKEN);
//     List<MapBoxPlace>? rawList = await p.getPlaces(queryText);
//     return rawList;
//   }

//   Future<MapBoxPlace?> getAddressFromLatlng(
//     double lat,
//     double lng,
//   ) async {
//     final f = mbs.ReverseGeoCoding(apiKey: MAPBOX_ACCESS_TOKEN);
//     List<MapBoxPlace>? rawList =
//         await f.getAddress(Location(lat: lat, lng: lng));
//     if (rawList?.isEmpty ?? false) return null;

//     return rawList?.first;
//   }
// }
