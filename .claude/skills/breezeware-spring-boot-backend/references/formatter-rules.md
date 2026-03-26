# Breezeware Eclipse Formatter Rules Reference

Extracted from `Breezeware-eclipse-codestyle-formatter-profile.xml`.
Profile name: "Java Conventions [built-in] - Breezeware"

## Core Settings

| Setting                          | Value        |
|----------------------------------|--------------|
| Tab policy                       | **Spaces**   |
| Tab/indent size                  | **4**        |
| Continuation indentation         | **2** (= 8 spaces) |
| Array init continuation indent   | **1** (= 4 spaces) |
| Line split (max line length)     | **120**      |
| Comment line length              | **80**       |
| Blank lines to preserve          | **1**        |
| Use on/off tags                  | **Yes** (`@formatter:on` / `@formatter:off`) |

## Brace Positions (all: end of line)

- Type declaration: end of line
- Method declaration: end of line
- Constructor declaration: end of line
- Block: end of line
- Block in case: end of line
- Switch: end of line
- Enum declaration: end of line
- Enum constant: end of line
- Annotation type: end of line
- Lambda body: end of line
- Record declaration: end of line
- Record constructor: end of line
- Anonymous type: end of line
- Array initializer: end of line

## Blank Lines

| Context                          | Count |
|----------------------------------|-------|
| Before package                   | 0     |
| After package                    | 1     |
| Before imports                   | 1     |
| After imports                    | 1     |
| Between import groups            | 1     |
| Before first class body decl     | 0     |
| After last class body decl       | 0     |
| Before field                     | 0     |
| Before method                    | 1     |
| Before abstract method           | 1     |
| Before member type               | 1     |
| Between type declarations        | 1     |
| Before code block                | 0     |
| After code block                 | 1     |
| At beginning of method body      | 0     |
| At end of method body            | 0     |
| At beginning of code block       | 0     |
| At end of code block             | 0     |
| Between statement groups in switch| 0    |

## New Lines

- Before else: NO (same line as closing brace)
- Before catch: NO
- Before finally: NO
- Before while in do: NO
- After opening brace in array init: NO
- Before closing brace in array init: NO
- After annotation on type: YES
- After annotation on method: YES
- After annotation on field: YES
- After annotation on local variable: YES
- After annotation on parameter: NO
- After annotation on package: YES
- After annotation on enum constant: YES
- After label: NO
- After type annotation: NO

## Keep On One Line (all: NEVER)

- Method body: never
- Type declaration: never
- Anonymous type: never
- Enum declaration: never
- Enum constant: never
- Annotation declaration: never
- Lambda body block: never
- If-then body block: never
- Loop body block: never
- Switch body block: never
- Switch case with arrow: never
- Code block: never
- Record declaration: never
- Record constructor: never
- Simple getter/setter: NO
- Simple for body: NO
- Simple while body: NO
- Simple do-while body: NO
- Simple if: NO
- Then statement: NO
- Else statement: NO
- Guardian clause: NO

## Space Before Opening Brace

Always insert space before `{` for: type, method, constructor, block, switch,
enum, enum constant, annotation type, array initializer, anonymous type,
lambda, record.

## Space Before Parenthesis

- Control statements (if, for, while, switch, catch, try, synchronized): INSERT
- Method invocation: DO NOT INSERT
- Method declaration: DO NOT INSERT
- Constructor declaration: DO NOT INSERT
- Annotation: DO NOT INSERT
- Annotation type member: DO NOT INSERT
- Enum constant: DO NOT INSERT
- Record declaration: DO NOT INSERT
- Parenthesized expression in return/throw: INSERT

## Wrapping

- Wrap before conditional operator: YES
- Wrap before logical operator: YES
- Wrap before additive/multiplicative/bitwise/shift/relational/string concat: YES
- Wrap before assignment operator: NO
- Wrap before OR in multicatch: YES
- Wrap before assertion message: YES
- Wrap before switch case arrow: YES
- Wrap outer expressions when nested: YES
- Join wrapped lines: YES

## Comment Formatting

- Format Javadoc: YES
- Format block comments: YES
- Format line comments: YES
- Format HTML in Javadoc: YES
- Format source code in comments: YES
- Clear blank lines in Javadoc: YES
- Clear blank lines in block comments: YES
- New lines at block boundaries: YES
- New lines at Javadoc boundaries: YES
- Insert new line before root tags: NO
- Insert new line between different tags: NO
- Count line length from starting position: YES
- Indent root tags: NO
- Indent parameter description: NO
- Indent tag description: NO
- Align tags/names/descriptions: YES
- Join lines in comments: YES
