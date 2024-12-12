// Mocks generated by Mockito 5.4.4 from annotations
// in ayat_app/test/src/data/repositories/quran_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:ayat_app/src/data/local/quran_local_data_source.dart' as _i3;
import 'package:ayat_app/src/data/models/local/data_local_models.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeQuranLocalData_0 extends _i1.SmartFake
    implements _i2.QuranLocalData {
  _FakeQuranLocalData_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [QuranLocalDataSourceImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuranLocalDataSourceImpl extends _i1.Mock
    implements _i3.QuranLocalDataSourceImpl {
  MockQuranLocalDataSourceImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.QuranLocalData> getPageQuranData({
    required int? pageNo,
    required List<_i2.NQTranslation>? translationTypes,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPageQuranData,
          [],
          {
            #pageNo: pageNo,
            #translationTypes: translationTypes,
          },
        ),
        returnValue: _i4.Future<_i2.QuranLocalData>.value(_FakeQuranLocalData_0(
          this,
          Invocation.method(
            #getPageQuranData,
            [],
            {
              #pageNo: pageNo,
              #translationTypes: translationTypes,
            },
          ),
        )),
      ) as _i4.Future<_i2.QuranLocalData>);

  @override
  _i4.Future<List<_i2.LocalSuraTitle>> getSuraTitles() => (super.noSuchMethod(
        Invocation.method(
          #getSuraTitles,
          [],
        ),
        returnValue:
            _i4.Future<List<_i2.LocalSuraTitle>>.value(<_i2.LocalSuraTitle>[]),
      ) as _i4.Future<List<_i2.LocalSuraTitle>>);

  @override
  _i2.NQRuku? getRuku(
    int? sura,
    int? aya,
  ) =>
      (super.noSuchMethod(Invocation.method(
        #getRuku,
        [
          sura,
          aya,
        ],
      )) as _i2.NQRuku?);
}
