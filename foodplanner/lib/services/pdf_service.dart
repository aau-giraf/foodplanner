import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<http.Response> fetchImage( int imageId, AuthProvider authProvider, {http.Client? client}) async {
  client ??= http.Client();
  final jwtToken = await authProvider.retrieveToken();
  final response = await client.get(
    Uri.parse('${ApiConfig.baseUrl}/api/'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer $jwtToken',
    },
    
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  }
  else {
    throw Exception('Kunne ikke hente Piktogram');
  }
}
//add api call for getting images back.



Future<Uint8List> createPdf(List<int> imageIDs, AuthProvider authProvider, {http.Client? client}) async {   
  final pdf = pw.Document();
  List<dynamic> images = [];
  for (var i = 0; i< imageIDs.length; i++){
    images.add(fetchImage(i, authProvider));
  }

  int imageSizeCM = 3;
  double imageSizePixel = 118.11 * imageSizeCM;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (_) => [
        pw.Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < images.length; i++)
            pw.SizedBox(
              width: imageSizePixel,
              height: imageSizePixel,
              child: pw.Image(
                images[i],
                fit: pw.BoxFit.contain,
              )
            )
          ]
        )
      ]
    )
  );
  return pdf.save();
    
}