import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import "package:http/http.dart" as http;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

class CloudApi {

  auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient _client;

  CloudApi()
    : _credentials = auth.ServiceAccountCredentials.fromJson({
    "private_key_id": "<2432fd6cd7015b57aace24f6ff671e23be2c6d6a>",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDuNDkDvLrDt5e5\nMdI3zWxO0YgYbd76Dg8J27ftSXkISHdSjeJWAYcbSCPsXZVzhDtl9qnCSNOLJz9R\nkNxQMtpv8xg4k+3frkgxnUJbJvXK+9Y7HM+mXJk5f3mHuv4qCH20D1rPn7uKnZk8\nzZ36M6qYHeNUkqpdAqZRyaeueaTQT9Vh1uhH2cx56MTAx5fSBcEhuDxmaCxEEsz1\nLLqO0YTrTDxR2Evahpf9IwbWW3MB8dYrkeCgR5hpCUK8lHeFk5k7Atll5sfNK4+E\nD3T4gQjgxjMV4v7YjjkIDXhyc2uKCn+ViTA2vM0ogUtow0vxIlcVM5d7WsEr5FJg\nQ7JpjDqHAgMBAAECggEAB7viqq2QLiDsswLG7bCPQYM0an/4EIwFTqTMyiOruNT1\nftTZfOu2xxrRWRrJapiSqc2s7FXF/It31v5KO5Zdw5W+exPJJ402jdnVGOA2dHKM\ncvCNXhGSmKx8Cyf17vJwoQ3V584qs3ueHpHEfSZRSyK+n0qAb92mqHAmMBgwqDdn\nT+8IZgSoRZOQ/fRtXtYMiH1NbQWi9Yyu/WvHMqqoKyHvLgtZDMxZFsVgaGJbGz2k\nV44ESQquhCBRIE90KaShph+xpoiDMlXsgJfxuntPee9plENWqIhil0xuh9NMJ3e1\nJolOIaEnwimWQ4lmvHAY2GQ8owraOlq7WGkU+GrjvQKBgQD3h/X1GV7CSepmrNNu\ngX+3CE4UetHluHaFCU4NQ8g6/nFjJBs5IHrerci1g5IsYsDw4bW/5BpEnzXpZBNf\nRcILjwjkLaLlvz+71I+T2El7gqsl7qog3Krl/xA6AZS3gAjTuB5fiO4tY4CG0/VK\nJvKYioyEgHbhJ8dW3VUUFpakDQKBgQD2WpGvioLde/Lo5K57kzSGZSZPqe4k9Ng7\nE2Eot8tJ6RKieu8rxhbOVHM4bYsoJtS1Qta2jebWsFwmwpFwqmXmnEZXhqXO0rGt\nKgWV4Xh28LeNmnL3YocC8lP88PDVHM/EvWFFOiyzOLhKNgAfmyAMw7/+ttsj3b02\nKmR/JMwP4wKBgHRO1EkodJgCNzurdWV1P9d29Yk19K5mMHpuVthwwwLFT+3vp0L+\nef1r1uVDP0nP1SzaQZY6zgT0claKCXg4xOa9fMYKk4I0jPPq+tPTSyPX0Cdwr0vl\no/+SC8PVvlVCueMRnmPxaUi2ekvgCF+hUVhPsZsI6dL95/Ju6W0Y+At5AoGAX05G\nkkzZt+nd3a+quPAIH/49xhANq4p1pNUof2IraVqb9PPuV1b5N7WAJdJrRYtQOxey\njUl0hpYP8IbRUW76oS7QH8hdmRf12PIq2wMxYYJa4JNh6sbZSJCLYY2s/iV5U7mY\nSfnplSRaV4twnMmcqpOIUXhYaxW7v5rC6lVIBNUCgYAm6hKzjCYQXedVxhR+2m6Q\nAld6W+xmYrtmjbeRPf4pLIN8YiFgFeVrg/frMH5PuC3+ZtMixDf/g88jR9YTCzdT\n/obMuSklKhUG7VZ+8mSD+cYHiCFTfl2GKQBiI5orOyu7XlMAIOLbxx5YBip+DU2w\nvJPI2V6YU0d3XmQ1U6SLSg==\n-----END PRIVATE KEY-----\n",
    "client_email": "dont-wait-11@don-t-wait-project.iam.gserviceaccount.com",
    "client_id": "105964347446033716515",
    "type": "service_account"
  });

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async{
    if(_client == null) _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

    var storage = Storage(_client, 'don-t-wait-project');
    var bucket = storage.bucket('don-t-wait-project.appspot.com');
    var type = lookupMimeType(name);
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    return await bucket.writeBytes(name, imgBytes, metadata:
    ObjectMetadata(
        contentType: type,
        custom: {
          'timestamp': '$timeStamp',
        },
    ));

  }

}

