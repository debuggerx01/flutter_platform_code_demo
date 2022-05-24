import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:analyzer/src/source/source_resource.dart' show FileSource;
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import 'platform_annotation.dart';

class PlatformGenerator extends GeneratorForAnnotation<PlatformDetector> {
  final PlatformType platformType;

  PlatformGenerator(this.platformType);

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    var compilationUnit = parseString(content: (element.source as FileSource).file.readAsStringSync()).unit;
    var _visitor = _Visitor(platformType);
    compilationUnit.visitChildren(_visitor);
    var res = compilationUnit.toSource();
    for (var ele in _visitor._removes) {
      res = res.replaceFirst(ele, '');
    }
    _visitor._renames.forEach((from, to) {
      res = res.replaceFirst(from, to);
    });
    return res;
  }
}

typedef HandleRename = String Function(String source, String renameTo);

class _Visitor<R> extends RecursiveAstVisitor<R> {
  final Set<String> _removes = {};
  final Map<String, String> _renames = {};
  final PlatformType platformType;

  _Visitor(this.platformType);

  _handleNode(AnnotatedNode node, {HandleRename? handleRename, useParent = false}) {
    if (node.metadata.isNotEmpty) {
      var annotation = node.metadata.singleWhereOrNull((element) => element.name.name == 'PlatformSpec');
      if (annotation != null && annotation.arguments != null) {
        var _platformType = annotation.arguments!.arguments
            .firstWhereOrNull((arg) => arg is NamedExpression && arg.name.label.toString() == 'platformType');
        var _renameTo = annotation.arguments!.arguments
            .firstWhereOrNull((arg) => arg is NamedExpression && arg.name.label.toString() == 'renameTo');

        if (_platformType != null) {
          var _source = (useParent ? node.parent! : node).toString();
          if (platformType.toString() == (_platformType as NamedExpression).expression.toString()) {
            if (_renameTo != null) {
              var __renameTo = (_renameTo as NamedExpression).expression.toString();
              var renamedSource = handleRename?.call(_source, __renameTo.substring(1, __renameTo.length - 1));
              if (renamedSource != null) {
                _renames[_source] = renamedSource;
              }
            }
          } else {
            _removes.add(_source);
          }
        }
      }
    }
  }

  @override
  R? visitClassDeclaration(ClassDeclaration node) {
    _handleNode(
      node,
      handleRename: (source, renameTo) => source.replaceFirst('class ${node.name.name}', 'class $renameTo'),
    );
    return super.visitClassDeclaration(node);
  }

  @override
  R? visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    _handleNode(
      node.variables,
      useParent: true,
      handleRename: (source, renameTo) => source.replaceFirst(node.variables.variables.first.name.name, renameTo),
    );
    return super.visitVariableDeclarationStatement(node);
  }

  @override
  R? visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    _handleNode(
      node,
      handleRename: (source, renameTo) => source.replaceFirst(node.variables.variables.first.name.name, renameTo),
    );
    return super.visitTopLevelVariableDeclaration(node);
  }

  @override
  R? visitFieldDeclaration(FieldDeclaration node) {
    _handleNode(
      node,
      handleRename: (source, renameTo) => source.replaceFirst(node.fields.variables.first.name.name, renameTo),
    );
    return super.visitFieldDeclaration(node);
  }

  @override
  R? visitImportDirective(ImportDirective node) {
    _handleNode(
      node,
      handleRename: (source, renameTo) => source.replaceFirst(node.uri.toSource(), "'$renameTo'"),
    );
    return super.visitImportDirective(node);
  }

  @override
  R? visitFunctionDeclaration(FunctionDeclaration node) {
    _handleNode(
      node,
      handleRename: (source, renameTo) => source.replaceFirst(node.name.name, renameTo),
    );
    return super.visitFunctionDeclaration(node);
  }

  @override
  R? visitMethodDeclaration(MethodDeclaration node) {
    _handleNode(
      node,
      handleRename: (source, renameTo) => source.replaceFirst(node.name.name, renameTo),
    );
    return super.visitMethodDeclaration(node);
  }
}
