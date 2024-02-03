enum QuranScreen {
  root,
  home,
  signup,
  login,
  context,
  createNote,
  viewTags,
  mySubmissions,
  createChallenge,
  createQuestion,
  challenge,
  confirmation,
  editAnswer,
  message,
  tagResults,
  error
}

QuranScreen screenFromRouteString(String screen) {
  switch (screen) {
    case "/":
      return QuranScreen.root;
    case "/home":
      return QuranScreen.home;
    case "/signup":
      return QuranScreen.signup;
    case "/login":
      return QuranScreen.login;
    case "/context":
      return QuranScreen.context;
    case "/createNote":
      return QuranScreen.createNote;
    case "/viewTags":
      return QuranScreen.viewTags;
    case "/mySubmissions":
      return QuranScreen.mySubmissions;
    case "/createChallenge":
      return QuranScreen.createChallenge;
    case "/createQuestion":
      return QuranScreen.createQuestion;
    case "/challenge":
      return QuranScreen.challenge;
    case "/confirmation":
      return QuranScreen.confirmation;
    case "/editAnswer":
      return QuranScreen.editAnswer;
    case "/message":
      return QuranScreen.message;
    case "/tagResults":
      return QuranScreen.tagResults;
  }

  return QuranScreen.error;
}

extension QuranScreenToString on QuranScreen {
  String rawString() {
    switch (this) {
      case QuranScreen.root:
        return "/";
      case QuranScreen.home:
        return "/home";
      case QuranScreen.signup:
        return "/signup";
      case QuranScreen.login:
        return "/login";
      case QuranScreen.context:
        return "/context";
      case QuranScreen.createNote:
        return "/createNote";
      case QuranScreen.viewTags:
        return "/viewTags";
      case QuranScreen.mySubmissions:
        return "/mySubmissions";
      case QuranScreen.createChallenge:
        return "/createChallenge";
      case QuranScreen.createQuestion:
        return "/createQuestion";
      case QuranScreen.challenge:
        return "/challenge";
      case QuranScreen.confirmation:
        return "/confirmation";
      case QuranScreen.editAnswer:
        return "/editAnswer";
      case QuranScreen.message:
        return "/message";
      case QuranScreen.tagResults:
        return "/tagResults";
      case QuranScreen.error:
        return "";
    }
  }
}
