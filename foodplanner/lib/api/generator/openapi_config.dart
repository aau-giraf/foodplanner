// Openapi Generator last run: : 2024-10-23T11:43:15.612169
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  additionalProperties: AdditionalProperties(
    pubName: 'foodplanner_api', 
    pubAuthor: 'Giraf'
  ),
  inputSpec: RemoteSpec(path: 'http://localhost:8080/swagger/v1/swagger.json'),
  generatorName: Generator.dart,
  outputDirectory: 'lib/api/openapi'
)
class ApiGenerator {}