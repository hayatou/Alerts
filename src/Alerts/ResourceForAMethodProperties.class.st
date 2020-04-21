Class {
	#name : #ResourceForAMethodProperties,
	#superclass : #Object,
	#category : #'Alerts-Tests'
}

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> assignementLiteral [
	| var |
	var := #yo
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> assignementSimpleMethodCallOnSelf [
	| var |
	var := self new
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> assignementSimpleMethodCallOnVar [
	| var|
	var := var new
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> getAlertsFromFileNamed: aCSVFile [
	| aStream lines tokens |
	tokens := OrderedCollection new.
	aStream := FileStream readOnlyFileNamed: aCSVFile.
	aStream reset.
	lines := self getLinesFrom: aStream.
	lines
		do: [ :line | 
			| tok |
			tok := self getTokensFrom: line.
			tokens add: tok ].
	tokens
		do: [ :tok | 
			| aCRWarn |
			aCRWarn := Alerts new.
			aCRWarn initializeWith: tok.
			aCRWarn rule = ''
				ifFalse: [ self addAlert: aCRWarn ] ]
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> simpleMethodCallOnLiteral [
	'self' new
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> simpleMethodCallOnSelf [
	self new
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> simpleMethodCallOnVar [
	"DO NOT categorize this method
	 usedto trigger a rule in the tests"
	| var|
	var new
]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> simpleMethodWithArgument: var [

]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> simpleMethodWithArguments: var and: var1 [

]

{ #category : #'as yet unclassified' }
ResourceForAMethodProperties >> simpleMethodWithLocal [
	| var |
]
