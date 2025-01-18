class Level {
  final int id;
  final String name;
  final int minPoint;
  final int maxPoint;

  Level(this.id, this.name, this.minPoint, this.maxPoint);
}

final List<Level> levels = [
  Level(1, "BLUE Ⅴ", 0, 199),
  Level(2, "BLUE Ⅳ", 200, 399),
  Level(3, "BLUE Ⅲ", 400, 599),
  Level(4, "BLUE Ⅱ", 600, 799),
  Level(5, "BLUE Ⅰ", 800, 999),
  Level(6, "GREEN Ⅴ", 1000, 1499),
  Level(7, "GREEN Ⅳ", 1500, 1999),
  Level(8, "GREEN Ⅲ", 2000, 2499),
  Level(9, "GREEN Ⅱ", 2500, 2999),
  Level(10, "GREEN Ⅰ", 3000, 3499),
  Level(11, "YELLOW Ⅴ", 3500, 4499),
  Level(12, "YELLOW Ⅳ", 4500, 5499),
  Level(13, "YELLOW Ⅲ", 5500, 6499),
  Level(14, "YELLOW Ⅱ", 6500, 7499),
  Level(15, "YELLOW Ⅰ", 7500, 8499),
  Level(16, "ORANGE Ⅴ", 8500, 10999),
  Level(17, "ORANGE Ⅳ", 11000, 13499),
  Level(18, "ORANGE Ⅲ", 13500, 15999),
  Level(19, "ORANGE Ⅱ", 16000, 18499),
  Level(20, "ORANGE Ⅰ", 18500, 20999),
  Level(21, "RED Ⅴ", 21000, 25999),
  Level(22, "RED Ⅳ", 26000, 30999),
  Level(23, "RED Ⅲ", 31000, 35999),
  Level(24, "RED Ⅱ", 36000, 40999),
  Level(25, "RED Ⅰ", 41000, 999999999),
];
