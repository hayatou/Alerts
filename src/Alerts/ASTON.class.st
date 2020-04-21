"
An ASTON provide a way to create, read and modifies STON files.

"
Class {
	#name : #ASTON,
	#superclass : #Object,
	#instVars : [
		'start'
	],
	#classInstVars : [
		'packageName'
	],
	#category : #Alerts
}

{ #category : #ston }
ASTON class >> getACCWFromDirNamed: aDir [
	| dir result |
	result := OrderedCollection new.
	"dir := '/home/hayatou/Bureau/Pharo-3.0-one-click/Contents/Resources/MooseOk/NewOk/Test' asFileReference."
	aDir asFileReference files
		do: [ :f | 
			| c |
			(f basename endsWith: 'ACCWarning.ston')
				ifTrue: [ 
					c := ASTON getACompositeCWarning: f.
					result addAll: c acwarns] ].
	^ result
]

{ #category : #'as yet unclassified' }
ASTON class >> getACompositeCWarning [
	| aStream     |
	aStream := FileStream readOnlyFileNamed: '*-ACompositeCWarning.ston' .
	^STON fromString: aStream contents
]

{ #category : #'as yet unclassified' }
ASTON class >> getACompositeCWarning: aSTONFile [
	| aStream     |
	aStream := FileStream readOnlyFileNamed: aSTONFile .
	^STON fromString: aStream contents
]

{ #category : #ston }
ASTON class >> getAPackHistoryFromDirName: aDir [
	| dir result |
	result := OrderedCollection new.
	dir := '/home/hayatou/Bureau/Pharo-3.0-one-click/Contents/Resources/MooseOk/NewOk/Test' asFileReference.
	dir files
		do: [ :f | 
			| c |
			(f basename endsWith: 'APackHistory.ston')
				ifTrue: [ 
					c := ASTON getAPackageHistory: f.
					result add: c ] ].
	^ result
]

{ #category : #'as yet unclassified' }
ASTON class >> getAPackageHistory [
	| aStream     |
	aStream := FileStream readOnlyFileNamed: '*-APackHistory.ston' .
	^STON fromString: aStream contents
]

{ #category : #'as yet unclassified' }
ASTON class >> getAPackageHistory: aSTONFile [
	| aStream    |
	aStream := FileStream readOnlyFileNamed: aSTONFile .
	^STON fromString: aStream contents
]

{ #category : #accessing }
ASTON class >> packageName [
	^ packageName
]

{ #category : #accessing }
ASTON class >> packageName: anObject [
	packageName := anObject
]

{ #category : #ston }
ASTON >> generateFile [
	"make a csv file from warnings list"
	| aSTONFile |
	aSTONFile := Smalltalk version asString , '-',ASTON packageName, '.ston'.
	self generateFileNamed: aSTONFile
]

{ #category : #ston }
ASTON >> generateFileNamed: aSTONFile [
	"make a csv file from warnings list"
	| stream |
	stream := FileStream forceNewFileNamed: aSTONFile.
	STON put: self onStreamPretty: stream
]

{ #category : #ston }
ASTON >> generateFileWithSuffix: aString [
	"make a ston file from "
	| aSTONFile |
	aSTONFile := (Smalltalk version asString , '-',ASTON packageName, aString, '.ston') asString .
	self generateFileNamed: aSTONFile
]

{ #category : #ston }
ASTON >> getACCWFromFileNamed: aSTONFile [
	| aStream    |
	aStream := FileStream readOnlyFileNamed: aSTONFile .
	self acwarns: (STON fromString: aStream contents) acwarns
]

{ #category : #'as yet unclassified' }
ASTON >> initialize [ 
	start := 1.
	"packageName:=String new"
]

{ #category : #accessing }
ASTON >> start [
	^ start
]

{ #category : #accessing }
ASTON >> start: anObject [
	start := anObject
]
