import 'dart:convert';

import '../../network/decodable.dart';

class Schedule implements Decodable<Schedule> {
  final List<Data>? data;
  final List<Included>? included;
  final Meta? meta;

  Schedule({
    this.data,
    this.included,
    this.meta,
  });

  Schedule.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList(),
        included = (json['included'] as List?)?.map((dynamic e) => Included.fromJson(e as Map<String,dynamic>)).toList(),
        meta = (json['meta'] as Map<String,dynamic>?) != null ? Meta.fromJson(json['meta'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.map((e) => e.toJson()).toList(),
    'included' : included?.map((e) => e.toJson()).toList(),
    'meta' : meta?.toJson()
  };

  @override
  Schedule? decode(String json) {
    var jsonMap = jsonDecode(json);
    return Schedule.fromJson(jsonMap);
  }
}

class Data {
  final String? type;
  final int? id;
  final Attributes? attributes;
  final Relationships? relationships;

  Data({
    this.type,
    this.id,
    this.attributes,
    this.relationships,
  });

  Data.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        id = json['id'] as int?,
        attributes = (json['attributes'] as Map<String,dynamic>?) != null ? Attributes.fromJson(json['attributes'] as Map<String,dynamic>) : null,
        relationships = (json['relationships'] as Map<String,dynamic>?) != null ? Relationships.fromJson(json['relationships'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'id' : id,
    'attributes' : attributes?.toJson(),
    'relationships' : relationships?.toJson()
  };
}

class Attributes {
  final int? id;
  final String? start;
  final String? end;
  final dynamic activity;
  final String? year;
  final dynamic parallel;

  Attributes({
    this.id,
    this.start,
    this.end,
    this.activity,
    this.year,
    this.parallel,
  });

  Attributes.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        start = json['start'] as String?,
        end = json['end'] as String?,
        activity = json['activity'],
        year = json['year'] as String?,
        parallel = json['parallel'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'start' : start,
    'end' : end,
    'activity' : activity,
    'year' : year,
    'parallel' : parallel
  };
}

class Relationships {
  final Stages? stages;
  final Days? days;
  final PerformanceDescriptions? performanceDescriptions;

  Relationships({
    this.stages,
    this.days,
    this.performanceDescriptions,
  });

  Relationships.fromJson(Map<String, dynamic> json)
      : stages = (json['stages'] as Map<String,dynamic>?) != null ? Stages.fromJson(json['stages'] as Map<String,dynamic>) : null,
        days = (json['days'] as Map<String,dynamic>?) != null ? Days.fromJson(json['days'] as Map<String,dynamic>) : null,
        performanceDescriptions = (json['performanceDescriptions'] as Map<String,dynamic>?) != null ? PerformanceDescriptions.fromJson(json['performanceDescriptions'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'stages' : stages?.toJson(),
    'days' : days?.toJson(),
    'performanceDescriptions' : performanceDescriptions?.toJson()
  };
}

class Stages {
  final StagesData? data;

  Stages({
    this.data,
  });

  Stages.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String,dynamic>?) != null ? StagesData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.toJson()
  };
}

class StagesData {
  final String? type;
  final int? id;

  StagesData({
    this.type,
    this.id,
  });

  StagesData.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'id' : id
  };
}

class Days {
  final DaysData? data;

  Days({
    this.data,
  });

  Days.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String,dynamic>?) != null ? DaysData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.toJson()
  };
}

class DaysData {
  final String? type;
  final int? id;

  DaysData({
    this.type,
    this.id,
  });

  DaysData.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'id' : id
  };
}

class PerformanceDescriptions {
  final PerformanceDescriptionData? data;

  PerformanceDescriptions({
    this.data,
  });

  PerformanceDescriptions.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String,dynamic>?) != null ? PerformanceDescriptionData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.toJson()
  };
}

class PerformanceDescriptionData {
  final String? type;
  final int? id;

  PerformanceDescriptionData({
    this.type,
    this.id,
  });

  PerformanceDescriptionData.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'id' : id
  };
}

class Included {
  final String? type;
  final int? id;
  final IncludedAttributes? attributes;
  final IncludedRelationships? relationships;

  Included({
    this.type,
    this.id,
    this.attributes,
    this.relationships,
  });

  Included.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        id = json['id'] as int?,
        attributes = (json['attributes'] as Map<String,dynamic>?) != null ? IncludedAttributes.fromJson(json['attributes'] as Map<String,dynamic>) : null,
        relationships = (json['relationships'] as Map<String,dynamic>?) != null ? IncludedRelationships.fromJson(json['relationships'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'id' : id,
    'attributes' : attributes?.toJson(),
    'relationships' : relationships?.toJson()
  };
}

class IncludedAttributes {
  final int? id;
  final String? name;
  final String? year;

  IncludedAttributes({
    this.id,
    this.name,
    this.year,
  });

  IncludedAttributes.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        year = json['year'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'year' : year
  };
}

class IncludedRelationships {
  final List<Performances>? performances;

  IncludedRelationships({
    this.performances,
  });

  IncludedRelationships.fromJson(Map<String, dynamic> json)
      : performances = (json['performances'] as List?)?.map((dynamic e) => Performances.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'performances' : performances?.map((e) => e.toJson()).toList()
  };
}

class Performances {
  final PerformancesData? data;

  Performances({
    this.data,
  });

  Performances.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as Map<String,dynamic>?) != null ? PerformancesData.fromJson(json['data'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.toJson()
  };
}

class PerformancesData {
  final String? type;
  final int? id;

  PerformancesData({
    this.type,
    this.id,
  });

  PerformancesData.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        id = json['id'] as int?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'id' : id
  };
}

class Meta {
  final Page? page;

  Meta({
    this.page,
  });

  Meta.fromJson(Map<String, dynamic> json)
      : page = (json['page'] as Map<String,dynamic>?) != null ? Page.fromJson(json['page'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'page' : page?.toJson()
  };
}

class Page {
  final int? total;
  final int? last;
  final int? number;
  final int? size;

  Page({
    this.total,
    this.last,
    this.number,
    this.size,
  });

  Page.fromJson(Map<String, dynamic> json)
      : total = json['total'] as int?,
        last = json['last'] as int?,
        number = json['number'] as int?,
        size = json['size'] as int?;

  Map<String, dynamic> toJson() => {
    'total' : total,
    'last' : last,
    'number' : number,
    'size' : size
  };
}