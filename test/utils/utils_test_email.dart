import 'package:flutter_test/flutter_test.dart';
import 'package:quran_ayat/utils/utils.dart';

void main() {
  test('Valid email should be validated as true', () async {
    // Arrange
    const email = "test@gmail.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, true);
  });

  test('Valid email with numbers should be validated as true', () async {
    // Arrange
    const email = "test123@gmail.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, true);
  });

  test('Valid email with only numbers should be validated as true', () async {
    // Arrange
    const email = "123@123.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, true);
  });

  test('Valid email with single character should be validated as true',
      () async {
    // Arrange
    const email = "a@a.a";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, true);
  });

  test('InValid email should be validated as false', () async {
    // Arrange
    const email = "a";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('InValid email 2 should be validated as false', () async {
    // Arrange
    const email = "a@";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('InValid email 3 should be validated as false', () async {
    // Arrange
    const email = "a@a.";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('InValid email 4 should be validated as false', () async {
    // Arrange
    const email = "a@@a.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('InValid email 5 should be validated as false', () async {
    // Arrange
    const email = "a@@a..com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('InValid email 6 should be validated as false', () async {
    // Arrange
    const email = "";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('InValid email 7 should be validated as false', () async {
    // Arrange
    const email = "aa.a@com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });

  test('Null email should throw exception', () async {
    // Arrange
    const email = null;
    //Act
    Error? exception;
    try {
      bool _ = QuranUtils.isEmail(email);
    } catch (e) {
      exception = e as TypeError;
    }
    //Assert
    expect(exception != null, true);
  });

  test('Long Valid email should be validated as true', () async {
    // Arrange
    const email =
        "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest"
        "testtesttesttesttesttesttesttesttest@gmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmailgmail"
        "gmailgmailgmail.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, true);
  });

  test('Valid email with special characters should be validated as true',
      () async {
    // Arrange
    const email = "test#!\$%^&*t@gmail.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, true);
  });

  test('InValid email with parenthesis should be validated as false', () async {
    // Arrange
    const email = "test(test)@gmail.com";
    //Act
    bool isValid = QuranUtils.isEmail(email);
    //Assert
    expect(isValid, false);
  });
}
