import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 19)
class Transaction extends HiveObject {
  @HiveField(0)
  late double amount;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  late String paymentMethod;

  @HiveField(5)
  late bool isIncome;

  @HiveField(6)
  String? imageUrl;

  @HiveField(7)
  String? note;

  Transaction({
    double? amount,
    String? title,
    String? category,
    DateTime? date,
    String? paymentMethod,
    bool? isIncome,
    this.imageUrl,
    this.note,
  }) {
    this.amount = amount ?? 0.0;
    this.title = title ?? '';
    this.category = category ?? '';
    this.date = date ?? DateTime.now();
    this.paymentMethod = paymentMethod ?? 'Digital';
    this.isIncome = isIncome ?? false;
  }
}
