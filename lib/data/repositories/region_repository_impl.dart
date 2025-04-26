import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/datasources/local/region_local_datasource.dart';
import 'package:melamine_elsherif/data/datasources/remote/store_api.dart';
import 'package:melamine_elsherif/data/models/region_model.dart';
import 'package:melamine_elsherif/domain/entities/region.dart';
import 'package:melamine_elsherif/domain/repositories/region_repository.dart';

/// Implementation of [RegionRepository] that integrates remote and local data sources
class RegionRepositoryImpl implements RegionRepository {
  final StoreApi _storeApi;
  final RegionLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  /// Creates a [RegionRepositoryImpl] instance
  RegionRepositoryImpl(
    this._storeApi,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Region>>> getRegions() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getRegions();
        
        final List<RegionModel> regions = [];
        if (response['regions'] != null) {
          for (final region in response['regions']) {
            regions.add(RegionModel.fromJson(region));
          }
        }
        
        // Cache the regions
        _localDataSource.cacheRegions(regions);
        
        return Right(regions);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localRegions = await _localDataSource.getRegions();
          return Right(localRegions);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localRegions = await _localDataSource.getRegions();
        return Right(localRegions);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get regions from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, Region>> getRegionById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getRegionById(id);
        
        if (response['region'] != null) {
          final region = RegionModel.fromJson(response['region']);
          
          // Cache the region
          _localDataSource.cacheRegion(region);
          
          return Right(region);
        }
        
        return const Left(NotFoundFailure(message: 'Region not found'));
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localRegion = await _localDataSource.getRegionById(id);
          if (localRegion != null) {
            return Right(localRegion);
          }
          return const Left(CacheFailure(message: 'Region not found in cache'));
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localRegion = await _localDataSource.getRegionById(id);
        if (localRegion != null) {
          return Right(localRegion);
        }
        return const Left(CacheFailure(message: 'Region not found in cache'));
      } catch (e) {
        return const Left(CacheFailure(message: 'Unable to get region from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Region>>> getRegionsByCountry(String countryCode) async {
    if (await _networkInfo.isConnected) {
      try {
        final regionsResult = await getRegions();
        
        return regionsResult.fold(
          (failure) => Left(failure),
          (regions) {
            final filteredRegions = regions.where((region) => 
              region.countries!.any((country) => 
                country.iso2.toLowerCase() == countryCode.toLowerCase() ||
                country.iso3.toLowerCase() == countryCode.toLowerCase()
              )
            ).toList();
            
            if (filteredRegions.isEmpty) {
              return const Left(NotFoundFailure(message: 'No regions found for this country'));
            }
            
            return Right(filteredRegions);
          },
        );
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localRegions = await _localDataSource.getRegions();
        final filteredRegions = localRegions.where((region) => 
          region.countries!.any((country) => 
            country.iso2.toLowerCase() == countryCode.toLowerCase() ||
            country.iso3.toLowerCase() == countryCode.toLowerCase()
          )
        ).toList();
        
        if (filteredRegions.isEmpty) {
          return const Left(NotFoundFailure(message: 'No regions found for this country'));
        }
        
        return Right(filteredRegions);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get regions from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, Region>> getRegionByCountryCode(String countryCode) async {
    if (await _networkInfo.isConnected) {
      try {
        final regionsResult = await getRegionsByCountry(countryCode);
        
        return regionsResult.fold(
          (failure) => Left(failure),
          (regions) {
            if (regions.isEmpty) {
              return const Left(NotFoundFailure(message: 'No region found for this country'));
            }
            
            return Right(regions.first);
          },
        );
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localRegions = await _localDataSource.getRegions();
        final filteredRegions = localRegions.where((region) => 
          region.countries!.any((country) => 
            country.iso2.toLowerCase() == countryCode.toLowerCase() ||
            country.iso3.toLowerCase() == countryCode.toLowerCase()
          )
        ).toList();
        
        if (filteredRegions.isEmpty) {
          return const Left(NotFoundFailure(message: 'No region found for this country'));
        }
        
        return Right(filteredRegions.first);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get regions from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, Region>> getCurrentRegion() async {
    try {
      final currentRegionId = await _localDataSource.getCurrentRegionId();
      
      if (currentRegionId != null) {
        return getRegionById(currentRegionId);
      } else {
        // If no current region is set, get all regions and use the first one
        final regionsResult = await getRegions();
        
        return regionsResult.fold(
          (failure) => Left(failure),
          (regions) {
            if (regions.isEmpty) {
              return const Left(NotFoundFailure(message: 'No regions available'));
            }
            
            // Set the first region as current
            _localDataSource.setCurrentRegionId(regions.first.id);
            
            return Right(regions.first);
          },
        );
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get current region'));
    }
  }

  @override
  Future<Either<Failure, bool>> setCurrentRegion(String regionId) async {
    try {
      // Verify that the region exists
      final regionResult = await getRegionById(regionId);
      
      return regionResult.fold(
        (failure) => Left(failure),
        (region) async {
          await _localDataSource.setCurrentRegionId(regionId);
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to set current region'));
    }
  }
} 