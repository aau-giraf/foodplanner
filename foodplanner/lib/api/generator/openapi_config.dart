// Openapi Generator last run: : 2025-11-25T17:45:17.350394
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
    additionalProperties:
        AdditionalProperties(pubName: 'foodplanner_api', pubAuthor: 'Giraf'),
    inputSpec:
        RemoteSpec(path: 'http://localhost:8080/swagger/v1/swagger.json'),
    generatorName: Generator.dart,
    outputDirectory: 'lib/api/openapi')
class ApiGenerator {}