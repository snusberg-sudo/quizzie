class DeciderForScore {
  final int score, totalQuiz;

  DeciderForScore({required this.score, required this.totalQuiz});

  double get percentage => (totalQuiz == 0) ? 0 : (score / totalQuiz);

  String get title {
    if (percentage >= 0.9) {
      return "おめでとうございます！";
    } else if (percentage >= 0.75) {
      return "よく頑張りました！";
    } else if (percentage >= 0.5) {
      return "ナイスチャレンジ！";
    } else if (percentage >= 0.3) {
      return "あと一歩！";
    } else {
      return "次はもっと頑張ろう！";
    }
  }

  String get message {
    if (percentage >= 0.9) {
      return "素晴らしい！🎉 あなたはクイズマスターです！";
    } else if (percentage >= 0.75) {
      return "よくできました！🌟 知識が豊富ですね！";
    } else if (percentage >= 0.5) {
      return "まずまずです！👍 もう少しで完璧！";
    } else if (percentage >= 0.3) {
      return "あと少し！📘 もう一度挑戦してみましょう。";
    } else {
      return "あきらめないで！💪 続けて学びましょう。";
    }
  }
}
