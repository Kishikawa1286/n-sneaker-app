class AddCollectionProductParameters {
  const AddCollectionProductParameters({
    required this.productId,
    required this.paymentMethod,
  });

  final String productId;
  final String paymentMethod;

  Map<String, String> toMap() => {
        'product_id': productId,
        'payment_method': paymentMethod,
      };
}
