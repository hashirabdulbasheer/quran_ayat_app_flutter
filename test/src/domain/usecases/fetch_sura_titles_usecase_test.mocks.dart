// Mocks generated by Mockito 5.4.4 from annotations
// in ayat_app/test/src/domain/usecases/fetch_sura_titles_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:ayat_app/src/data/local/quran_local_data_source.dart' as _i2;
import 'package:ayat_app/src/data/repositories/quran_repository_impl.dart'
    as _i4;
import 'package:ayat_app/src/domain/enums/qtranslation_enum.dart' as _i6;
import 'package:ayat_app/src/domain/models/qdata.dart' as _i3;
import 'package:ayat_app/src/domain/models/ruku.dart' as _i8;
import 'package:ayat_app/src/domain/models/sura_title.dart' as _i7;
import 'package:ayat_app/src/domain/models/surah_index.dart' as _i9;
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

class _FakeQuranDataSource_0 extends _i1.SmartFake
    implements _i2.QuranDataSource {
  _FakeQuranDataSource_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQPageData_1 extends _i1.SmartFake implements _i3.QPageData {
  _FakeQPageData_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [QuranRepositoryImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuranRepositoryImpl extends _i1.Mock
    implements _i4.QuranRepositoryImpl {
  MockQuranRepositoryImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.QuranDataSource get dataSource => (super.noSuchMethod(
        Invocation.getter(#dataSource),
        returnValue: _FakeQuranDataSource_0(
          this,
          Invocation.getter(#dataSource),
        ),
      ) as _i2.QuranDataSource);

  @override
  set dataSource(_i2.QuranDataSource? _dataSource) => super.noSuchMethod(
        Invocation.setter(
          #dataSource,
          _dataSource,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<_i3.QPageData> getPageQuranData({
    required int? pageNo,
    required _i6.QTranslation? translationType,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPageQuranData,
          [],
          {
            #pageNo: pageNo,
            #translationType: translationType,
          },
        ),
        returnValue: _i5.Future<_i3.QPageData>.value(_FakeQPageData_1(
          this,
          Invocation.method(
            #getPageQuranData,
            [],
            {
              #pageNo: pageNo,
              #translationType: translationType,
            },
          ),
        )),
      ) as _i5.Future<_i3.QPageData>);

  @override
  _i5.Future<List<_i7.SuraTitle>> getSuraTitles() => (super.noSuchMethod(
        Invocation.method(
          #getSuraTitles,
          [],
        ),
        returnValue: _i5.Future<List<_i7.SuraTitle>>.value(<_i7.SuraTitle>[]),
      ) as _i5.Future<List<_i7.SuraTitle>>);

  @override
  _i8.Ruku? getRuku(_i9.SurahIndex? suraIndex) =>
      (super.noSuchMethod(Invocation.method(
        #getRuku,
        [suraIndex],
      )) as _i8.Ruku?);
}