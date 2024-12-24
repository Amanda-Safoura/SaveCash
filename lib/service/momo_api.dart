import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MtnMomoApi {
  final String apiUser = "371863e2-b2d7-49a1-bb35-0d8267d65067";
  final String apiKey = "ebab9c75087b491dbe6707953a848e42";
  final String ocpSubscriptionKey = "5b54cf009c7a45cea125a972ee5e2040";

  String? accessToken;
  DateTime? tokenExpiry;

  Future<String?> getAccessToken() async {
    final String auth = base64Encode(utf8.encode('$apiUser:$apiKey'));
    final Uri url =
        Uri.parse('https://sandbox.momodeveloper.mtn.com/collection/token/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic $auth',
          'Ocp-Apim-Subscription-Key': ocpSubscriptionKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        accessToken = responseData['access_token'];
        tokenExpiry =
            DateTime.now().add(Duration(seconds: responseData['expires_in']));
        return accessToken;
      } else {
        print(
            'Failed to get access token. Status code: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while getting access token: $e');
      return null;
    }
  }

  bool isAccessTokenValid() {
    if (accessToken != null && tokenExpiry != null) {
      return DateTime.now().isBefore(tokenExpiry!);
    }
    return false;
  }

  Future<bool> requestToPay({
    required String amount,
    required String phoneNumber,
  }) async {
    if (!isAccessTokenValid()) {
      await getAccessToken();
    }

    if (accessToken == null) {
      print(
          'Access token is not available. Cannot proceed with request to pay.');
      Fluttertoast.showToast(
          msg:
              'Access token is not available. Cannot proceed with request to pay.');
      return false;
    }

    print(accessToken);
    Fluttertoast.showToast(
        msg: 'access token : ${accessToken}', toastLength: Toast.LENGTH_LONG);

    final String uuid = const Uuid().v4();
    final Uri url = Uri.parse(
        'https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay');

    final Map<String, dynamic> body = {
      "amount": amount,
      "currency": "EUR",
      "externalId": uuid,
      "payer": {
        "partyIdType": "MSISDN",
        "partyId": phoneNumber,
      },
      "payerMessage":
          "Nous avons transféré un montant de $amount XOF dans votre compte épargne",
      "payeeNote": "string",
    };

    print(body);
    Fluttertoast.showToast(
        msg: body.toString(), toastLength: Toast.LENGTH_LONG);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-Reference-Id': uuid,
          'X-Target-Environment': 'sandbox',
          'Content-Type': 'application/json',
          'Ocp-Apim-Subscription-Key': ocpSubscriptionKey,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 202) {
        print('Request to pay initiated successfully.');
        Fluttertoast.showToast(msg: 'Request to pay initiated successfully.');
        return true;
      } else {
        print(
            'Failed to initiate request to pay. Status code: ${response.statusCode}, Body: ${response.body}');
        Fluttertoast.showToast(
            msg:
                'Failed to initiate request to pay. Status code: ${response.statusCode}, Body: ${response.body}',
            toastLength: Toast.LENGTH_LONG);
        return false;
      }
    } catch (e) {
      print('Error occurred while initiating request to pay: $e');
      Fluttertoast.showToast(
          msg: 'Error occurred while initiating request to pay: $e',
          toastLength: Toast.LENGTH_LONG);
      return false;
    }
  }
}
/* 
void main() async {
  final api = MtnMomoApi();

  if (!api.isAccessTokenValid()) {
    await api.getAccessToken();
  }

  final success = await api.requestToPay(
    amount: "1000",
    phoneNumber: "22512345678",
  );

  if (success) {
    print('Payment request sent successfully.');
  } else {
    print('Payment request failed.');
  }
} */
