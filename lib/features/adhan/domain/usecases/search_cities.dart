import 'package:qareeb/core/location/location_service.dart';
import 'package:qareeb/features/adhan/domain/entities/city_search_result.dart';

class SearchCities {
  const SearchCities(this._locationService);

  final LocationService _locationService;

  Future<List<CitySearchResult>> call(String query) {
    return _locationService.searchCities(query);
  }
}
