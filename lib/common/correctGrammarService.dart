class correctGrammarService {
  String getExtractSentences(String text) {
    List<String> keySentences = text.split("\n");

    int pos = keySentences.indexOf("올바른 문장을 선택해 주세요");

    if (pos == -1) {
      // 다시 찍도록 유도
    }

    String questionText = "";
    int cnt = 1; // 질문개수

    for (var i = pos + 1; i < keySentences.length; i++) {
      // questionText += cnt + "번:\'" + mainTextArr[i] + "\'\n";
      if (keySentences[i].indexOf(".") != -1 &&
          keySentences[i].indexOf("LV.") == -1 &&
          cnt < 6) {
        questionText +=
            "${cnt}번:\'" + keySentences[i].replaceAll(".", "") + ".\'\n";

        cnt = cnt + 1;
      }
    }

    return questionText;
  }
}
