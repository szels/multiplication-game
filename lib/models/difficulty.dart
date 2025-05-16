enum Difficulty {
  easy(10, 'Easy'),
  medium(20, 'Medium'),
  hard(30, 'Hard');

  final int maxNumber;
  final String label;

  const Difficulty(this.maxNumber, this.label);
} 