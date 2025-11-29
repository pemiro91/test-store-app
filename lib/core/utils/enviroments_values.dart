import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['products_server'] ?? 'Error: products_server not found';
final String serverClientId = dotenv.env['serverClientId'] ?? 'Error: serverClientId not found';