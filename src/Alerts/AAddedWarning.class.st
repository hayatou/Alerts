Class {
	#name : #AAddedWarning,
	#superclass : #Object,
	#instVars : [
		'version',
		'rule',
		'categorie',
		'package',
		'classe',
		'protocol',
		'selector',
		'variables',
		'retour',
		'literals',
		'pragmas',
		'messages',
		'stamp'
	],
	#category : #Alerts
}

{ #category : #'as yet unclassified' }
AAddedWarning class >> initializeAlertsBetween: aMthP1 and: aMthP2 with: aRule [
	self new initializeAlertsBetween: aMthP1 and: aMthP2 with: aRule
	
]

{ #category : #accessing }
AAddedWarning >> categorie [
	^ categorie
]

{ #category : #accessing }
AAddedWarning >> categorie: anObject [
	categorie := anObject
]

{ #category : #accessing }
AAddedWarning >> classe [
	^ classe
]

{ #category : #accessing }
AAddedWarning >> classe: anObject [
	classe := anObject
]

{ #category : #running }
AAddedWarning >> diffBetween: anOrdCol1 and: anOrdCol2 [
	| del add res |
	del := OrderedCollection withAll: anOrdCol1.
	add := OrderedCollection withAll: anOrdCol2.
	anOrdCol2 do: [ :e | del remove: e ifAbsent: [  ] ].
	anOrdCol1 do: [ :e | add remove: e ifAbsent: [  ] ].
	res := OrderedCollection new.
	res add: del.
	res add: add.
	^ res
]

{ #category : #analysis }
AAddedWarning >> hasAdded: anOrdCol [
	^( anOrdCol size = 2) 
		ifTrue: [^ anOrdCol second size>0 ] 
]

{ #category : #analysis }
AAddedWarning >> hasDeleted: anOrdCol [
	^( anOrdCol size = 2) 
		ifTrue: [^ anOrdCol first size>0 ] 
]

{ #category : #accessing }
AAddedWarning >> initialize [
	super initialize.
	version := OrderedCollection new.
	rule := String new.
	package := String new.	
	categorie := OrderedCollection new.
	classe := String new.
	protocol := OrderedCollection new.
	selector := String new.
	pragmas := OrderedCollection new.
	messages := OrderedCollection new.
	variables := OrderedCollection new.
	literals := OrderedCollection new.
	retour := OrderedCollection new.
	stamp := OrderedCollection new
]

{ #category : #running }
AAddedWarning >> initializeAlertsBetween: aMthP1 and: aMthP2 with: aRule [
	(aMthP2 rulesViolated includes: aRule)
		ifTrue: [ 
	self rule: aRule.
	self package: aMthP1 package.	
	self classe: aMthP1 classe.
	self categorie 
		add: aMthP1 categorie   ;
		add: aMthP2 categorie  .
	self protocol
		add: aMthP1 protocole  ;
		add: aMthP2 protocole .
	self selector: aMthP1 selecteur.
	self retour
		add: aMthP1 retour;
		add: aMthP2 retour.
	self stamp
		add: aMthP1 stamp;
		add: aMthP2 stamp.
	self variables: (self diffBetween: aMthP1 variables and: aMthP2 variables).
	self pragmas: (self diffBetween: aMthP1 pragmas and: aMthP2 pragmas).
	self literals: (self diffBetween: aMthP1 literals and: aMthP2 literals).
	self messages: (self diffBetween: aMthP1 messages and: aMthP2 messages).	
	^ self ].
]

{ #category : #analysis }
AAddedWarning >> isChanged [
	^(self isChanged: (self protocol )) 
		or: [ (self isChanged: (self variables  )) 
				or: [ (self isChanged: (self retour )) 
						or: [ (self isChanged: (self literals  ))
								or:[(self isChanged: (self pragmas ))
										or: [ (self isChanged: (self messages  )) 
											or: [ (self isChanged: (self categorie  )) ] ] ] ] ]]
]

{ #category : #analysis }
AAddedWarning >> isChanged: anOrdCol [
	^ (self hasAdded: anOrdCol) 
		or: [ self hasDeleted: anOrdCol ]
]

{ #category : #accessing }
AAddedWarning >> literals [
	^ literals
]

{ #category : #accessing }
AAddedWarning >> literals: anObject [
	literals := anObject
]

{ #category : #accessing }
AAddedWarning >> messages [
	^ messages
]

{ #category : #accessing }
AAddedWarning >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
AAddedWarning >> package [
	^ package
]

{ #category : #accessing }
AAddedWarning >> package: anObject [
	package := anObject
]

{ #category : #accessing }
AAddedWarning >> pragmas [
	^ pragmas
]

{ #category : #accessing }
AAddedWarning >> pragmas: anObject [
	pragmas := anObject
]

{ #category : #accessing }
AAddedWarning >> protocol [
	^ protocol
]

{ #category : #accessing }
AAddedWarning >> protocol: anObject [
	protocol := anObject
]

{ #category : #accessing }
AAddedWarning >> retour [
	^ retour
]

{ #category : #accessing }
AAddedWarning >> retour: anObject [
	retour := anObject
]

{ #category : #accessing }
AAddedWarning >> rule [
	^ rule
]

{ #category : #accessing }
AAddedWarning >> rule: anObject [
	rule := anObject
]

{ #category : #accessing }
AAddedWarning >> selector [
	^ selector
]

{ #category : #accessing }
AAddedWarning >> selector: anObject [
	selector := anObject
]

{ #category : #running }
AAddedWarning >> setVersions: aVersions [
	self version: aVersions
]

{ #category : #accessing }
AAddedWarning >> stamp [
	^ stamp
]

{ #category : #accessing }
AAddedWarning >> stamp: anObject [
	stamp := anObject
]

{ #category : #accessing }
AAddedWarning >> variables [
	^ variables
]

{ #category : #accessing }
AAddedWarning >> variables: anObject [
	variables := anObject
]

{ #category : #accessing }
AAddedWarning >> version [
	^ version
]

{ #category : #accessing }
AAddedWarning >> version: anObject [
	version := anObject
]
