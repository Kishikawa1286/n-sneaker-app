class GenerateGlbFileDownloadUrlParameters {
  const GenerateGlbFileDownloadUrlParameters({
    required this.productId,
    required this.productGlbFileId,
  });

  final String productId;
  final String productGlbFileId;

  Map<String, String> toMap() => {
        'product_id': productId,
        'product_glb_file_id': productGlbFileId,
      };
}
