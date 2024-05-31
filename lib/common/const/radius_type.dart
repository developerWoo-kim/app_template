enum RadiusType {
  LOW(5),
  MIDDLE(15),
  HIGH(30),
  NONE(0);

  const RadiusType(this.value);
  final double value;
}