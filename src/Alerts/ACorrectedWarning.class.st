"
An ACorrectedWarning represent a warning wich is corrected between two consecutive version of the same package. In other hand it collect all deleted and added items like messages, variables and literals.
=====================================
|a|
a := ACorrectedWarning new.
a initializeAlertsBetween: aMthProp1 and: aMthProp2 with: aRule.

you can also do analysis to see what changed to correct the warning by using the method hasAdded: or hasDeleted: on its instances variables.
=====================================
"
Class {
	#name : #ACorrectedWarning,
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
ACorrectedWarning class >> initializeAlertsBetween: aMthP1 and: aMthP2 with: aRule [
	self new initializeAlertsBetween: aMthP1 and: aMthP2 with: aRule
	
]

{ #category : #accessing }
ACorrectedWarning >> categorie [
	^ categorie
]

{ #category : #accessing }
ACorrectedWarning >> categorie: anObject [
	categorie := anObject
]

{ #category : #accessing }
ACorrectedWarning >> classe [
	^ classe
]

{ #category : #accessing }
ACorrectedWarning >> classe: anObject [
	classe := anObject
]

{ #category : #running }
ACorrectedWarning >> createAPair [
	|cote|
	cote:= (Character value: 39) asString.  
	Transcript show: '"---------------------------------------------"'; cr.
	[Transcript show: 'test := Dictionary new.'; cr.
	Transcript show: 'test at: ' , cote, 'rule' , cote, ' put: ',  cote,self rule asString, cote,'.';cr.
	Transcript show: 'test at: ', cote, ' violation' , cote, ' put: ', cote,self rule asString,'>>', self classe asString,'>>', self selector asString,cote,'.';cr.
	Transcript show: 'test at: ', cote, 'baseFile', cote, ' put: ',  cote, self version first asString,'.mcz',  cote,'.';cr.
	Transcript show: 'test at: ', cote, 'targetFile', cote, ' put: ', cote, self version second asString,'.mcz', cote,'.'; cr.
	Transcript show: 'test at: ', cote, 'packName', cote, ' put: ', cote, self package asString, cote,'.';cr.
	Transcript show: 'allViolations add: test.','.'; cr.] on: Error do: [ Transcript show: 'Error in : ', self rule asString  ].
	Transcript show: '"---------------------------------------------"'; cr.
]

{ #category : #running }
ACorrectedWarning >> diffBetween: anOrdCol1 and: anOrdCol2 [
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
ACorrectedWarning >> hasAdded: anOrdCol [
	^( anOrdCol size = 2) 
		ifTrue: [^ anOrdCol second size>0 ] 
]

{ #category : #analysis }
ACorrectedWarning >> hasDeleted: anOrdCol [
	^( anOrdCol size = 2) 
		ifTrue: [^ anOrdCol first size>0 ] 
]

{ #category : #accessing }
ACorrectedWarning >> initialize [
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
ACorrectedWarning >> initializeAlertsBetween: aMthP1 and: aMthP2 with: aRule [
	(aMthP1 rulesViolated includes: aRule)
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
ACorrectedWarning >> isChanged [
	^(self isChanged: (self protocol )) 
		or: [ (self isChanged: (self variables  )) 
				or: [ (self isChanged: (self retour )) 
						or: [ (self isChanged: (self literals  ))
								or:[(self isChanged: (self pragmas ))
										or: [ (self isChanged: (self messages  )) 
											or: [ (self isChanged: (self categorie  )) ] ] ] ] ]]
]

{ #category : #analysis }
ACorrectedWarning >> isChanged: anOrdCol [
	^ (self hasAdded: anOrdCol) 
		or: [ self hasDeleted: anOrdCol ]
]

{ #category : #accessing }
ACorrectedWarning >> literals [
	^ literals
]

{ #category : #accessing }
ACorrectedWarning >> literals: anObject [
	literals := anObject
]

{ #category : #accessing }
ACorrectedWarning >> messages [
	^ messages
]

{ #category : #accessing }
ACorrectedWarning >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
ACorrectedWarning >> package [
	^ package
]

{ #category : #accessing }
ACorrectedWarning >> package: anObject [
	package := anObject
]

{ #category : #accessing }
ACorrectedWarning >> pragmas [
	^ pragmas
]

{ #category : #accessing }
ACorrectedWarning >> pragmas: anObject [
	pragmas := anObject
]

{ #category : #accessing }
ACorrectedWarning >> protocol [
	^ protocol
]

{ #category : #accessing }
ACorrectedWarning >> protocol: anObject [
	protocol := anObject
]

{ #category : #accessing }
ACorrectedWarning >> retour [
	^ retour
]

{ #category : #accessing }
ACorrectedWarning >> retour: anObject [
	retour := anObject
]

{ #category : #accessing }
ACorrectedWarning >> rule [
	^ rule
]

{ #category : #accessing }
ACorrectedWarning >> rule: anObject [
	rule := anObject
]

{ #category : #accessing }
ACorrectedWarning >> selector [
	^ selector
]

{ #category : #accessing }
ACorrectedWarning >> selector: anObject [
	selector := anObject
]

{ #category : #running }
ACorrectedWarning >> setVersions: aVersions [
	self version: aVersions
]

{ #category : #accessing }
ACorrectedWarning >> stamp [
	^ stamp
]

{ #category : #accessing }
ACorrectedWarning >> stamp: anObject [
	stamp := anObject
]

{ #category : #accessing }
ACorrectedWarning >> variables [
	^ variables
]

{ #category : #accessing }
ACorrectedWarning >> variables: anObject [
	variables := anObject
]

{ #category : #accessing }
ACorrectedWarning >> version [
	^ version
]

{ #category : #accessing }
ACorrectedWarning >> version: anObject [
	version := anObject
]
