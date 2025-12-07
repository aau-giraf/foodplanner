import 'package:foodplanner/models/pupil.dart';

class PupilData{
    String firstName;
    String lastName;
    String email;
    //String parents;
    int classId;

    PupilData({
        required this.firstName,
        required this.lastName,
        required this.email,
        // parents,
        this.classId = 0,
    });

    factory PupilData.fromChildJson(Pupil pupil){
        return Pupil(
            firstName: pupil.firstName,
            lastName: pupil.lastName,
            email: pupil.email,
        );
    }
}