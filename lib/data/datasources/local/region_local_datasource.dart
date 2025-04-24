import 'dart:convert';

import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/data/models/region_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface for local data source for region operations
abstract class RegionLocalDataSource {
  /// Get all regions from cache
  Future<List<RegionModel>> getRegions();

  /// Get region by id from cache
  Future<RegionModel?> getRegionById(String id);

  /// Cache regions
  Future<void> cacheRegions(List<RegionModel> regions);

  /// Cache a single region
  Future<void> cacheRegion(RegionModel region);
  
  /// Get the ID of the current selected region
  Future<String?> getCurrentRegionId();
  
  /// Set the ID of the current selected region
  Future<void> setCurrentRegionId(String regionId);
}

/// Implementation of [RegionLocalDataSource]
class RegionLocalDataSourceImpl implements RegionLocalDataSource {
  final Store _store;
  final SharedPreferences _prefs;

  /// Keys for SharedPreferences
  static const String regionsKey = 'CACHED_REGIONS';
  static const String currentRegionKey = 'CURRENT_REGION_ID';

  /// Creates a [RegionLocalDataSourceImpl] instance
  RegionLocalDataSourceImpl(this._store, this._prefs);

  @override
  Future<List<RegionModel>> getRegions() async {
    try {
      final box = _store.box<RegionModel>();
      return box.getAll();
    } catch (e) {
      throw CacheException(message: 'Failed to get regions from cache: $e');
    }
  }

  @override
  Future<RegionModel?> getRegionById(String id) async {
    try {
      final regions = await getRegions();
      return regions.firstWhere((region) => region.id == id);
    } on CacheException {
      throw CacheException(message: 'No cached region found with id: $id');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheRegions(List<RegionModel> regions) async {
    try {
      final box = _store.box<RegionModel>();
      box.putMany(regions);
    } catch (e) {
      throw CacheException(message: 'Failed to cache regions: $e');
    }
  }

  @override
  Future<void> cacheRegion(RegionModel region) async {
    try {
      final box = _store.box<RegionModel>();
      box.put(region);
    } catch (e) {
      throw CacheException(message: 'Failed to cache region: $e');
    }
  }
  
  @override
  Future<String?> getCurrentRegionId() async {
    return _prefs.getString(currentRegionKey);
  }
  
  @override
  Future<void> setCurrentRegionId(String regionId) async {
    await _prefs.setString(currentRegionKey, regionId);
  }

  /// Clears the region cache
  Future<void> clearCache() async {
    try {
      _store.box<RegionModel>().removeAll();
      await _prefs.remove(currentRegionKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
} 