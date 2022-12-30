// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPersistentUserDataCollection on Isar {
  IsarCollection<PersistentUserData> get persistentUserDatas =>
      this.collection();
}

const PersistentUserDataSchema = CollectionSchema(
  name: r'PersistentUserData',
  id: 1411926694960777724,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _persistentUserDataEstimateSize,
  serialize: _persistentUserDataSerialize,
  deserialize: _persistentUserDataDeserialize,
  deserializeProp: _persistentUserDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'flashcardLinks': LinkSchema(
      id: -8828751427056117003,
      name: r'flashcardLinks',
      target: r'Flashcard',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _persistentUserDataGetId,
  getLinks: _persistentUserDataGetLinks,
  attach: _persistentUserDataAttach,
  version: '3.0.5',
);

int _persistentUserDataEstimateSize(
  PersistentUserData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _persistentUserDataSerialize(
  PersistentUserData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
}

PersistentUserData _persistentUserDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersistentUserData(
    id: id,
    name: reader.readString(offsets[0]),
  );
  return object;
}

P _persistentUserDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _persistentUserDataGetId(PersistentUserData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _persistentUserDataGetLinks(
    PersistentUserData object) {
  return [object.flashcardLinks];
}

void _persistentUserDataAttach(
    IsarCollection<dynamic> col, Id id, PersistentUserData object) {
  object.id = id;
  object.flashcardLinks
      .attach(col, col.isar.collection<Flashcard>(), r'flashcardLinks', id);
}

extension PersistentUserDataQueryWhereSort
    on QueryBuilder<PersistentUserData, PersistentUserData, QWhere> {
  QueryBuilder<PersistentUserData, PersistentUserData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersistentUserDataQueryWhere
    on QueryBuilder<PersistentUserData, PersistentUserData, QWhereClause> {
  QueryBuilder<PersistentUserData, PersistentUserData, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PersistentUserDataQueryFilter
    on QueryBuilder<PersistentUserData, PersistentUserData, QFilterCondition> {
  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension PersistentUserDataQueryObject
    on QueryBuilder<PersistentUserData, PersistentUserData, QFilterCondition> {}

extension PersistentUserDataQueryLinks
    on QueryBuilder<PersistentUserData, PersistentUserData, QFilterCondition> {
  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinks(FilterQuery<Flashcard> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'flashcardLinks');
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'flashcardLinks', length, true, length, true);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'flashcardLinks', 0, true, 0, true);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'flashcardLinks', 0, false, 999999, true);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'flashcardLinks', 0, true, length, include);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'flashcardLinks', length, include, 999999, true);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterFilterCondition>
      flashcardLinksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'flashcardLinks', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PersistentUserDataQuerySortBy
    on QueryBuilder<PersistentUserData, PersistentUserData, QSortBy> {
  QueryBuilder<PersistentUserData, PersistentUserData, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PersistentUserDataQuerySortThenBy
    on QueryBuilder<PersistentUserData, PersistentUserData, QSortThenBy> {
  QueryBuilder<PersistentUserData, PersistentUserData, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PersistentUserData, PersistentUserData, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension PersistentUserDataQueryWhereDistinct
    on QueryBuilder<PersistentUserData, PersistentUserData, QDistinct> {
  QueryBuilder<PersistentUserData, PersistentUserData, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension PersistentUserDataQueryProperty
    on QueryBuilder<PersistentUserData, PersistentUserData, QQueryProperty> {
  QueryBuilder<PersistentUserData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PersistentUserData, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
