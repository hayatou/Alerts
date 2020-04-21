"
An AMethodProperties allow you to collect from a compiled method all variables, messages, literals in it source and set violated SmallLint rules. 
 ==================================
usage 
------------------------
|a b|
   
a:= AMethodProperties  new.
a methodPropertiesFor: 'aCompiledMethod1'.
"" this collect all informations except rules violation""

b:= AMethodProperties  new.
b methodPropertiesFor: 'aNewVersionOfCompiledMethod1'.
a initializeCorrectedAlertsAgainst: b with: aRule.
------------------------------
and you aCorrectedWarning
==================================== 
"
Class {
	#name : #AMethodProperties,
	#superclass : #Object,
	#instVars : [
		'statements',
		'categorie',
		'classe',
		'selecteur',
		'protocole',
		'package',
		'variables',
		'retour',
		'literals',
		'pragmas',
		'messages',
		'rulesViolated',
		'stamp'
	],
	#category : #Alerts
}

{ #category : #comparing }
AMethodProperties >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self package = anObject package and: [ self classe = anObject classe and: [ self selecteur = anObject selecteur ] ]
]

{ #category : #running }
AMethodProperties >> addedWarningsIn: aMthP [
	"Look for all critics that i did not violate and appear in  in my next version"

	| result |
	result := OrderedCollection new.
	(self package = aMthP package and: [ self classe = aMthP classe and: [ self selecteur = aMthP selecteur ] ])
		ifTrue: [ 
			aMthP rulesViolated
				do: [ :r | 
					(self violate: r)
						ifFalse: [ result add: (self initializeAddedAlertsAgainst: aMthP with: r) ] ] ].
	^ result
]

{ #category : #accessing }
AMethodProperties >> categorie [
	"^ compiledMethod methodClass category asString"
	^ categorie.
]

{ #category : #accessing }
AMethodProperties >> categorie: anObject [
	categorie := anObject
]

{ #category : #accessing }
AMethodProperties >> classe [
"	^ compiledMethod methodClass asString"
		^ classe
]

{ #category : #accessing }
AMethodProperties >> classe: anObject [
	classe := anObject
]

{ #category : #running }
AMethodProperties >> correctedWarningsIn: aMthP [
	"Look for all critics that i violate and did not appear in my next version"

	| result |
	result := OrderedCollection new.
	(self package = aMthP package and: [ self classe = aMthP classe and: [ self selecteur = aMthP selecteur ] ])
		ifTrue: [ 
			self rulesViolated
				do: [ :r | 
					(aMthP violate: r)
						ifFalse: [ result add: (self initializeCorrectedAlertsAgainst: aMthP with: r) ] ] ].
	^ result
]

{ #category : #comparing }
AMethodProperties >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ self package hash
		bitXor:
			(self variables hash
				bitXor:
					(self pragmas hash
						bitXor:
							(self messages hash
								bitXor:
									(self stamp hash
										bitXor:
											(self classe hash
												bitXor:
													(self categorie hash bitXor: (self literals hash bitXor: (self retour hash bitXor: self selecteur hash))))))))
]

{ #category : #initialize }
AMethodProperties >> initialize [
	"compiledMethod := CompiledMethod new."

	pragmas := OrderedCollection new.
	rulesViolated := OrderedCollection new.
	messages := OrderedCollection new.
	variables := OrderedCollection new.
	literals := OrderedCollection new.
	retour := OrderedCollection new.
	"statements  := OrderedCollection new."
	
]

{ #category : #running }
AMethodProperties >> initializeAddedAlertsAgainst: aMthP1 with: aRule [
	"when one of my critic did not appear in my next version, create an instance of ACorrectedWarning with the critic"

	| A |
	A := AAddedWarning new.
	A initializeAlertsBetween: self and: aMthP1 with: aRule.
	^ A
]

{ #category : #running }
AMethodProperties >> initializeCorrectedAlertsAgainst: aMthP1 with: aRule [
	"when one of my critic did not appear in my next version, create an instance of ACorrectedWarning with the critic"

	| A |
	A := ACorrectedWarning new.
	A initializeAlertsBetween: self and: aMthP1 with: aRule.
	^ A
]

{ #category : #accessing }
AMethodProperties >> literals [
	^ literals
]

{ #category : #accessing }
AMethodProperties >> literals: anObject [
	literals := anObject
]

{ #category : #accessing }
AMethodProperties >> messages [
	^ messages
]

{ #category : #accessing }
AMethodProperties >> messages: anObject [
	messages := anObject
]

{ #category : #running }
AMethodProperties >> methodPropertiesFor: aCompiledMethod [
	"Collect data from a compiled method"

	| aRBMethodNode |
	selecteur := aCompiledMethod selector.
	classe := aCompiledMethod methodClass asString.
	protocole := aCompiledMethod protocol asString.
	package := (aCompiledMethod category beginsWith: 'Bogus')
		ifTrue: [ self categorie ]
		ifFalse: [ aCompiledMethod methodClass package packageName ].	
	stamp := aCompiledMethod timeStamp asString.
	categorie := aCompiledMethod methodClass category.
	aRBMethodNode := aCompiledMethod parseTree.
	self receiveData: aRBMethodNode body.
	aRBMethodNode arguments do: [ :e | self receiveData: e ].
	aRBMethodNode pragmas do: [ :e | self receiveData: e ]. 
	"statements := aRBMethodNode body statements value."
]

{ #category : #accessing }
AMethodProperties >> package [
"	^ (self categorie beginsWith: 'Bogus')
		ifTrue: [ self categorie ]
		ifFalse: [ compiledMethod methodClass package packageName]."
		^package
]

{ #category : #accessing }
AMethodProperties >> package: anObject [
	package := anObject
]

{ #category : #accessing }
AMethodProperties >> pragmas [
	^ pragmas
]

{ #category : #accessing }
AMethodProperties >> pragmas: anObject [
	pragmas := anObject
]

{ #category : #accessing }
AMethodProperties >> protocol [
	"^ compiledMethod protocol  asString"
	^ protocole 
]

{ #category : #accessing }
AMethodProperties >> protocole [
	^ protocole
]

{ #category : #accessing }
AMethodProperties >> protocole: anObject [
	protocole := anObject
]

{ #category : #running }
AMethodProperties >> receiveData: aNode [
	"Dispatch the operation depending on the type of AST node we have"

	aNode class = RBAssignmentNode
		ifTrue: [ self receiveDataFromRBAssignmentNode: aNode ].
	aNode class = RBArrayNode
		ifTrue: [ self receiveDataFromRBArrayNode: aNode ].
	aNode class = RBMessageNode
		ifTrue: [ self receiveDataFromRBMessageNode: aNode ].
	aNode class = RBVariableNode
		ifTrue: [ self receiveDataFromRBVariableNode: aNode ].
	aNode class = RBSelfNode
		ifTrue: [ self receiveDataFromRBSelfNode: aNode ].
	aNode class = RBSuperNode
		ifTrue: [ self receiveDataFromRBSuperNode: aNode ].
	aNode class = RBBlockNode
		ifTrue: [ self receiveDataFromRBBlockNode: aNode ].
	aNode class = RBSequenceNode
		ifTrue: [ self receiveDataFromRBSequenceNode: aNode ].
	aNode class = RBReturnNode
		ifTrue: [ self receiveDataFromRBReturnNode: aNode ].
	aNode class = RBCascadeNode
		ifTrue: [ self receiveDataFromRBCascadeNode: aNode ].
	aNode class = RBLiteralArrayNode
		ifTrue: [ self receiveDataFromRBLiteralArrayNode: aNode ].
	aNode class = RBLiteralValueNode
		ifTrue: [ self receiveDataFromRBLiteralValueNode: aNode ].
	aNode class = RBPragmaNode
		ifTrue: [ self receiveDataFromRBPragmaNode: aNode ].
	aNode class = RBArgumentNode
		ifTrue: [ self receiveDataFromRBArgumentNode: aNode ].
	aNode class = RBIdentifierToken
		ifTrue: [ self receiveDataFromRBIdentifiertNode: aNode ].
	aNode class = RBTemporaryNode
		ifTrue: [ self receiveDataFromRBTemporaryNode: aNode ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBArgumentNode: aNode [
	"Collect data from aNode"

	self variables add: aNode name asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBArrayNode: aNode [
	"Collect data from aNode"

	aNode statements do: [ :each | self receiveData: each ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBAssignmentNode: aNode [
	"Collect data from aNode"

	self variables add: aNode variable name asString.
	self receiveData: aNode value
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBBlockNode: aNode [
	"Collect data from aNode"

	self receiveData: aNode body.
	aNode arguments do: [ :each | self receiveData: each ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBCascadeNode: aNode [
	"Collect data from aNode"

	aNode messages do: [ :each | self receiveData: each ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBIdentifiertNode: aNode [
	"Collect data from aNode"

	self variables add: aNode value asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBLiteralArrayNode: aNode [
	"Collect data from aNode"

	aNode contents do: [ :each | self receiveData: each ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBLiteralValueNode: aNode [
	"Collect data from aNode"

	self literals add: aNode value asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBMessageNode: aNode [
	"Collect data from aNode"

	self messages add: aNode selector asString.
	self receiveData: aNode receiver.
	aNode arguments do: [ :each | self receiveData: each ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBPragmaNode: aNode [
	"Collect data from aNode"

	self pragmas add: aNode selector asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBReturnNode: aNode [
	"Collect data from aNode"

	self retour: true.
	self receiveData: aNode value asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBSelfNode: aNode [
	"Collect data from aNode"

	self variables add: aNode name asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBSequenceNode: aNode [
	"Collect data from aNode"

	aNode temporaries do: [ :each | self receiveData: each ].
	aNode statements do: [ :each | self receiveData: each ]
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBSuperNode: aNode [
	"Collect data from aNode"

	self variables add: aNode name asString
]

{ #category : #running }
AMethodProperties >> receiveDataFromRBTemporaryNode: aNode [
	"Collect data from aNode"

	self variables add: aNode token value asString. 

]

{ #category : #running }
AMethodProperties >> receiveDataFromRBVariableNode: aNode [
	"Collect data from aNode"

	self variables add: aNode name asString
]

{ #category : #accessing }
AMethodProperties >> retour [
	^ retour
]

{ #category : #accessing }
AMethodProperties >> retour: anObject [
	retour := anObject
]

{ #category : #accessing }
AMethodProperties >> rulesViolated [
	^ rulesViolated
]

{ #category : #accessing }
AMethodProperties >> rulesViolated: anObject [
	rulesViolated := anObject
]

{ #category : #accessing }
AMethodProperties >> selecteur [
"	^ compiledMethod selector"
	^selecteur
]

{ #category : #accessing }
AMethodProperties >> selecteur: anObject [
	selecteur := anObject
]

{ #category : #accessing }
AMethodProperties >> stamp [
	^ stamp
]

{ #category : #accessing }
AMethodProperties >> stamp: anObject [
	stamp := anObject
]

{ #category : #accessing }
AMethodProperties >> statements [
	^ statements
]

{ #category : #accessing }
AMethodProperties >> statements: anObject [
	statements := anObject
]

{ #category : #accessing }
AMethodProperties >> variables [
	^ variables
]

{ #category : #accessing }
AMethodProperties >> variables: anObject [
	variables := anObject
]

{ #category : #running }
AMethodProperties >> violate: aRule [
	^ self rulesViolated includes: aRule. 
]
