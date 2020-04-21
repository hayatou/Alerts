Class {
	#name : #TestAlerts,
	#superclass : #TestCase,
	#instVars : [
		'acsvg'
	],
	#category : #'Alerts-Tests'
}

{ #category : #'as yet unclassified' }
TestAlerts >> setUp [
	acsvg := Alerts new
]

{ #category : #'as yet unclassified' }
TestAlerts >> testAddWarning [
	| warn |
	warn := AMethodProperties new methodPropertiesFor: ResourceForAMethodProperties >> #simpleMethodCallOnVar.
	acsvg addAlert: warn.
	self assert: (acsvg alerts includes: warn)
]

{ #category : #'as yet unclassified' }
TestAlerts >> testAllCorrectedWarnings [
	alerts directory: '/home/hayatou/Bureau/Pharo-3.0-one-click/Contents/Resources/package-cache/Test' asFileReference .
	alerts setWithDirectory: '/home/hayatou/Bureau/Pharo-3.0-one-click/Contents/Resources/package-cache/Test' .
	alerts getAllCorrectedWarnings. 
	self assert: (alerts correctedWarns  acwarns size = 3)
]

{ #category : #'as yet unclassified' }
TestAlerts >> testCollectDataForPackage [
	| amthP warn |
	amthP := AMethodProperties new methodPropertiesFor: ResourceForAMethodProperties >> #simpleMethodCallOnVar.
	acsvg collectDataForPackage: 'Alerts'.
	warn := (acsvg alerts select: [ :e | e = amthP ]) first.
	self assert: warn rulesViolated size equals: 4
]

{ #category : #'as yet unclassified' }
TestAlerts >> testGetAllAddedWarnings [
	| result |
	alerts directory: '/home/oumarou/Desktop/Pharos/Pharo-3.0-one-click.app/Contents/Resources/package-cache/Test' asFileReference .
	alerts setWithDirectory: ''.
	result := alerts getAllAddedWarnings.
	self assert: (result isKindOf: ACompositeCWarning ).
	self assert: (result acwarns size = 2). 
]

{ #category : #'as yet unclassified' }
TestAlerts >> testIncludes [
	| b |
	b := AMethodProperties new.
	b methodPropertiesFor: ResourceForAMethodProperties >> #getAlertsFromFileNamed:.
	alerts collectDataForPackage: 'Alerts-Tests'.
	self assert: (alerts includes: b).
]

{ #category : #'as yet unclassified' }
TestAlerts >> testInitialize [
	self assert: acsvg alerts size equals: 0
]

{ #category : #'as yet unclassified' }
TestAlerts >> testRemoveWarning [
	| warn |
	warn := AMethodProperties new methodPropertiesFor: ResourceForAMethodProperties >> #simpleMethodCallOnVar.
	acsvg collectDataForPackage: 'Alerts'.
	acsvg removeAlert: warn.
	self assert: (acsvg alerts includes: warn) not
]
