/// Client-side catalog sort options applied after remote fetch.
enum ProductSortOption {
  /// Lowest unit price first.
  priceAsc,

  /// Highest unit price first.
  priceDesc,

  /// Highest aggregate rating first.
  ratingDesc,

  /// Alphabetical by title.
  titleAsc,
}
