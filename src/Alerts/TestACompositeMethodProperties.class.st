Class {
	#name : #TestACompositeMethodProperties,
	#superclass : #TestCase,
	#instVars : [
		'cmp'
	],
	#category : #'Alerts-Tests'
}

{ #category : #'as yet unclassified' }
TestACompositeMethodProperties >> setUp [
	cmp := ACompositeMethodProperties new
]

{ #category : #'as yet unclassified' }
TestACompositeMethodProperties >> testAddAMethodProperties [
	| amthP |
	amthP := AMethodProperties new methodPropertiesFor: TestACompositeMethodProperties >> #setUp.
	cmp addAMethodProperties: amthP.
	self assert: (cmp methodProperties includes: amthP)
]

{ #category : #'as yet unclassified' }
TestACompositeMethodProperties >> testForPackage [
	| amthP |
	amthP := AMethodProperties new methodPropertiesFor: TestACompositeMethodProperties >> #setUp.
	self assert: (cmp methodProperties includes: amthP) not.
	cmp addAMethodProperties: amthP.
	self assert: (cmp methodProperties includes: amthP)
]

{ #category : #'as yet unclassified' }
TestACompositeMethodProperties >> testInitialize [
	self assert: cmp methodProperties size equals: 0
]

{ #category : #'as yet unclassified' }
TestACompositeMethodProperties >> testRemoveAMethodProperties [
	| amthP |
	amthP := AMethodProperties new methodPropertiesFor: ResourceForAMethodProperties >> #getAlertsFromFileNamed:.
	cmp forPackage: 'Alerts'.
	self assert: (cmp methodProperties includes: amthP) .
	cmp removeAMethodProperties: amthP.
	self assert: (cmp methodProperties includes: amthP) not
]