// var accountCredentials = auth.ServiceAccountCredentials.fromJson({
//   "private_key_id": "<2432fd6cd7015b57aace24f6ff671e23be2c6d6a>",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDuNDkDvLrDt5e5\nMdI3zWxO0YgYbd76Dg8J27ftSXkISHdSjeJWAYcbSCPsXZVzhDtl9qnCSNOLJz9R\nkNxQMtpv8xg4k+3frkgxnUJbJvXK+9Y7HM+mXJk5f3mHuv4qCH20D1rPn7uKnZk8\nzZ36M6qYHeNUkqpdAqZRyaeueaTQT9Vh1uhH2cx56MTAx5fSBcEhuDxmaCxEEsz1\nLLqO0YTrTDxR2Evahpf9IwbWW3MB8dYrkeCgR5hpCUK8lHeFk5k7Atll5sfNK4+E\nD3T4gQjgxjMV4v7YjjkIDXhyc2uKCn+ViTA2vM0ogUtow0vxIlcVM5d7WsEr5FJg\nQ7JpjDqHAgMBAAECggEAB7viqq2QLiDsswLG7bCPQYM0an/4EIwFTqTMyiOruNT1\nftTZfOu2xxrRWRrJapiSqc2s7FXF/It31v5KO5Zdw5W+exPJJ402jdnVGOA2dHKM\ncvCNXhGSmKx8Cyf17vJwoQ3V584qs3ueHpHEfSZRSyK+n0qAb92mqHAmMBgwqDdn\nT+8IZgSoRZOQ/fRtXtYMiH1NbQWi9Yyu/WvHMqqoKyHvLgtZDMxZFsVgaGJbGz2k\nV44ESQquhCBRIE90KaShph+xpoiDMlXsgJfxuntPee9plENWqIhil0xuh9NMJ3e1\nJolOIaEnwimWQ4lmvHAY2GQ8owraOlq7WGkU+GrjvQKBgQD3h/X1GV7CSepmrNNu\ngX+3CE4UetHluHaFCU4NQ8g6/nFjJBs5IHrerci1g5IsYsDw4bW/5BpEnzXpZBNf\nRcILjwjkLaLlvz+71I+T2El7gqsl7qog3Krl/xA6AZS3gAjTuB5fiO4tY4CG0/VK\nJvKYioyEgHbhJ8dW3VUUFpakDQKBgQD2WpGvioLde/Lo5K57kzSGZSZPqe4k9Ng7\nE2Eot8tJ6RKieu8rxhbOVHM4bYsoJtS1Qta2jebWsFwmwpFwqmXmnEZXhqXO0rGt\nKgWV4Xh28LeNmnL3YocC8lP88PDVHM/EvWFFOiyzOLhKNgAfmyAMw7/+ttsj3b02\nKmR/JMwP4wKBgHRO1EkodJgCNzurdWV1P9d29Yk19K5mMHpuVthwwwLFT+3vp0L+\nef1r1uVDP0nP1SzaQZY6zgT0claKCXg4xOa9fMYKk4I0jPPq+tPTSyPX0Cdwr0vl\no/+SC8PVvlVCueMRnmPxaUi2ekvgCF+hUVhPsZsI6dL95/Ju6W0Y+At5AoGAX05G\nkkzZt+nd3a+quPAIH/49xhANq4p1pNUof2IraVqb9PPuV1b5N7WAJdJrRYtQOxey\njUl0hpYP8IbRUW76oS7QH8hdmRf12PIq2wMxYYJa4JNh6sbZSJCLYY2s/iV5U7mY\nSfnplSRaV4twnMmcqpOIUXhYaxW7v5rC6lVIBNUCgYAm6hKzjCYQXedVxhR+2m6Q\nAld6W+xmYrtmjbeRPf4pLIN8YiFgFeVrg/frMH5PuC3+ZtMixDf/g88jR9YTCzdT\n/obMuSklKhUG7VZ+8mSD+cYHiCFTfl2GKQBiI5orOyu7XlMAIOLbxx5YBip+DU2w\nvJPI2V6YU0d3XmQ1U6SLSg==\n-----END PRIVATE KEY-----\n",
//   "client_email": "dont-wait-11@don-t-wait-project.iam.gserviceaccount.com",
//   "client_id": "105964347446033716515",
//   "type": "service_account"
// });
// var scopes = Storage.SCOPES;
//
// var client = http.Client();
// obtainAccessCredentialsViaServiceAccount(accountCredentials, scopes, client).then((auth.AccessCredentials credentials) {
//
// client.close();
// })
