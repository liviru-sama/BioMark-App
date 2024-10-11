// lib/utils/encryption_helper.dart
import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  final Key key;
  final IV iv;
  late Encrypter encrypter;

  EncryptionHelper(this.key, this.iv) {
    encrypter = Encrypter(AES(key));
  }

  String encrypt(String plainText) {
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decrypt(String encryptedText) {
    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}

// Usage Example:
// Initialize EncryptionHelper with a secure key and IV
final encryptionHelper = EncryptionHelper(Key.fromUtf8('32_characters_long_key_here!'), IV.fromLength(16));

String encrypted = encryptionHelper.encrypt('Sensitive Data');
String decrypted = encryptionHelper.decrypt(encrypted);
