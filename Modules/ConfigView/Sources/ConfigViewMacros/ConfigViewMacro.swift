//import SwiftCompilerPlugin
//import SwiftSyntaxBuilder

import SwiftSyntax
import SwiftSyntaxMacros

public struct StyleModifierMacro: ExtensionMacro {
  
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
    conformingTo protocols: [SwiftSyntax.TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    //struct의 선언부
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw MacroError.message("Macro can only be applied to structs")
    }
    
    //struct의 struct Style 선언부
    guard let config = structDecl.memberBlock.members
      .compactMap({ $0.decl.as(StructDeclSyntax.self) })
      .first(where: {$0.name.text == "Style"}) else {
        throw MacroError.message("There is no 'Style' struct")
      }
    //struct Style의 멤버 선언부
    let bindings: [PatternBindingListSyntax] = config.memberBlock.members
      .compactMap{$0.decl.as(VariableDeclSyntax.self)}
      .compactMap { property in
        property.bindings
      }
    //Style의 변수들 접근해서 [(변수명, 타입)]으로 변환
    let properties: [(name: String, type: TypeSyntax)] = try bindings
      .compactMap { binding in
        guard let binding: PatternBindingSyntax = binding.first,
              let name: String = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let type: TypeSyntax = binding.typeAnnotation?.type
        else {
          throw MacroError.message("style 프로퍼티 변환 실패")
        }
        return (name, type)
      }
      .compactMap({$0})
    //extension으로 style의 변수를 수정하는 func 추가
    let extensionDecl = try ExtensionDeclSyntax(
      extendedType: type,
      inheritanceClause: nil
    ) {
      for property in properties {
        try FunctionDeclSyntax(
          """
          func \(raw: property.name)(_ value: \(property.type)) -> Self {
              var mutableSelf = self
              mutableSelf.config.\(raw: property.name) = value
              return mutableSelf
          }
          """
        )
      }
    }
    
//    //view의 프로퍼티 접근
//    let publicProperties: [(name: String, type: TypeSyntax)] = try structDecl.memberBlock.members
//      .compactMap({$0.decl.as(VariableDeclSyntax.self)})
//      .filter { (member: VariableDeclSyntax) in
//        let modifier: DeclModifierListSyntax = member.modifiers
//        return modifier.contains(where: { $0.name.text == "public" })
//      }
//      .compactMap(\.bindings)
//      .compactMap { binding in
//        guard let binding: PatternBindingSyntax = binding.first,
//              let name: String = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
//              let type: TypeSyntax = binding.typeAnnotation?.type
//        else {
//          throw MacroError.message("view struct의 public 멤버 변환 실패")
//        }
//        return (name, type)
//      }
//      .compactMap{$0}
//    //init생성
//    let paramList = publicProperties.map { FunctionParameterSyntax(
//      firstName: .identifier($0.name),
//      colon: .colonToken(),
//      type: $0.type
//    )} // -> [FunctionParameterSyntax]
//    
//    let signature = FunctionSignatureSyntax(
//      parameterClause: FunctionParameterClauseSyntax {
//        for p in paramList { p }
//      }
//    )
//    
//    let body = CodeBlockSyntax {
//      for p in publicProperties {
//        "self.\(raw: p.name) = \(raw: p.name)"
//      }
//    }
//    
//    let initDecl = try ExtensionDeclSyntax(
//      extendedType: type,
//      inheritanceClause: nil
//    ) {
//      InitializerDeclSyntax(signature: signature, body: body)
//    }
    
    return [extensionDecl] /*+ [initDecl]*/
  }
}

enum MacroError: Error, CustomStringConvertible {
  case message(String)
  
  var description: String {
    switch self {
    case .message(let text):
      return text
    }
  }
}

import SwiftCompilerPlugin
@main
struct ViewConfigurableMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StyleModifierMacro.self,
  ]
}

