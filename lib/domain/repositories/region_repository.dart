import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/region.dart';

/// Repository interface for region operations
abstract class RegionRepository {
  /// Fetches all regions
  ///
  /// Returns a [List<Region>] on success or a [Failure] on error
  Future<Either<Failure, List<Region>>> getRegions();
  
  /// Fetches a specific region by ID
  ///
  /// Returns a [Region] on success or a [Failure] on error
  Future<Either<Failure, Region>> getRegionById(String id);
  
  /// Fetches regions by country code
  ///
  /// Returns a [List<Region>] on success or a [Failure] on error
  Future<Either<Failure, List<Region>>> getRegionsByCountry(String countryCode);

  /// Gets a region by country code
  Future<Either<Failure, Region>> getRegionByCountryCode(String countryCode);

  /// Gets the currently selected region or default region
  Future<Either<Failure, Region>> getCurrentRegion();

  /// Sets the current region by ID
  Future<Either<Failure, bool>> setCurrentRegion(String regionId);
} 