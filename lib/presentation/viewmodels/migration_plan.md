# Viewmodel Migration Plan

## Current Issues

We have duplicate implementations of viewmodels in different locations:

1. **Cart Viewmodels**:
   - `lib/presentation/viewmodels/cart_viewmodel.dart`
   - `lib/presentation/viewmodels/cart/cart_view_model.dart`

2. **Product Viewmodels**:
   - `lib/presentation/viewmodels/product_viewmodel.dart`
   - `lib/presentation/viewmodels/product/product_view_model.dart`

These duplicates can cause confusion and dependency issues.

## Migration Strategy

### Short-term solution (already implemented)

- Created an `index.dart` file that exports all viewmodels
- Used the `hide` keyword to prevent naming conflicts
- This allows existing code to continue working during migration

### Long-term solution

1. **Choose a consistent structure**:
   - Move all viewmodels to subdirectories by category (recommended)
   - OR keep all viewmodels at the root level

2. **For the cart viewmodels**:
   - Merge functionality from `cart_viewmodel.dart` into `cart/cart_view_model.dart`
   - Use the version in the subdirectory as the canonical implementation
   - Update all imports to use the index file (`import '...viewmodels/index.dart'`)

3. **For the product viewmodels**:
   - Merge functionality from `product_viewmodel.dart` into `product/product_view_model.dart`
   - Use the version in the subdirectory as the canonical implementation
   - Update all imports to use the index file

## Implementation Timeline

1. First Phase (Current):
   - Use the index file to manage conflicts
   - Audit existing code to find all imports of the duplicated viewmodels

2. Second Phase:
   - Merge functionality between duplicated implementations
   - Deprecate the root-level implementations

3. Final Phase:
   - Remove deprecated implementations
   - Ensure all code imports from the index file

## Best Practices Going Forward

- All new viewmodels should be created in subdirectories by feature
- Use the index file for all imports
- Follow consistent naming convention: `feature_view_model.dart` 